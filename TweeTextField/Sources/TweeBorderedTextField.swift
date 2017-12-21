//  Created by Oleg Gnidets on 12/20/17.
//  Copyright © 2017 Oleg Gnidets. All rights reserved.
//

import UIKit

/// Represents a line containing path and layer.
internal class Line {
	var path = UIBezierPath()
	var layer = CAShapeLayer()
}

/// An object of the class can show bottom line permanently.
public class TweeBorderedTextField: TweePlaceholderTextField {

	private var line = Line()

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

	// MARK: Methods

	override public func awakeFromNib() {
		super.awakeFromNib()
		configureBottomLine()
	}

	private func configureBottomLine() {
		line.layer.fillColor = UIColor.clear.cgColor
		layer.addSublayer(line.layer)
	}

	override public func layoutSubviews() {
		super.layoutSubviews()
		calculateLine(line)
	}

	internal func calculateLine(_ line: Line) {
		// Path
		line.path = UIBezierPath()

		let yOffset = frame.height - line.layer.lineWidth / 2

		let startPoint = CGPoint(x: 0, y: yOffset)
		line.path.move(to: startPoint)

		let endPoint = CGPoint(x: frame.width, y: yOffset)
		line.path.addLine(to: endPoint)

		// Layer
		line.layer.path = line.path.cgPath
	}
}
