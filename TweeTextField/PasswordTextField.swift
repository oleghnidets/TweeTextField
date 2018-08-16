//  Created by Oleg H. on 8/16/18.
//  Copyright © 2018 Oleg Gnidets. All rights reserved.
//

import UIKit

extension UITextField {
	func addLeftArrowButton() {
		let arrowButton = UIButton()
		arrowButton.setImage(#imageLiteral(resourceName: "drop_button"), for: .normal)
		arrowButton.imageView?.contentMode = .center

		leftViewMode = .always
		leftView = arrowButton
	}

	func addRightArrowButton() {
		let arrowButton = UIButton()
		arrowButton.setImage(#imageLiteral(resourceName: "drop_button"), for: .normal)
		arrowButton.imageView?.contentMode = .center

		rightViewMode = .always
		rightView = arrowButton
	}
}

class PasswordTextField: TweeAttributedTextField {
	override func awakeFromNib() {
		super.awakeFromNib()

		addLeftArrowButton()
		addRightArrowButton()
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		leftView?.frame = CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height)
		rightView?.frame = CGRect(x: bounds.width - bounds.size.height, y: 0, width: bounds.height, height: bounds.height)
	}
}
