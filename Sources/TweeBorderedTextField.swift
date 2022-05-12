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

/// Represents a line containing path and layer.
final class Line {
	var path = UIBezierPath()
	var layer = CAShapeLayer()
}

/// Custom offset of bottom line.
public struct BorderOffset {
	let x: CGFloat // swiftlint:disable:this identifier_name
	let y: CGFloat // swiftlint:disable:this identifier_name
}

/// An object of the class can show bottom line permanently.
open class TweeBorderedTextField: TweePlaceholderTextField {

    /// Specifies offset for the bottom line based on default border coordinates.
	public var borderOffset = BorderOffset(x: .zero, y: .zero)

	/// Color of bottom line.
	@IBInspectable public var lineColor: UIColor {
		get {
			if let strokeColor = line.layer.strokeColor {
				return UIColor(cgColor: strokeColor)
			}

			return .clear
		} set {
			line.layer.strokeColor = newValue.cgColor
		}
	}

	/// Width of bottom line.
	@IBInspectable public var lineWidth: CGFloat {
		get {
			line.layer.lineWidth
		} set {
			line.layer.lineWidth = newValue
		}
	}

	private var line = Line()

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
	override open func layoutSubviews() {
		super.layoutSubviews()

		calculateLine(line)
	}

	private func initializeSetup() {
		configureBottomLine()
	}

	private func configureBottomLine() {
		line.layer.fillColor = UIColor.clear.cgColor
		layer.addSublayer(line.layer)
	}

    func calculateLine(_ line: Line) {
		// Path
		line.path = UIBezierPath()

		let yOffset = frame.height - (line.layer.lineWidth * 0.5) + borderOffset.y

		let startPoint = CGPoint(x: .zero, y: yOffset)
		line.path.move(to: startPoint)

		let endPoint = CGPoint(x: frame.width + borderOffset.x, y: yOffset)
		line.path.addLine(to: endPoint)

		// Layer
		let interfaceDirection = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute)
		let path = interfaceDirection == .rightToLeft ? line.path.reversing() : line.path

		line.layer.path = path.cgPath
	}
}
