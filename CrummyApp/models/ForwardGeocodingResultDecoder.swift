//
//  ForwardGeocodingResultDecoder.swift
//  CrummyApp
//
//  Created by Nick Bolton on 5/18/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import Foundation
import Elevate

class ForwardGeocodingResultDecoder: Decoder {
    
    fileprivate struct KeyPath {
        static let lat = "geometry.lat"
        static let lng = "geometry.lng"
        static let formatted = "formatted"
        static let type = "components._type"
    }

    func decode(_ json: Any) throws -> Any {
        let entity = try Parser.parseEntity(json: json) { schema in
            schema.addProperty(keyPath: KeyPath.lat, type: .double)
            schema.addProperty(keyPath: KeyPath.lng, type: .double)
            schema.addProperty(keyPath: KeyPath.formatted, type: .string)
            schema.addProperty(keyPath: KeyPath.type, type: .string)
        }
        
        let lat: Double = entity <-! KeyPath.lat
        let lng: Double = entity <-! KeyPath.lng
        let formatted: String = entity <-! KeyPath.formatted
        let name = formatted.components(separatedBy: ",").first ?? formatted
        let type = LocationType(rawValue: entity <-! KeyPath.type) ?? LocationType.nonCinema
        
        return ForwardGeocodingResult(lat: lat,
                                      lng: lng,
                                      name: name,
                                      type: type)
    }
}
