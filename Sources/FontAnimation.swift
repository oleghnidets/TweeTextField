//  Created by Oleg Hnidets on 12/20/17.
//  Copyright © 2017-2018 Oleg Hnidets. All rights reserved.
//

import Foundation
import QuartzCore
import CoreFoundation

internal final class FontAnimation {
	private var displayLink: CADisplayLink?
	private(set) var startTime: CFTimeInterval?

	private let selector: Selector

	init(target: AnyObject, selector: Selector) {
		self.selector = selector

		displayLink = CADisplayLink(target: target, selector: selector)
		displayLink?.add(to: .main, forMode: RunLoop.Mode.common)

		if #available(iOS 10.0, *) {
			displayLink?.preferredFramesPerSecond = 30
		}
	}

	func start() {
		displayLink?.isPaused = false

		startTime = CFAbsoluteTimeGetCurrent()
	}

	func stop() {
		startTime = nil

		displayLink?.isPaused = true
	}
}
