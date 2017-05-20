//
//  LocationAnnotation.swift
//  CrummyApp
//
//  Created by Nick Bolton on 5/20/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import UIKit
import MapKit

class LocationAnnotation: NSObject, MKAnnotation {

    var title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        super.init()
    }
}

