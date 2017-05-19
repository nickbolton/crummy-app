//
//  RetryingOperation.swift
//  Traits
//
//  Created by Nick Bolton on 5/3/17.
//  Copyright © 2017 Pixelbleed, LLC. All rights reserved.
//

import UIKit

typealias RetryingFailureHandler = ((Error?, Bool) -> Void)

class RetryingOperation: Operation {
    
    var userInfo: Any?

    override var isAsynchronous: Bool { return true }
    var returnOnMainThread = true
    var successHandler: DefaultHandler?
    var failureHandler: DefaultFailureHandler?
    var minimumExecutionTime: TimeInterval { return 0.0 }
    var maxRetries = 2
    
    private var error: Error?
    private var succeeded = false
    private var retryCount = 0
    private var startTime: TimeInterval = 0.0
    
    private var _isExecuting = false
    override var isExecuting: Bool {
        get { return _isExecuting }
        set {
            willChangeValue(forKey: "isExecuting")
            _isExecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }

    private var _isFinished = false
    override var isFinished: Bool {
        get { return _isFinished }
        set {
            willChangeValue(forKey: "isFinished")
            _isFinished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }

    var isRetrying: Bool {
        return retryCount > 0
    }
    
    init(maxRetries: Int = 2, userInfo: Any? = nil) {
        super.init()
        self.maxRetries = maxRetries
        self.userInfo = userInfo
    }
    
    private func decrementRetryCount() {
        retryCount = max(retryCount - 1, 0)
    }
    
    override func start() {
        guard Thread.current.isMainThread else {
            DispatchQueue.main.async { [weak self] in
                self?.start()
            }
            return
        }
        
        guard !isCancelled else {
            finish()
            return
        }
        
        startTime = Date.timeIntervalSinceReferenceDate
        retryCount = 0
        succeeded = false
        
        let (ok, error) = shouldExecuteOperation()
        if ok {
            isExecuting = true
            executeMainWithRetryCount()
        } else {
            self.error = error
            finish()
        }
    }
    
    open func protectedMain(onSuccess: @escaping DefaultHandler, onFailure: @escaping RetryingFailureHandler) {
    }
    
    open func shouldExecuteOperation() -> (Bool, Error?) {
        return (true, nil)
    }
    
    private func executeMainWithRetryCount() {
        
        guard retryCount < maxRetries else {
            callFailureHandler()
            return;
        }
        
        error = nil;
        
        protectedMain(onSuccess: { [weak self] in
            self?.succeeded = true
            self?.finish()
        }, onFailure: { [weak self] (error, shouldRetry) in
            self?.error = error
            if shouldRetry {
                self?.retryCount += 1
                self?.executeMainWithRetryCount()
            } else {
                self?.callFailureHandler()
            }
        })
    }
    
    private func finish() {
        isExecuting = false
        isFinished = true
        
        if returnOnMainThread && !Thread.current.isMainThread {
            DispatchQueue.main.async { [weak self] in
                self?.callCompletionHandler()
            }
        } else {
            callCompletionHandler()
        }
    }
    
    private func callCompletionHandler() {
        if succeeded {
            callSuccessHandler()
        } else {
            callFailureHandler()
        }
    }
    
    private func callSuccessHandler() {
        guard let successHandler = successHandler else { return }
        let endTime = Date.timeIntervalSinceReferenceDate
        let duration = endTime - startTime
        let remainingTime = max(minimumExecutionTime - duration, 0.0)
        if remainingTime > 0.0 {
            DispatchQueue.main.asyncAfter(timeInterval: remainingTime) {
                successHandler()
            }
        } else {
            successHandler()
        }
    }
    
    private func callFailureHandler() {
        guard !isFinished else { return }
        isExecuting = false
        isFinished = true
        failureHandler?(error)
    }
}
