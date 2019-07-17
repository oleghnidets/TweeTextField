//  Created by Oleg Hnidets on 12/12/17.
//  Copyright © 2017-2019 Oleg Hnidets. All rights reserved.
//

import UIKit

/// An object of the class can show the custom info label under text field.
open class TweeAttributedTextField: TweeActiveTextField {

	/// Info label that is shown for a user. This label will appear under the text field.
	/// You can use it to configure appearance.
	public private(set) lazy var infoLabel = UILabel()

	/// Animation duration for showing and hiding the info label.
	@IBInspectable public var infoAnimationDuration: Double = 1

	/// Color of info text.
	@IBInspectable public var infoTextColor: UIColor {
		get {
			return infoLabel.textColor
		} set {
			infoLabel.textColor = newValue
		}
	}

	/// Font size of info text. If you want to change font use `infoLabel` property.
	@IBInspectable public var infoFontSize: CGFloat {
		get {
			return infoLabel.font.pointSize
		} set {
			infoLabel.font = infoLabel.font.withSize(newValue)
		}
	}

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

	private func initializeSetup() {
		plugInfoLabel()
	}

	/// Shows info label with/without animation.
	/// - Parameters:
	///   - text: Custom attributed text to show.
	///   - animated: By default is `true`.
	public func showInfo(_ attrText: NSAttributedString, animated: Bool = true) {
		guard animated else {
			infoLabel.attributedText = attrText
			return
		}

		UIView.transition(with: infoLabel, duration: infoAnimationDuration, options: [.transitionCrossDissolve], animations: {
			self.infoLabel.alpha = 1
			self.infoLabel.attributedText = attrText
		})
	}

	/// Shows info label with/without animation.
	/// - Parameters:
	///   - text: Custom text to show.
	///   - animated: By default is `true`.
	public func showInfo(_ text: String, animated: Bool = true) {
		guard animated else {
			infoLabel.text = text
			return
		}

		UIView.transition(with: infoLabel, duration: infoAnimationDuration, options: [.transitionCrossDissolve], animations: {
			self.infoLabel.alpha = 1
			self.infoLabel.text = text
		})
	}

	/// Hides the info label with animation or not.
	/// - Parameter animated: By default is `true`.
	public func hideInfo(animated: Bool = true) {
		guard animated else {
			infoLabel.alpha = 0
			return
		}

		UIView.animate(withDuration: infoAnimationDuration) {
			self.infoLabel.alpha = 0
		}
	}

	private func plugInfoLabel() {
		guard infoLabel.superview == nil else {
			return
		}

		addSubview(infoLabel)
		infoLabel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
			infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
			infoLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 2)
			])
	}
}
