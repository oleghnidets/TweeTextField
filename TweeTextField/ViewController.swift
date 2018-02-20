//  Created by Oleg Hnidets on 12/12/17.
//  Copyright © 2017 Oleg Hnidets. All rights reserved.
//

import UIKit

extension String {

	var isValidEmail: Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: self)
	}
}

final class ViewController: UIViewController {

	@IBOutlet private weak var usernameTextField: TweeBorderedTextField!

	@IBOutlet private weak var passwordTextField: TweeActiveTextField!

	@IBOutlet private weak var emailTextField: TweeAttributedTextField!

	override func viewDidLoad() {
		super.viewDidLoad()
		usernameTextField.text = "text"
	}

	@IBAction private func confirm() {
		emailTextField.becomeFirstResponder()
//		view.endEditing(true)
	}

	@IBAction private func emailBeginEditing(_ sender: TweeAttributedTextField) {
		emailTextField.hideInfo()
	}

	@IBAction private func emailEndEditing(_ sender: TweeAttributedTextField) {
		if let emailText = sender.text, emailText.isValidEmail == true {
			return
		}

		sender.showInfo("Email address is incorrect. Check it out")
	}
}
