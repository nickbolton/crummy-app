//
//  Address.swift
//  CrummyApp
//
//  Created by Nick Bolton on 5/20/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import Foundation

struct Address {
    let name: String
    let houseNumber: String
    let road: String
    let city: String
    let state: String
    let zipCode: String
    
    var street: String {
        var result = houseNumber
        if houseNumber.length > 0 {
            result += " "
        }
        result += road
        if road.length > 0 {
            result += " "
        }
        return result
    }
    
    var cityStateZipCode: String {
        return "\(city), \(state) \(zipCode)"
    }
    
    var formattedAddress: String {
        
        // use an address formattting library…
        
        var result = self.street
        if city.length > 0 {
            if result.length > 0 {
                result += " "
            }
            result += city
        }
        if state.length > 0 {
            if city.length > 0 {
                result += ", "
            } else if result.length > 0 {
                result += " "
            }
            result += state
        }
        if zipCode.length > 0 {
            if result.length > 0 {
                result += " "
            }
            result += zipCode
        }
        
        return result
    }
    
    init(name: String, houseNumber: String, road: String, city: String, state: String, zipCode: String) {
        self.name = name
        self.houseNumber = houseNumber
        self.road = road
        self.city = city
        self.state = state
        self.zipCode = zipCode
    }
}
