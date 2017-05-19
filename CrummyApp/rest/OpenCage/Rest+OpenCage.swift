//
//  Rest+OpenCage.swift
//  CrummyApp
//
//  Created by Nick Bolton on 5/17/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import Foundation
import CoreLocation

protocol OpenCageRequests {
    func findPlaces(named: String,
                    near location: CLLocation?,
                    onSuccess: (([ForwardGeocodingResult]) -> Void)?,
                    onFailure: DefaultFailureHandler?)
}

extension Rest: OpenCageRequests {
    
    func findPlaces(named: String,
                    near location: CLLocation?,
                    onSuccess: (([ForwardGeocodingResult]) -> Void)? = nil,
                    onFailure: DefaultFailureHandler? = nil) {

        let op = OpenCageForwardGeocodingOperation()
        op.searchTerm = named
        op.boundingCoordinates = buildBounds(from: location)
        op.resultHandler = onSuccess
        op.failureHandler = onFailure
        OperationsManager.shared.seriallyQueueOperation(op)
    }
    
    private func buildBounds(from location: CLLocation?) -> BoundingCoordinates? {
        guard let location = location else { return nil }
        return BoundingCoordinates(location: location)
    }
}
