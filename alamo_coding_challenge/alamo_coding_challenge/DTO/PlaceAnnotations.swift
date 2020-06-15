//
//  PlaceAnnotations.swift
//  alamo_coding_challenge
//
//  Created by Cameron Eubank on 6/15/20.
//  Copyright © 2020 Cameron Eubank. All rights reserved.
//

import Foundation

struct PlaceAnnotations: Decodable {
    let openStreetMap: PlaceOpenStreetMapAnnotations?
    
    enum CodingKeys: String, CodingKey {
        case openStreetMap = "OSM"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        openStreetMap = try container.decodeIfPresent(PlaceOpenStreetMapAnnotations.self, forKey: .openStreetMap)
    }
}

struct PlaceOpenStreetMapAnnotations: Decodable {
    let url: URL?
}
