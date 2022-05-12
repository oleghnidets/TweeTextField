//
//  Copyright (c) 2017-Present Oleg Hnidets
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

/// An object of the class has a customized placeholder label which has animations on the beginning and ending editing.
open class TweePlaceholderTextField: UITextField {

	/// Animation type when a user begins editing.
	public enum MinimizationAnimationType {
		/** Sets minimum font size immediately when a user begins editing. */
		case immediately

		// May have performance issue on first launch. Need to investigate how to fix.
		/** Sets minimum font size step by step during animation transition when a user begins editing. */
		case smoothly
	}

	/// Default is `immediately`.
	public var minimizationAnimationType: MinimizationAnimationType = .smoothly

	/// Minimum font size for the custom placeholder.
	@IBInspectable public var minimumPlaceholderFontSize: CGFloat = 12
	/// Original (maximum) font size for the custom placeholder.
	@IBInspectable public var originalPlaceholderFontSize: CGFloat = 17
	/// Placeholder animation duration.
	@IBInspectable public var placeholderDuration: Double = 0.5
	/// Color of custom placeholder.
	@IBInspectable public var placeholderColor: UIColor? {
		get {
			placeholderLabel.textColor
		} set {
			placeholderLabel.textColor = newValue
		}
	}
	/// The styled string for a custom placeholder.
	public var attributedTweePlaceholder: NSAttributedString? {
		get {
			placeholderLabel.attributedText
		} set {
			setAttributedPlaceholderText(newValue)
		}
	}

	/// The string that is displayed when there is no other text in the text field.
	@IBInspectable public var tweePlaceholder: String? {
		get {
			placeholderLabel.text
		} set {
			setPlaceholderText(newValue)
		}
	}

	/// The custom insets for `placeholderLabel` relative to the text field.
    /// `top` doesn't have any effect.
	public var placeholderInsets: UIEdgeInsets = .zero

	/// Custom placeholder label. You can use it to style placeholder text.
	public private(set) lazy var placeholderLabel = UILabel()

	///	The current text that is displayed by the label.
	override open var text: String? {
		didSet {
			setPlaceholderSizeImmediately()
		}
	}

	/// The styled text displayed by the text field.
	override open var attributedText: NSAttributedString? {
		didSet {
			setPlaceholderSizeImmediately()
		}
	}

	/// The technique to use for aligning the text.
	override open var textAlignment: NSTextAlignment {
		didSet {
			placeholderLabel.textAlignment = textAlignment
		}
	}

	/// The font used to display the text.
	override open var font: UIFont? {
		didSet {
			configurePlaceholderFont()
		}
	}

	private lazy var minimizeFontAnimation = FontAnimation(
		target: WeakTargetProxy(target: self),
		selector: #selector(minimizePlaceholderFontSize)
	)

	private lazy var maximizeFontAnimation = FontAnimation(
		target: WeakTargetProxy(target: self),
		selector: #selector(maximizePlaceholderFontSize)
	)

	// Constraint properties

	private let placeholderLayoutGuide = UILayoutGuide()
	private var leadingPlaceholderConstraint: NSLayoutConstraint?
	private var trailingPlaceholderConstraint: NSLayoutConstraint?
    private var bottomPlaceholderConstraint: NSLayoutConstraint?
    private var centerYPlaceholderConstraint: NSLayoutConstraint?
	private var placeholderGuideHeightConstraint: NSLayoutConstraint?

	// MARK: Methods

	/// :nodoc:
	override public init(frame: CGRect) {
		super.init(frame: frame)

		initializeSetup()
	}

	/// :nodoc:
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		initializeSetup()
	}

	/// :nodoc:
	override open func awakeFromNib() {
		super.awakeFromNib()

		configurePlaceholderLabel()
		setPlaceholderSizeImmediately()
	}

	/// :nodoc:
	override open func layoutSubviews() {
		super.layoutSubviews()

		configurePlaceholderInsets()
	}

	private func initializeSetup() {
		observe()

		configurePlaceholderLabel()
	}

	// Need to investigate and make code better.
	private func configurePlaceholderLabel() {
		placeholderLabel.textAlignment = textAlignment
		configurePlaceholderFont()
	}

	private func configurePlaceholderFont() {
		placeholderLabel.font = font ?? placeholderLabel.font
		placeholderLabel.font = placeholderLabel.font.withSize(originalPlaceholderFontSize)
	}

	private func setPlaceholderText(_ text: String?) {
		addPlaceholderLabelIfNeeded()
		placeholderLabel.text = text

		setPlaceholderSizeImmediately()
	}

	private func setAttributedPlaceholderText(_ text: NSAttributedString?) {
		addPlaceholderLabelIfNeeded()
		placeholderLabel.attributedText = text

		setPlaceholderSizeImmediately()
	}

	private func observe() {
		let notificationCenter = NotificationCenter.default

		notificationCenter.addObserver(
			self,
			selector: #selector(minimizePlaceholder),
			name: UITextField.textDidBeginEditingNotification,
			object: self
		)

		notificationCenter.addObserver(
			self,
			selector: #selector(maximizePlaceholder),
			name: UITextField.textDidEndEditingNotification,
			object: self
		)
	}

	private func setPlaceholderSizeImmediately() {
		if let text = text, text.isEmpty == false {
			enablePlaceholderHeightConstraint()
			placeholderLabel.font = placeholderLabel.font.withSize(minimumPlaceholderFontSize)
		} else if isEditing == false {
			disablePlaceholderHeightConstraint()
			placeholderLabel.font = placeholderLabel.font.withSize(originalPlaceholderFontSize)
		}
	}

	@objc private func minimizePlaceholder() {
		if let text = text, text.isEmpty == false {
			return
		}

		enablePlaceholderHeightConstraint()
        
        UIView.animate(
            withDuration: isEditing ? placeholderDuration : .zero,
            delay: .zero,
            options: [.preferredFramesPerSecond30],
            animations: {
                self.layoutIfNeeded()
                
                switch self.minimizationAnimationType {
                case .immediately:
                    self.placeholderLabel.font = self.placeholderLabel.font.withSize(self.minimumPlaceholderFontSize)
                case .smoothly:
                    self.minimizeFontAnimation.start()
                }
        },
            completion: { _ in
                self.minimizeFontAnimation.stop()
        })
	}

	@objc private func minimizePlaceholderFontSize() {
		guard let startTime = minimizeFontAnimation.startTime else {
			return
		}

		let timeDiff = CFAbsoluteTimeGetCurrent() - startTime
		let percent = CGFloat(1 - timeDiff / placeholderDuration)

		if percent.isLess(than: .zero) {
			return
		}

		let fontSize = (originalPlaceholderFontSize - minimumPlaceholderFontSize) * percent + minimumPlaceholderFontSize

		DispatchQueue.main.async {
			self.placeholderLabel.font = self.placeholderLabel.font.withSize(fontSize)
		}
	}

	@objc private func maximizePlaceholder() {
		if let text = text, text.isEmpty == false {
			return
		}

		disablePlaceholderHeightConstraint()

		UIView.animate(
			withDuration: placeholderDuration,
			delay: .zero,
			options: [.preferredFramesPerSecond60],
			animations: {
				self.layoutIfNeeded()
				self.maximizeFontAnimation.start()
		}, completion: { _ in
			self.maximizeFontAnimation.stop()
		})
	}

	@objc private func maximizePlaceholderFontSize() {
		guard let startTime = maximizeFontAnimation.startTime else {
			return
		}

		let timeDiff = CFAbsoluteTimeGetCurrent() - startTime
		let percent = CGFloat(timeDiff / placeholderDuration)

		let fontSize = (originalPlaceholderFontSize - minimumPlaceholderFontSize) * percent + minimumPlaceholderFontSize

		DispatchQueue.main.async {
			let size = min(self.originalPlaceholderFontSize, fontSize)
			self.placeholderLabel.font = self.placeholderLabel.font.withSize(size)
		}
	}

	private func addPlaceholderLabelIfNeeded() {
		if placeholderLabel.superview != nil {
			return
		}

        addLayoutGuide(placeholderLayoutGuide)
        disablePlaceholderHeightConstraint()
        
		addSubview(placeholderLabel)
		placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

		leadingPlaceholderConstraint = placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        leadingPlaceholderConstraint?.identifier = "twee.placeholder.leading"
		trailingPlaceholderConstraint = placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        trailingPlaceholderConstraint?.identifier = "twee.placeholder.trailing"
        bottomPlaceholderConstraint = placeholderLabel.bottomAnchor.constraint(equalTo: placeholderLayoutGuide.topAnchor)
        bottomPlaceholderConstraint?.identifier = "twee.placeholder.bottom"

		centerYPlaceholderConstraint = placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
		centerYPlaceholderConstraint?.priority = .defaultHigh
        centerYPlaceholderConstraint?.identifier = "twee.placeholder.centerY"
        
        NSLayoutConstraint.activate([
            leadingPlaceholderConstraint,
            trailingPlaceholderConstraint,
            placeholderLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeholderLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeholderLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomPlaceholderConstraint,
            centerYPlaceholderConstraint
            ].compactMap { $0 }
        )

		configurePlaceholderInsets()
	}

	private func configurePlaceholderInsets() {
		let placeholderRect = self.placeholderRect(forBounds: bounds)

        // leading
		leadingPlaceholderConstraint?.constant = placeholderRect.origin.x + placeholderInsets.left
        // trailing
		let trailing = bounds.width - placeholderRect.maxX
		trailingPlaceholderConstraint?.constant = -trailing - placeholderInsets.right
        // bottom
        bottomPlaceholderConstraint?.constant = -placeholderInsets.bottom
        centerYPlaceholderConstraint?.constant = -placeholderInsets.bottom
	}

	private func enablePlaceholderHeightConstraint() {
		if placeholderLayoutGuide.owningView == nil {
			return
		}

		placeholderGuideHeightConstraint?.isActive = false
		placeholderGuideHeightConstraint = placeholderLayoutGuide.heightAnchor.constraint(equalTo: heightAnchor)
		placeholderGuideHeightConstraint?.isActive = true
	}

	private func disablePlaceholderHeightConstraint() {
		if placeholderLayoutGuide.owningView == nil {
			return
		}

		placeholderGuideHeightConstraint?.isActive = false
		placeholderGuideHeightConstraint = placeholderLayoutGuide.heightAnchor.constraint(equalToConstant: .zero)
		placeholderGuideHeightConstraint?.isActive = true
	}
}
