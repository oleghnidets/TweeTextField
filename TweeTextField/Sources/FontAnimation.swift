//  Created by Oleg Gnidets on 12/20/17.
//  Copyright © 2017 Oleg Gnidets. All rights reserved.
//

import Foundation
import QuartzCore
import CoreFoundation

internal final class FontAnimation {

	private var displayLink: CADisplayLink?
	private(set) var startTime: CFTimeInterval?

	private var target: Any
	private var selector: Selector


	init(target: Any, selector: Selector) {
		self.target = target
		self.selector = selector

		displayLink = CADisplayLink(target: target, selector: selector)
		displayLink?.add(to: .main, forMode: .commonModes)

		if #available(iOS 10.0, *) {
			displayLink?.preferredFramesPerSecond = 30
		}
	}

	func start() {
		startTime = CFAbsoluteTimeGetCurrent()
		displayLink?.isPaused = false
	}

	func stop() {
		startTime = nil
		displayLink?.isPaused = true
	}
}
