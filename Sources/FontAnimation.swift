//
//  Copyright (c) 2017-Present Oleg Hnidets
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

import CoreFoundation
import Foundation
import QuartzCore

final class FontAnimation {

	private enum Settings {

		static let preferredFramesPerSecond = 30
	}

	private var displayLink: CADisplayLink?
	private(set) var startTime: CFTimeInterval?

	private let selector: Selector

	init(target: AnyObject, selector: Selector) {
		self.selector = selector

		displayLink = CADisplayLink(target: target, selector: selector)
		displayLink?.preferredFramesPerSecond = Settings.preferredFramesPerSecond
	}

	func start() {
        displayLink?.add(to: .main, forMode: .common)
		displayLink?.isPaused = false

		startTime = CFAbsoluteTimeGetCurrent()
	}

	func stop() {
		startTime = nil

		displayLink?.isPaused = true
	}
}
