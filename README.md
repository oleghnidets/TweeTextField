# TweeTextField

[![Swift Version][swift-image]][swift-url]
[![License][license-image]][license-url]

This is lightweight library that provides different types of Text Fields based on your needs. I was inspired by [Jan Henneberg](https://uimovement.com/ui/2524/input-field-help/). 

![Preview](/docs/tweetextfield-sample.gif)

## Features

- [x] Customizable placeholder
- [x] Customizable label under text field
- [x] Customizable via Attributes Inspector
- [x] Nice animation for placeholder
- [x] Nice animation for bottom line
- [x] No UITextField behaviours override
- [x] Clean code with divided functionalities
- [x] Easy to use and extend

## Requirements

- iOS 9.0+
- Xcode 9.0+
- Swift 4.0+

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `TweeTextField` by adding it to your `Podfile`:

```ruby
pod 'TweeTextField'
```

To get the full benefits import `TweeTextField` wherever you import UIKit

#### Manually
1. Download and drop `Sources` folder in your project.  
2. Congratulations!  

## Usage

Check out the [documentation](https://oleghnidets.github.io/TweeTextField/) for more details. 
Select one of the text fields provided based on your requirements. In general, you can use `TweeAttributedTextField`. It is a main class with aggregated functionalities of other text fields.

Look at class diagram:

![Class-diagram](/docs/class-diagram.png)

- `TweePlaceholderTextField` has a customized placeholder label which has animations on the beginning and ending editing.
- `TweeBorderedTextField` shows a bottom line permanently.
- `TweeActiveTextField` shows animated bottom line when a user begins editing.
- `TweeAttributedTextField` shows the custom info label under text field. 

You can set up text field based on your preferences via Attributes Inspector. Also the library has some properties accessible for you.
Check out sample project for more information.

![Attributes Inspector](/docs/attributes.png)

```swift
emailTextField.infoTextColor = .yellow
emailTextField.showInfo("Hello World!", animated: true)
		
usernameTextField.lineColor = .green
usernameTextField.lineWidth = 2
```

## Communication

- If you want to contribute, submit a pull request.
- If you found a bug, have suggestions or need help, please, open an issue.
- If you need help, write me oleg.oleksan@gmail.com.
- If you want to [give me](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CVFAEEZJ9DJ3L) some motivation ;] 

## License
Distributed under the MIT license. See ``LICENSE`` for more information.


[swift-image]:https://img.shields.io/badge/swift-4.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE

