//
//  OperationsManager.swift
//  Traits
//
//  Created by Nick Bolton on 5/3/17.
//  Copyright © 2017 Pixelbleed, LLC. All rights reserved.
//

import UIKit

class OperationsManager: NSObject {

    static let shared = OperationsManager()
    private override init() {}
    
    private let concurrentQueue = OperationQueue()
    private let serialQueue = SerialOperationQueue()
    
    // MARK: Public
    
    func concurrentlyQueueOperation(_ op: Operation) {
        concurrentQueue.addOperation(op)
    }
    
    func seriallyQueueOperation(_ op: Operation) {
        serialQueue.addOperation(op)
    }
    
    func cancelAllOperations() {
        cancelQueuedOperations()
        cancelConcurrentOperations()
    }
    
    func cancelQueuedOperations() {
        serialQueue.cancelAllOperations()
    }
    
    func cancelConcurrentOperations() {
        concurrentQueue.cancelAllOperations()
    }
}
