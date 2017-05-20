//
//  Logging.swift
//  Traits
//
//  Created by Nick Bolton on 11/14/16.
//  Copyright © 2016 Pixelbleed, LLC. All rights reserved.
//

import UIKit
import SwiftyBeaver

class Logger: NSObject {
    
    static let shared = Logger()
    private override init() {
        let console = ConsoleDestination()
        console.minLevel = .debug
        console.format = "$DHH:mm:ss$d $L $M"
        SwiftyBeaver.self.addDestination(console)
    }
    
    /// log something generally unimportant (lowest priority)
    public func verbose(_ message: @autoclosure () -> Any) {
        SwiftyBeaver.self.verbose(message)
    }
    
    /// log something which help during debugging (low priority)
    public func debug(_ message: @autoclosure () -> Any) {
        SwiftyBeaver.self.debug(message)
    }
    
    /// log something which you are really interested but which is not an issue or error (normal priority)
    public func info(_ message: @autoclosure () -> Any) {
        SwiftyBeaver.self.info(message)
    }
    
    /// log something which may cause big trouble soon (high priority)
    public func warning(_ message: @autoclosure () -> Any) {
        SwiftyBeaver.self.warning(message)
    }
    
    /// log something which will keep you awake at night (highest priority)
    public func error(_ message: @autoclosure () -> Any) {
        SwiftyBeaver.self.error(message)
    }
}
