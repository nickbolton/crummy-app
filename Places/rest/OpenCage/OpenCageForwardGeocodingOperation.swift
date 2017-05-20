//
//  OpenCageForwardGeocodingOperation.swift
//  Places
//
//  Created by Nick Bolton on 5/17/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import UIKit
import Alamofire
import Elevate

class OpenCageForwardGeocodingOperation: OpenCageRestOperation {

    var searchTerm: String = ""
    var boundingCoordinates: BoundingCoordinates?
    
    var resultHandler: (([ForwardGeocodingResult]) -> Void)?
    
    override func protectedMain(onSuccess: @escaping DefaultHandler, onFailure: @escaping RetryingFailureHandler) {

        let urlString = baseVersionedURL.appendingPathComponent("json").absoluteString
        let qKey = "q"
        let boundsKey = "bounds"

        var params = defaultParameters()
        params[qKey] = searchTerm
        
        if let boundingBox = boundingCoordinates {
            params[boundsKey] = "\(boundingBox.longMin),\(boundingBox.latMin),\(boundingBox.longMax),\(boundingBox.latMax)"
        }
        
        request(
            urlString,
            method: .get,
            parameters: params,
            encoding: URLEncoding.queryString,
            headers: defaultHeaders()).responseJSON { [weak self] response in
                guard let `self` = self else { return }
                self.validateResponse(response: response) { (result) in
                    guard result.ok, let data = response.data else {
                        onFailure(result.error, result.shouldRetry)
                        return
                    }
                    do {
                        
                        guard let decodedJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String, AnyObject> else {
                            let error = NSError(domain: PlacesErrorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid response"])
                            Logger.shared.error("Error occurred decoding json: \(error)")
                            onFailure(error, false)
                            return
                        }
                        
                        guard let statusCode = decodedJson["status"]?["code"] as? Int, statusCode == 200 else {
                            self.fireResultHandler([])
                            onSuccess()
                            return
                        }
                        
                        let resultsKeyPath = "results"
                        let results: [ForwardGeocodingResult] = try Elevate.decodeArray(from: data, atKeyPath: resultsKeyPath, with: ForwardGeocodingResultDecoder())
                        self.fireResultHandler(results)
                        onSuccess()
                    } catch {
                        Logger.shared.error("Error occurred parsing request: \(error)")
                        onFailure(error, false)
                    }
                }
        }
    }
    
    private func fireResultHandler(_ results: [ForwardGeocodingResult]) {
        guard let handler = resultHandler else { return }
        DispatchQueue.main.async {
            handler(results)
        }
    }    
}
