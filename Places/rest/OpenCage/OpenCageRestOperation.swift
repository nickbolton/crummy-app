//
//  OpenCageRestOperation.swift
//  Traits
//
//  Created by Nick Bolton on 5/3/17.
//  Copyright © 2017 Pixelbleed, LLC. All rights reserved.
//

import Foundation
import Alamofire

class OpenCageRestOperation: RetryingOperation, RestOperation {
    
    var baseURL = URL(string: "http://api.opencagedata.com/geocode/")!
    var baseVersionedURL: URL { return baseURL.appendingPathComponent("v1") }
    
    private let _sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 10.0
        
        return SessionManager(configuration: configuration)
    }()
    
    var sessionManager: SessionManager { return _sessionManager }
        
    internal func defaultParameters() -> [String: Any] {
        let apiKeyKey = "key"
        let apiKey = "b668b715551c836569f3b8faf9a95259"
        return [apiKeyKey : apiKey]
    }
}
