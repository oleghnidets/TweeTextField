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
			infoLabel.textColor
		} set {
			infoLabel.textColor = newValue
		}
	}

	/// Font size of info text. If you want to change font use `infoLabel` property.
	@IBInspectable public var infoFontSize: CGFloat {
		get {
			infoLabel.font.pointSize
		} set {
			infoLabel.font = infoLabel.font.withSize(newValue)
		}
	}

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

	private func initializeSetup() {
		plugInfoLabel()
	}

	/// Shows info label with/without animation.
	/// - Parameters:
	///   - text: Custom attributed text to show.
	///   - animated: By default is `true`.
    @objc(showAttributtedInfo:animated:)
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
    @objc public func showInfo(_ text: String, animated: Bool = true) {
		guard animated else {
			infoLabel.text = text
			return
		}

		UIView.transition(
			with: infoLabel,
			duration: infoAnimationDuration,
			options: [.transitionCrossDissolve],
			animations: {
				self.infoLabel.alpha = 1
				self.infoLabel.text = text
		})
	}

	/// Hides the info label with animation or not.
	/// - Parameter animated: By default is `true`.
    @objc public func hideInfo(animated: Bool = true) {
		guard animated else {
			infoLabel.alpha = .zero
			return
		}

		UIView.animate(withDuration: infoAnimationDuration) {
			self.infoLabel.alpha = .zero
		}
	}

	private func plugInfoLabel() {
		guard infoLabel.superview == nil else {
			return
		}

		addSubview(infoLabel)
		infoLabel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			infoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .zero),
			infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: .zero),
			infoLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 2)
			])
	}
}
