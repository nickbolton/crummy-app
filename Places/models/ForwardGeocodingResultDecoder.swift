//
//  ForwardGeocodingResultDecoder.swift
//  Places
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
        static let type = "components._type"
        static let formatted = "formatted"
        static let houseNumber = "components.house_number"
        static let road = "components.road"
        static let city = "components.city"
        static let state = "components.state_code"
        static let postcode = "components.postcode"
    }

    func decode(_ json: Any) throws -> Any {
        let entity = try Parser.parseEntity(json: json) { schema in
            schema.addProperty(keyPath: KeyPath.lat, type: .double)
            schema.addProperty(keyPath: KeyPath.lng, type: .double)
            schema.addProperty(keyPath: KeyPath.type, type: .string)
            schema.addProperty(keyPath: KeyPath.formatted, type: .string)
            schema.addProperty(keyPath: KeyPath.houseNumber, type: .string, optional: true)
            schema.addProperty(keyPath: KeyPath.road, type: .string, optional: true)
            schema.addProperty(keyPath: KeyPath.city, type: .string, optional: true)
            schema.addProperty(keyPath: KeyPath.state, type: .string, optional: true)
            schema.addProperty(keyPath: KeyPath.postcode, type: .string, optional: true)
        }
                
        let lat: Double = entity <-! KeyPath.lat
        let lng: Double = entity <-! KeyPath.lng
        let formatted: String = entity <-! KeyPath.formatted
        let name = formatted.components(separatedBy: ",").first ?? formatted
        let type = LocationType(rawValue: entity <-! KeyPath.type) ?? LocationType.nonCinema
        let houseNumber: String = entity <-? KeyPath.houseNumber ?? ""
        let road: String = entity <-? KeyPath.road ?? ""
        let city: String = entity <-? KeyPath.city ?? ""
        let state: String = entity <-? KeyPath.state ?? ""
        let zipCode: String = entity <-? KeyPath.postcode ?? ""
        
        let address = Address(name: name,
                              houseNumber: houseNumber,
                              road: road,
                              city: city,
                              state: state,
                              zipCode: zipCode)
        
        return ForwardGeocodingResult(lat: lat,
                                      lng: lng,
                                      address: address,
                                      type: type)
    }
}
