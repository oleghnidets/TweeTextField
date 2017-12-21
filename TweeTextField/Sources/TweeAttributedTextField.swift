//  Created by Oleg Gnidets on 12/12/17.
//  Copyright © 2017 Oleg Gnidets. All rights reserved.
//

import UIKit

/// An object of the class can show the custom info label under text field.
public class TweeAttributedTextField: TweeActiveTextField {

	/// Info label that is shown for a user. This label will appear under the text field.
	/// You can use it to configure appearance.
	public private(set) lazy var infoLabel = UILabel()

	/// Animation duration for showing and hiding the info label.
	@IBInspectable public private(set) var infoAnimationDuration: Double = 1

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

	override public func awakeFromNib() {
		super.awakeFromNib()
		plugLabelIfNeeded()
	}

	public func showInfo(_ attrText: NSAttributedString, animated: Bool = true) {
		if animated {
			UIView.transition(with: infoLabel, duration: infoAnimationDuration, options: [.transitionCrossDissolve], animations: {
				self.infoLabel.alpha = 1
				self.infoLabel.attributedText = attrText
			})
		} else {
			infoLabel.attributedText = attrText
		}
	}

	/// Shows info label with animation or not.
	/// - Parameters:
	///   - text: Custom text to show.
	///   - animated: By default is `true`.
	public func showInfo(_ text: String, animated: Bool = true) {
		if animated {
			UIView.transition(with: infoLabel, duration: infoAnimationDuration, options: [.transitionCrossDissolve], animations: {
				self.infoLabel.alpha = 1
				self.infoLabel.text = text
			})
		} else {
			infoLabel.text = text
		}
	}

	/// Hides the info label with animation or not.
	/// - Parameter animated: By default is `true`.
	public func hideInfo(animated: Bool = true) {
		if animated {
			UIView.animate(withDuration: infoAnimationDuration) {
				self.infoLabel.alpha = 0
			}
		} else {
			infoLabel.alpha = 0
		}
	}

	private func plugLabelIfNeeded() {
		if infoLabel.superview != nil {
			return
		}

		addSubview(infoLabel)
		infoLabel.translatesAutoresizingMaskIntoConstraints = false

		infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
		infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
		infoLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 2).isActive = true
	}
}
