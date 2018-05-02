//  Created by Oleg Hnidets on 12/20/17.
//  Copyright © 2017-2018 Oleg Hnidets. All rights reserved.
//

import UIKit
import QuartzCore

/// An object of the class can show animated bottom line when a user begins editing.
open class TweeActiveTextField: TweeBorderedTextField {

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

	private var activeLine = Line()

	// MARK: Methods

	public override init(frame: CGRect) {
		super.init(frame: frame)
		initializeSetup()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initializeSetup()
	}

	private func initializeSetup() {
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
