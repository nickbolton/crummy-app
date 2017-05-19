//
//  OpenCageForwardGeocodingOperation.swift
//  CrummyApp
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
                            let error = NSError(domain: CrummyAppErrorDomain, code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid response"])
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
    
//    private func parseResults(_ results: [[String: Any]]?) -> [ForwardGeocodingResult] {
//        guard let results = results else {
//            return []
//        }
//        
//        var placeResults = [ForwardGeocodingResult]()
//        
//        for dict in results {
//            guard let geometry = dict[geometryKey] as? [String: Any] else { continue }
//            guard
//                let lat = geometry[latKey] as? Float,
//                let long = geometry[longKey] as? Float,
//                let name = dict[nameKey] as? String else {
//                    continue
//            }
//            placeResults.append(ForwardGeocodingResult(name: name, lat: lat, long: long))
//        }
//        
//        return placeResults
//    }
}
