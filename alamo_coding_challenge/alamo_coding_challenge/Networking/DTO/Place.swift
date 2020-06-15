//
//  Place.swift
//  alamo_coding_challenge
//
//  Created by Cameron Eubank on 6/15/20.
//  Copyright © 2020 Cameron Eubank. All rights reserved.
//

import Foundation

struct Place: Decodable {
    let displayName: String
    let coordinate: PlaceCoordinate
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
