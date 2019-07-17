//  Created by Oleg Hnidets on 12/20/17.
//  Copyright © 2017-2019 Oleg Hnidets. All rights reserved.
//

import UIKit

/// Represents a line containing path and layer.
internal class Line {
	var path = UIBezierPath()
	var layer = CAShapeLayer()
}

/// Сustom offset of bottom line.
public struct BorderOffset {
	let x: CGFloat // swiftlint:disable:this identifier_name
	let y: CGFloat // swiftlint:disable:this identifier_name
}

/// An object of the class can show bottom line permanently.
open class TweeBorderedTextField: TweePlaceholderTextField {

    /// Specifies offset for the bottom line based on default border coordinates.
	public var borderOffset = BorderOffset(x: 0, y: 0)

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
			return line.layer.lineWidth
		} set {
			line.layer.lineWidth = newValue
		}
	}

	private var line = Line()

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

	internal func calculateLine(_ line: Line) {
		// Path
		line.path = UIBezierPath()

		let yOffset = frame.height - (line.layer.lineWidth * 0.5) + borderOffset.y

		let startPoint = CGPoint(x: 0, y: yOffset)
		line.path.move(to: startPoint)

		let endPoint = CGPoint(x: frame.width + borderOffset.x, y: yOffset)
		line.path.addLine(to: endPoint)

		// Layer
		let interfaceDirection = UIView.userInterfaceLayoutDirection(for: semanticContentAttribute)
		let path = interfaceDirection == .rightToLeft ? line.path.reversing() : line.path

		line.layer.path = path.cgPath
	}
}
