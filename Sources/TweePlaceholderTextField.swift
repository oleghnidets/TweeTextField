//  Created by Oleg Hnidets on 12/20/17.
//  Copyright © 2017-2018 Oleg Hnidets. All rights reserved.
//

import UIKit

/// An object of the class has a customized placeholder label which has animations on the beginning and ending editing.
open class TweePlaceholderTextField: UITextField {

	/// Animation type when a user begins editing.
	public enum MinimizationAnimationType {
		/** Sets minimum font size immediately when a user begins editing. */
		case immediately

		// May have performance issue on first launch. Need to investigate how to fix.
		/** Sets minimum font size step by step during animation transition when a user begins editing */
		case smoothly
	}

	/// Default is `immediately`.
	public var minimizationAnimationType: MinimizationAnimationType = .immediately

	/// Minimum font size for the custom placeholder.
	@IBInspectable public var minimumPlaceholderFontSize: CGFloat = 12
	/// Original (maximum) font size for the custom placeholder.
	@IBInspectable public var originalPlaceholderFontSize: CGFloat = 17
	/// Placeholder animation duration.
	@IBInspectable public var placeholderDuration: Double = 0.5
	/// Color of custom placeholder.
	@IBInspectable public var placeholderColor: UIColor? {
		get {
			return placeholderLabel.textColor
		} set {
			placeholderLabel.textColor = newValue
		}
	}
	/// The styled string for a custom placeholder.
	public var attributedTweePlaceholder: NSAttributedString? {
		get {
			return placeholderLabel.attributedText
		} set {
			setAttributedPlaceholderText(newValue)
		}
	}

	/// The string that is displayed when there is no other text in the text field.
	@IBInspectable public var tweePlaceholder: String? {
		get {
			return placeholderLabel.text
		} set {
			setPlaceholderText(newValue)
		}
	}

    /// The custom insets for `placeholderLabel` relative to the text field.
	public var placeholderInsets: UIEdgeInsets = .zero

	/// Custom placeholder label. You can use it to style placeholder text.
	public private(set) lazy var placeholderLabel = UILabel()

	///	The current text that is displayed by the label.
	open override var text: String? {
		didSet {
			setPlaceholderSizeImmediately()
		}
	}

	/// The styled text displayed by the text field.
	open override var attributedText: NSAttributedString? {
		didSet {
			setPlaceholderSizeImmediately()
		}
	}

	/// The technique to use for aligning the text.
	open override var textAlignment: NSTextAlignment {
		didSet {
			placeholderLabel.textAlignment = textAlignment
		}
	}

	/// The font used to display the text.
	open override var font: UIFont? {
		didSet {
			configurePlaceholderFont()
		}
	}

	private lazy var minimizeFontAnimation = FontAnimation(target: WeakTargetProxy(target: self), selector: #selector(minimizePlaceholderFontSize))
	private lazy var maximizeFontAnimation = FontAnimation(target: WeakTargetProxy(target: self), selector: #selector(maximizePlaceholderFontSize))

	private let placeholderLayoutGuide = UILayoutGuide()
	private var leadingPlaceholderConstraint: NSLayoutConstraint?
	private var trailingPlaceholderConstraint: NSLayoutConstraint?

	private var placeholderGuideHeightConstraint: NSLayoutConstraint?

	// MARK: Methods

    /// :nodoc:
	public override init(frame: CGRect) {
		super.init(frame: frame)

		initializeSetup()
	}

    /// :nodoc:
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		initializeSetup()
	}

    /// :nodoc:
	open override func awakeFromNib() {
		super.awakeFromNib()

		configurePlaceholderLabel()
		setPlaceholderSizeImmediately()
	}

    /// :nodoc:
	open override func layoutSubviews() {
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

		notificationCenter.addObserver(self,
									   selector: #selector(minimizePlaceholder),
									   name: UITextField.textDidBeginEditingNotification,
									   object: self)

		notificationCenter.addObserver(self,
									   selector: #selector(maximizePlaceholder),
									   name: UITextField.textDidEndEditingNotification,
									   object: self)
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
		enablePlaceholderHeightConstraint()

        UIView.animate(withDuration: isEditing ? placeholderDuration : 0, delay: 0, options: [.preferredFramesPerSecond30], animations: {
			self.layoutIfNeeded()

			switch self.minimizationAnimationType {
			case .immediately:
				self.placeholderLabel.font = self.placeholderLabel.font.withSize(self.minimumPlaceholderFontSize)
			case .smoothly:
				self.minimizeFontAnimation.start()
			}
		}, completion: { _ in
			self.minimizeFontAnimation.stop()
		})
	}

	@objc private func minimizePlaceholderFontSize() {
		guard let startTime = minimizeFontAnimation.startTime else {
			return
		}

		let timeDiff = CFAbsoluteTimeGetCurrent() - startTime
		let percent = CGFloat(1 - timeDiff / placeholderDuration)

		if percent < 0 {
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

		UIView.animate(withDuration: placeholderDuration, delay: 0, options: [.preferredFramesPerSecond60], animations: {
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

		addSubview(placeholderLabel)
		placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

		leadingPlaceholderConstraint = placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
		leadingPlaceholderConstraint?.isActive = true

		trailingPlaceholderConstraint = placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
		trailingPlaceholderConstraint?.isActive = true

		addLayoutGuide(placeholderLayoutGuide)

		NSLayoutConstraint.activate([
			placeholderLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
			placeholderLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
			placeholderLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor)
			])

		disablePlaceholderHeightConstraint()

		let centerYConstraint = placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
		centerYConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            placeholderLabel.bottomAnchor.constraint(equalTo: placeholderLayoutGuide.topAnchor),
            centerYConstraint
            ])

		configurePlaceholderInsets()
	}

	private func configurePlaceholderInsets() {
		let placeholderRect = self.placeholderRect(forBounds: bounds)

		leadingPlaceholderConstraint?.constant = placeholderRect.origin.x + placeholderInsets.left

		let trailing = bounds.width - placeholderRect.maxX
		trailingPlaceholderConstraint?.constant = -trailing - placeholderInsets.right
	}

	private func enablePlaceholderHeightConstraint() {
        guard placeholderLayoutGuide.owningView != nil else {
            return
        }

		placeholderGuideHeightConstraint?.isActive = false
		placeholderGuideHeightConstraint = placeholderLayoutGuide.heightAnchor.constraint(equalTo: heightAnchor)
		placeholderGuideHeightConstraint?.isActive = true
	}

	private func disablePlaceholderHeightConstraint() {
        guard placeholderLayoutGuide.owningView != nil else {
            return
        }

		placeholderGuideHeightConstraint?.isActive = false
		placeholderGuideHeightConstraint = placeholderLayoutGuide.heightAnchor.constraint(equalToConstant: 0)
		placeholderGuideHeightConstraint?.isActive = true
	}
}
