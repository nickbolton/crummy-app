//
//  Throttle.swift
//  Places
//
//  Created by Nick Bolton on 5/21/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import UIKit

class Throttle: NSObject {
    
    var throttleInterval: TimeInterval = 1.0
    private var lastActionTime: TimeInterval = 0.0

    func throttle(_ action: DefaultHandler) {
        let currentTime = Date.timeIntervalSinceReferenceDate
        guard currentTime - lastActionTime > throttleInterval else {
            return
        }
        lastActionTime = currentTime
        action()
    }
}
