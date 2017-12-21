//  Created by Oleg Gnidets on 12/20/17.
//  Copyright © 2017 Oleg Gnidets. All rights reserved.
//

import UIKit
import QuartzCore

/// An object of the class can show animated bottom line when a user begins editing.
public class TweeActiveTextField: TweeBorderedTextField {

	private var activeLine = Line()

	/// Color of line that appears when a user begins editing.
	@IBInspectable public var activeLineColor: UIColor {
		get {
			if let strokeColor = activeLine.layer.strokeColor {
				return UIColor(cgColor: strokeColor)
			}

			return .clear
		} set {
			activeLine.layer.strokeColor = newValue.cgColor
		}
	}

	/// Width of line that appears when a user begins editing.
	@IBInspectable public var activeLineWidth: CGFloat {
		get {
			return activeLine.layer.lineWidth
		} set {
			activeLine.layer.lineWidth = newValue
		}
	}

	/// Width of line that appears when a user begins editing.
	@IBInspectable public private(set) var animationDuration: Double = 1

	// MARK: Methods

	override public func awakeFromNib() {
		super.awakeFromNib()
		initializeTextField()
	}

	private func initializeTextField() {
		observe()
		configureActiveLine()
	}

	private func configureActiveLine() {
		activeLine.layer.fillColor = UIColor.clear.cgColor
		layer.addSublayer(activeLine.layer)
	}

	private func observe() {
		let notificationCenter = NotificationCenter.default

		notificationCenter.addObserver(self,
									   selector: #selector(textFieldDidBeginEditing),
									   name: .UITextFieldTextDidBeginEditing,
									   object: self)

		notificationCenter.addObserver(self,
									   selector: #selector(textFieldDidEndEditing),
									   name: .UITextFieldTextDidEndEditing,
									   object: self)
	}

	@objc private func textFieldDidEndEditing() {
		let animation = CABasicAnimation(path: #keyPath(CAShapeLayer.strokeEnd), fromValue: nil, toValue: 0.0, duration: animationDuration)
		activeLine.layer.add(animation, forKey: "ActiveLineEndAnimation")
	}

	@objc private func textFieldDidBeginEditing() {
		calculateLine(activeLine)

		let animation = CABasicAnimation(path: #keyPath(CAShapeLayer.strokeEnd), fromValue: 0.0, toValue: 1.0, duration: animationDuration)
		activeLine.layer.add(animation, forKey: "ActiveLineStartAnimation")
	}
}

private extension CABasicAnimation {

	convenience init(path: String, fromValue: Any?, toValue: Any?, duration: CFTimeInterval) {
		self.init(keyPath: path)

		self.fromValue = fromValue
		self.toValue = toValue
		self.duration = duration

		isRemovedOnCompletion = false
		fillMode = kCAFillModeForwards
	}
}
