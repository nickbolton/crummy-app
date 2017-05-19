//
//  BaseOperation.swift
//  Traits
//
//  Created by Nick Bolton on 5/3/17.
//  Copyright © 2017 Pixelbleed, LLC. All rights reserved.
//

import UIKit

class BaseOperation: Operation {

    override func main() {
        guard !isCancelled else { return }
        protectedMain()
    }
    
    func protectedMain() {
        // abstract
    }
}
