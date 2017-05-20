//
//  RestOperation.swift
//  CrummyApp
//
//  Created by Nick Bolton on 5/17/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import Foundation
import Alamofire
import HTTPStatusCodes

typealias ValidationHandler = ((ValidationResult) -> Void)

let RestStatusCodeKey = "HttpStatusCode"

struct ValidationResult {
    let ok: Bool
    let error: Error?
    let shouldRetry: Bool
    init(ok: Bool, shouldRetry: Bool, error: Error? = nil) {
        self.ok = ok
        self.shouldRetry = shouldRetry;
        self.error = error;
    }
}

protocol RestOperation {
    
    var baseURL: URL { get }
    var baseVersionedURL: URL { get }
    var sessionManager: SessionManager { get }
    
    func handleUnauthorized(onCompletion: @escaping ValidationHandler)
    
    func validateResponse(response: DataResponse<Any>,
                          onCompletion: @escaping ValidationHandler)
    
    func request(
        _ url: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?)
        -> DataRequest
}

extension RestOperation {
        
    internal func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil)
        -> DataRequest
    {
        return sessionManager.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
    }
    
    internal func handleUnauthorized(onCompletion: @escaping ValidationHandler) {
        let error = NSError(domain: CrummyAppErrorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey : "Unauthorized"])
        onCompletion(ValidationResult(ok: false, shouldRetry: false, error: error))
    }
    
    internal func validateResponse(response: DataResponse<Any>,
                                   onCompletion: @escaping ValidationHandler) {
        
        dumpResponse(response)

        let statusCode = response.response?.statusCodeEnum
        
        if let error = response.result.error {
            onCompletion(ValidationResult(ok: false, shouldRetry: true, error: error))
        } else if let statusCode = statusCode {
            if statusCode.isSuccess  {
                onCompletion(ValidationResult(ok: true, shouldRetry: false))
            } else if statusCode == .unauthorized {
                handleUnauthorized(onCompletion: onCompletion)
            } else {
                let error = NSError(domain: CrummyAppErrorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: "request failed \(statusCode)", RestStatusCodeKey: statusCode.rawValue])
                onCompletion(ValidationResult(ok: false, shouldRetry: statusCode.isServerError, error: error))
            }
        } else {
            let error = NSError(domain: CrummyAppErrorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid http response: no status code"])
            onCompletion(ValidationResult(ok: false, shouldRetry: false, error: error))
        }
    }
    
    private func dumpResponse(_ response: DataResponse<Any>) {
        Logger.shared.debug(response.timeline)
        Logger.shared.debug(response.request ?? "No request")  // original URL request
        if let httpBody = response.request?.httpBody {
            Logger.shared.debug("request body: \(String(data: httpBody, encoding: String.Encoding.utf8) ?? "No request body")")
        }
        Logger.shared.debug("status: \(response.response?.statusCode ?? -1000)")
        if let requestHeaders = response.request?.allHTTPHeaderFields {
            print("request headers:");
            for (name, value) in requestHeaders {
                Logger.shared.debug("\(name) = \(value)")
            }
        }
        if let requestBody = response.request?.httpBody {
            Logger.shared.debug("request body:");
            Logger.shared.debug(NSString(data: requestBody, encoding: String.Encoding.utf8.rawValue) ?? "No request body") // request body
        }
        Logger.shared.debug(response.response ?? "No response") // URL response
        if let responseHeaders = response.response?.allHeaderFields {
            Logger.shared.debug("response headers:");
            for (name, value) in responseHeaders {
                Logger.shared.debug("\(name) = \(value)")
            }
        }
        if let responseBody = response.data {
            Logger.shared.debug(NSString(data: responseBody, encoding: String.Encoding.utf8.rawValue) ?? "No response data") // server data
        }
        if let error = response.result.error {
            Logger.shared.error("Error: \(error)")
        }
    }
    
    internal func defaultHeaders() -> HTTPHeaders {
        return [:] as HTTPHeaders
    }
    
    internal func defaultParameters() -> [String: Any] {
        return [:]
    }
}
