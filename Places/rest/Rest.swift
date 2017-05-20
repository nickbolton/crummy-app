//
//  Rest.swift
//  Places
//
//  Created by Nick Bolton on 6/21/16.
//  Copyright © 2016 Pixelbleed LLC. All rights reserved.
//

import UIKit

typealias DefaultHandler = ((Void) -> Void)
typealias DefaultFailureHandler = ((Error?) -> Void)

class Rest: NSObject {
    static let shared = Rest()
    private override init() {}
}
