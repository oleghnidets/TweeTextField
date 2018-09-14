//  Created by Oleg Hnidets on 9/14/18.
//  Copyright © 2018 Oleg Hnidets. All rights reserved.
//

import Foundation

internal final class WeakTargetProxy: NSObject {
	private weak var target: NSObjectProtocol?

	init(target: NSObjectProtocol) {
		self.target = target

		super.init()
	}

	override func responds(to aSelector: Selector!) -> Bool {
		guard let target = target else {
			return super.responds(to: aSelector)
		}

		return target.responds(to: aSelector) || super.responds(to: aSelector)
	}

	override func forwardingTarget(for aSelector: Selector!) -> Any? {
		return target
	}
}
