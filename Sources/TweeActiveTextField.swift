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

import QuartzCore
import UIKit

/// An object of the class can show animated bottom line when a user begins editing.
open class TweeActiveTextField: TweeBorderedTextField {

    enum Settings {
		enum Animation { // swiftlint:disable:this nesting
			enum Key { // swiftlint:disable:this nesting
				static let activeStart = "ActiveLineStartAnimation"
				static let activeEnd = "ActiveLineEndAnimation"
			}
		}
	}
    
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
			activeLine.layer.lineWidth
		} set {
			activeLine.layer.lineWidth = newValue
		}
	}

	/// Animation duration when an active line appears.
	@IBInspectable public var animationDuration: Double = 1

	// MARK: Methods

    /// :nodoc:
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initializeSetup()
    }
    
    /// :nodoc:
	override public init(frame: CGRect) {
		super.init(frame: frame)

		initializeSetup()
	}
    
    /// :nodoc:
	override open func layoutSubviews() {
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
