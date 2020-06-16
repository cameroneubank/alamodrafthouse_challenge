//
//  PlaceCoordinate.swift
//  alamo_coding_challenge
//
//  Created by Cameron Eubank on 6/15/20.
//  Copyright © 2020 Cameron Eubank. All rights reserved.
//

import Foundation
import MapKit

/// The entity which represents the `Place` in a coordinate space.
struct PlaceCoordinate: Decodable {
    let lat: Double
    let lng: Double
}

extension PlaceCoordinate {
    
    /// The MapKit friendly representation of `PlaceCoordinate`, `CLLocationCoordinate2D`.
    var mapKitCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat,
                                      longitude: lng)
    }
}
