//  Created by Oleg H. on 9/14/18.
//  Copyright © 2018 Oleg Gnidets. All rights reserved.
//

import UIKit

class AnimatedTextField: TweeAttributedTextField {
	override func awakeFromNib() {
		super.awakeFromNib()

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(startEditing),
			name: UITextField.textDidBeginEditingNotification,
			object: self
		)

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(endEditingText),
			name: UITextField.textDidEndEditingNotification,
			object: self
		)
	}

	@objc private func startEditing() {
		placeholderLabel.textColor = .red
	}

	@objc private func endEditingText() {
		if let text = text, !text.isEmpty {
			placeholderLabel.textColor = .red
		} else {
			placeholderLabel.textColor = .gray
		}
	}
}
