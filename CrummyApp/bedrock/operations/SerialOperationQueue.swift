//
//  SerialOperationQueue.swift
//  Traits
//
//  Created by Nick Bolton on 5/3/17.
//  Copyright © 2017 Pixelbleed, LLC. All rights reserved.
//

import UIKit

class SerialOperationQueue: OperationQueue {

    override init() {
        super.init()
        maxConcurrentOperationCount = 1
    }
    
    override func addOperation(_ op: Operation) {
        if let lastOperation = operations.last {
            if !lastOperation.isFinished {
                op.addDependency(lastOperation)
            }
        }
        super.addOperation(op)
    }
}
