//  Created by Oleg Gnidets on 12/20/17.
//  Copyright © 2017 Oleg Gnidets. All rights reserved.
//

import UIKit

/// An object of the class has a customized placeholder label which has animations on the beginning and ending editing.
public class TweePlaceholderTextField: UITextField {

	/// Animation type when a user begins editing.
	/// - immediately: Sets minimum font size immediately when a user begins editing.
	/// - smoothly: Sets minimum font size step by step during animation transition when a user begins editing.
	public enum MinimizationAnimationType {
		case immediately
		// Has some performance issue on first launch. Need to investigate how to fix.
		case smoothly
	}

	// Public

	/// Default is `immediately`.
	public var minimizationAnimationType: MinimizationAnimationType = .immediately
	/// Minimum font size for the custom placeholder.
	@IBInspectable public private(set) var minimumPlaceholderFontSize: CGFloat = 12
	/// Original (maximum) font size for the custom placeholder.
	@IBInspectable public private(set) var originalPlaceholderFontSize: CGFloat = 17
	/// Placeholder animation duration.
	@IBInspectable public private(set) var placeholderDuration: Double = 0.5
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

	/// Custom placeholder label. You can use it to style placeholder text.
	public private(set) lazy var placeholderLabel = UILabel()

	public override var text: String? {
		didSet {
			setCorrectPlaceholderSize()
		}
	}

	public override var attributedText: NSAttributedString? {
		didSet {
			setCorrectPlaceholderSize()
		}
	}

	// Private

	private var minimizeFontAnimation: FontAnimation!

	private var maximizeFontAnimation: FontAnimation!

	private var bottomConstraint: NSLayoutConstraint?

	// MARK: Methods

	override public func awakeFromNib() {
		super.awakeFromNib()
		initializeTextField()
	}

	private func initializeTextField() {
		observe()

		minimizeFontAnimation = FontAnimation(target: self, selector: #selector(minimizePlaceholderFontSize))
		maximizeFontAnimation = FontAnimation(target: self, selector: #selector(maximizePlaceholderFontSize))

		placeholderLabel.font = placeholderLabel.font.withSize(originalPlaceholderFontSize)
	}

	private func setPlaceholderText(_ text: String?) {
		addPlaceholderLabelIfNeeded()
		placeholderLabel.text = text
	}

	private func setAttributedPlaceholderText(_ text: NSAttributedString?) {
		addPlaceholderLabelIfNeeded()
		placeholderLabel.attributedText = text
	}

	private func observe() {
		let notificationCenter = NotificationCenter.default

		notificationCenter.addObserver(self,
									   selector: #selector(minimizePlaceholder),
									   name: .UITextFieldTextDidBeginEditing,
									   object: self)

		notificationCenter.addObserver(self,
									   selector: #selector(maximizePlaceholder),
									   name: .UITextFieldTextDidEndEditing,
									   object: self)
	}

	@objc private func setCorrectPlaceholderSize() {
		if let text = text, text.isEmpty == false {
			minimizePlaceholder()
		} else if isEditing == false {
			maximizePlaceholder()
		}
	}

	@objc private func minimizePlaceholder() {
		bottomConstraint?.constant = -frame.height

		UIView.animate(withDuration: placeholderDuration, delay: 0, options: [.preferredFramesPerSecond30], animations: {
			self.layoutIfNeeded()

			switch self.minimizationAnimationType {
			case .immediately:
				self.placeholderLabel.font = self.placeholderLabel.font.withSize(self.minimumPlaceholderFontSize)
			case .smoothly:
				self.minimizeFontAnimation.start()
			}
		}) { _ in
			self.minimizeFontAnimation.stop()
		}
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

		bottomConstraint?.constant = 0

		UIView.animate(withDuration: placeholderDuration, delay: 0, options: [.preferredFramesPerSecond30], animations: {
			self.layoutIfNeeded()
			self.maximizeFontAnimation.start()
		}) { (_) in
			self.maximizeFontAnimation.stop()
			// self.placeholderLabel.font = self.placeholderLabel.font.withSize(self.originalPlaceholderFontSize)
		}
	}

	@objc private func maximizePlaceholderFontSize() {
		guard let startTime = maximizeFontAnimation.startTime else {
			return
		}

		let timeDiff = CFAbsoluteTimeGetCurrent() - startTime
		let percent = CGFloat(timeDiff / placeholderDuration)

		let fontSize = (originalPlaceholderFontSize - minimumPlaceholderFontSize) * percent + minimumPlaceholderFontSize

		DispatchQueue.main.async {
			self.placeholderLabel.font = self.placeholderLabel.font.withSize(fontSize)
		}
	}

	private func addPlaceholderLabelIfNeeded() {
		if placeholderLabel.superview != nil {
			return
		}

		addSubview(placeholderLabel)
		placeholderLabel.translatesAutoresizingMaskIntoConstraints = false

		placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		placeholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor).isActive = true
		bottomConstraint = placeholderLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
		bottomConstraint?.isActive = true

		let centerYConstraint = placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
		centerYConstraint.priority = .defaultHigh
		centerYConstraint.isActive = true
	}
}
