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
        emailTextField.placeholderInsets = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
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
        false
    }
}
