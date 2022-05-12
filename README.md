# TweeTextField

[![Swift Version][swift-image]][swift-url]
[![Build][build-image]][build-url]
[![Platform][platform-image]][platform-url]
[![Documentation][docs-image]][docs-url]
[![SPM][spm-image]][spm-url]
[![Pod][pod-image]][pod-url]
[![Carthage][carthage-image]][carthage-url]
[![License][license-image]][license-url]


This is lightweight library that provides different types of Text Fields based on your needs.

![Preview](/docs/tweetextfield-sample.gif)


<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
  - [CocoaPods](#cocoapods)
  - [Swift Package Manager](#swift-package-manager)
  - [Carthage](#carthage)
  - [Manually](#manually)
- [Usage](#usage)
- [Contributing and support](#contributing-and-support)
- [License](#license)

<!-- /code_chunk_output -->


## Features

- [x] Customizable placeholder
- [x] Customizable label under text field
- [x] Customizable via Attributes Inspector
- [x] Nice animation for placeholder
- [x] Nice animation for bottom line
- [x] No override of UITextField' behaviors
- [x] Clean code with divided functionalities
- [x] Easy to use and extend
- [x] Right-to-Left support
- [x] Complete [documentation](https://oleghnidets.github.io/TweeTextField/) and [support](https://github.com/oleghnidets/TweeTextField/issues)

## Requirements

- iOS 11.0+
- Xcode 11.0+
- Swift 5.0+

## Installation 

### CocoaPods
To integrate `TweeTextField` into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'TweeTextField'
```

Then run `pod install` to integrate the library in your project.

### Swift Package Manager
Adding TweeTextField to the dependencies value of your `Package.swift` file.
```swift
// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    dependencies: [
        .package(url: "https://github.com/oleghnidets/TweeTextField.git", from: "1.6.1"),
    ]
)
```

Or you may use Xcode. `File`->`Swift Packages`->`Add Package Dependency`. Then put link to the [repository](https://github.com/oleghnidets/TweeTextField.git).

### Carthage
To integrate `TweeTextField` into your Xcode project using Carthage, specify it in your Cartfile:
```ruby
github "oleghnidets/TweeTextField"
```

Run `carthage update` to build the framework and drag the built `TweeTextField.framework` into your Xcode project. More info you can find on [official page](https://github.com/Carthage/Carthage).


### Manually
1. Download the [code](https://github.com/oleghnidets/TweeTextField/archive/master.zip).
2. Drag and drop sources in your project.
3. Import the library in code by `import TweeTextField`.

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
emailTextField.infoAnimationDuration = 0.7
emailTextField.infoTextColor = .systemRed
emailTextField.infoFontSize = 13
        
emailTextField.activeLineColor = .systemBlue
emailTextField.activeLineWidth = 1
emailTextField.animationDuration = 0.3
        
emailTextField.lineColor = .lightGray
emailTextField.lineWidth = 1
        
emailTextField.minimumPlaceholderFontSize = 10
emailTextField.originalPlaceholderFontSize = 13
emailTextField.placeholderDuration = 0.3
emailTextField.placeholderColor = .systemGray2
emailTextField.tweePlaceholder = "Email address"
emailTextField.placeholderLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
```

## Contributing and support

- If you want to contribute, [submit a pull request](https://github.com/oleghnidets/TweeTextField/compare).
- If you found a bug, have suggestions or need help [open a new issue](https://github.com/oleghnidets/TweeTextField/issues/new).
- If you need help, write me oleg.oleksan@gmail.com.

## License

Distributed under the MIT license. See [LICENSE](https://github.com/oleghnidets/TweeTextField/blob/develop/LICENSE) for more information.


[swift-image]: https://img.shields.io/badge/swift-5-orange.svg
[swift-url]: https://swift.org/

[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE

[spm-image]: https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square
[spm-url]: Package.swift

[docs-image]: docs/badge.svg
[docs-url]: https://oleghnidets.github.io/TweeTextField

[platform-image]: https://img.shields.io/badge/platform-ios-lightgrey.svg
[platform-url]: https://github.com/oleghnidets/TweeTextField

[pod-image]: https://img.shields.io/cocoapods/v/TweeTextField.svg
[pod-url]: http://cocoapods.org/

[carthage-image]: https://img.shields.io/badge/carthage-%E2%9C%93-orange.svg
[carthage-url]: https://github.com/Carthage/Carthage

[build-image]: https://travis-ci.org/oleghnidets/TweeTextField.svg?branch=master
[build-url]: https://travis-ci.org/oleghnidets/TweeTextField
