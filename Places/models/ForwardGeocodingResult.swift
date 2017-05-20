//
//  ForwardGeocodingResult.swift
//  Places
//
//  Created by Nick Bolton on 5/18/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import UIKit
import CoreLocation

enum LocationType: String {
    case cinema
    case nonCinema
}

struct ForwardGeocodingResult {
    
    let lat: Double
    let lng: Double
    let address: Address
    let type: LocationType
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(lat, lng)
    }
    
    init(lat: Double, lng: Double, address: Address, type: LocationType) {
        self.lat = lat
        self.lng = lng
        self.address = address
        self.type = type
    }
}
