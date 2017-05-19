//
//  ForwardGeocodingResult.swift
//  CrummyApp
//
//  Created by Nick Bolton on 5/18/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import UIKit

enum LocationType: String {
    case cinema
    case nonCinema
}

struct ForwardGeocodingResult {
    
    let lat: Double
    let lng: Double
    let name: String
    let type: LocationType
    
    init(lat: Double, lng: Double, name: String, type: LocationType) {
        self.lat = lat
        self.lng = lng
        self.name = name
        self.type = type
    }
}
