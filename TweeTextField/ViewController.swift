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
	@IBOutlet private weak var stackView: UIStackView!
	@IBOutlet private weak var usernameTextField: TweeBorderedTextField!
	@IBOutlet private weak var passwordTextField: TweeActiveTextField!
	@IBOutlet private weak var emailTextField: TweeAttributedTextField!

	override func viewDidLoad() {
		super.viewDidLoad()

        passwordTextField.delegate = self

		passwordTextField.text = "password"
		emailTextField.text = "text"
	}

	@IBAction private func removeFirstField() {
		stackView.arrangedSubviews.first.flatMap {
			$0.removeFromSuperview()
		}
	}

	@IBAction private func confirm() {
		emailTextField.text = "Issue #8"
	}

    @IBAction private func generateNewTextField() {
        let newField = TweeAttributedTextField()
        stackView.addArrangedSubview(newField)

        newField.heightAnchor.constraint(equalToConstant: emailTextField.frame.height).isActive = true

        newField.borderStyle = .roundedRect
        newField.text = "Newly generated"
        newField.tweePlaceholder = "\(Date().description)"
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

extension ViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return false
    }
}
