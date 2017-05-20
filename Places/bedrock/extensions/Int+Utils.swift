//
//  UInt32+Utils.swift
//  Bedrock
//
//  Created by Nick Bolton on 7/25/16.
//  Copyright © 2016 Pixelbleed LLC. All rights reserved.
//

import Foundation

extension UInt32 {
    static func random(start: UInt32 = 0, end: UInt32 = UInt32.max) -> UInt32 {
        var result = arc4random_uniform(end-start)
        result += start
        
        return result
    }
}
