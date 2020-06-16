//
//  Place.swift
//  alamo_coding_challenge
//
//  Created by Cameron Eubank on 6/15/20.
//  Copyright © 2020 Cameron Eubank. All rights reserved.
//

import Foundation

/// The object representing an entity provided by the opencagedata geocode API.
struct Place: Decodable {
    
    /// The `String` display name of the place.
    let displayName: String
    /// The `PlaceCoordinate` of the place.
    let coordinate: PlaceCoordinate
    /// The different types of `PlaceAnnotations` of the place.
    let annotations: PlaceAnnotations
    
    enum CodingKeys: String, CodingKey {
        case displayName = "formatted"
        case coordinate = "geometry"
        case annotations
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        displayName = try container.decode(String.self, forKey: .displayName)
        coordinate = try container.decode(PlaceCoordinate.self, forKey: .coordinate)
        annotations = try container.decode(PlaceAnnotations.self, forKey: .annotations)
    }
}
