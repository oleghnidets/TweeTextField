//  Created by Oleg Hnidets on 12/20/17.
//  Copyright © 2017-2019 Oleg Hnidets. All rights reserved.
//

import UIKit
import QuartzCore

/// An object of the class can show animated bottom line when a user begins editing.
open class TweeActiveTextField: TweeBorderedTextField {

	enum Settings {

		enum Animation {

			enum Key {
				static let activeStart = "ActiveLineStartAnimation"
				static let activeEnd = "ActiveLineEndAnimation"
			}
		}
	}

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
			activeLine.layer.lineWidth
		} set {
			activeLine.layer.lineWidth = newValue
		}
	}

	/// Width of line that appears when a user begins editing.
	@IBInspectable public var animationDuration: Double = 1

	private var activeLine = Line()

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
	open override func layoutSubviews() {
		super.layoutSubviews()

		if isEditing {
			calculateLine(activeLine)
		}
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

		notificationCenter.addObserver(
			self,
			selector: #selector(showLineAnimation),
			name: UITextField.textDidBeginEditingNotification,
			object: self
		)

		notificationCenter.addObserver(
			self,
			selector: #selector(hideLineAnimation),
			name: UITextField.textDidEndEditingNotification,
			object: self
		)
	}

	@objc private func showLineAnimation() {
        calculateLine(activeLine)

		let animation = CABasicAnimation(
			path: #keyPath(CAShapeLayer.strokeEnd),
			fromValue: CGFloat.zero,
			toValue: CGFloat(1),
			duration: animationDuration
		)

		activeLine.layer.add(animation, forKey: Settings.Animation.Key.activeStart)
    }

    @objc private func hideLineAnimation() {
		let animation = CABasicAnimation(
			path: #keyPath(CAShapeLayer.strokeEnd),
			fromValue: nil,
			toValue: CGFloat.zero,
			duration: animationDuration
		)

        activeLine.layer.add(animation, forKey: Settings.Animation.Key.activeEnd)
    }
}

private extension CABasicAnimation {

	convenience init(path: String, fromValue: Any?, toValue: Any?, duration: CFTimeInterval) {
		self.init(keyPath: path)

		self.fromValue = fromValue
		self.toValue = toValue
		self.duration = duration

		isRemovedOnCompletion = false
		fillMode = CAMediaTimingFillMode.forwards
	}
}
