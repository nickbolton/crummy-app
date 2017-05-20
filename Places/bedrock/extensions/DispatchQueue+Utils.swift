//
//  DispatchQueue+Utils.swift
//  Bedrock
//
//  Created by Nick Bolton on 12/15/16.
//  Copyright © 2016 Pixelbleed LLC. All rights reserved.
//
import Foundation

extension DispatchQueue {
    
    func wait(milliseconds: Int, onCompletion: @escaping DefaultHandler) {
        let seconds = Double(milliseconds) / 1000.0
        wait(timeInterval: seconds, onCompletion: onCompletion)
    }
    
    func wait(timeInterval: TimeInterval, onCompletion: @escaping DefaultHandler) {
        asyncAfter(timeInterval: timeInterval, execute: onCompletion)
    }
    
    public func asyncAfter(timeInterval: TimeInterval, execute work: @escaping @convention(block) () -> Swift.Void) {
        let deadline = DispatchTime.now() + timeInterval
        asyncAfter(deadline: deadline, execute: work)
    }
}
