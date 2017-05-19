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

    private override init() {}

    override public class func initialize() {
        let console = ConsoleDestination()
        console.minLevel = .debug
        console.format = "$DHH:mm:ss$d $L $M"
        SwiftyBeaver.self.addDestination(console)
    }
    
    /// log something generally unimportant (lowest priority)
    public class func verbose(_ message: @autoclosure () -> Any) {
        SwiftyBeaver.self.verbose(message)
    }
    
    /// log something which help during debugging (low priority)
    public class func debug(_ message: @autoclosure () -> Any) {
        SwiftyBeaver.self.debug(message)
    }
    
    /// log something which you are really interested but which is not an issue or error (normal priority)
    public class func info(_ message: @autoclosure () -> Any) {
        SwiftyBeaver.self.info(message)
    }
    
    /// log something which may cause big trouble soon (high priority)
    public class func warning(_ message: @autoclosure () -> Any) {
        SwiftyBeaver.self.warning(message)
    }
    
    /// log something which will keep you awake at night (highest priority)
    public class func error(_ message: @autoclosure () -> Any) {
        SwiftyBeaver.self.error(message)
    }
}
