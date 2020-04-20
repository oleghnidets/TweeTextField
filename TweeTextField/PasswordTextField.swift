//
//  Copyright (c) 2017-2020 Oleg Hnidets
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
