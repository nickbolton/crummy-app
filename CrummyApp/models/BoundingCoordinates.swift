//
//  BoundingCoordinates.swift
//  CrummyApp
//
//  Created by Nick Bolton on 5/18/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import CoreLocation
import MapKit

struct BoundingCoordinates {
    let latMin: Float
    let latMax: Float
    let longMin: Float
    let longMax: Float

    init(location: CLLocation) {
        let regionSizeInMeters: CLLocationDistance = 1000000.0
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, regionSizeInMeters, regionSizeInMeters)
        
        latMin = Float(region.center.latitude - (region.span.latitudeDelta / 2.0))
        latMax = Float(region.center.latitude + (region.span.latitudeDelta / 2.0))
        longMin = Float(region.center.longitude - (region.span.longitudeDelta / 2.0))
        longMax = Float(region.center.longitude + (region.span.longitudeDelta / 2.0))
    }
}
