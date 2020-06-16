//
//  PlaceAnnotations.swift
//  alamo_coding_challenge
//
//  Created by Cameron Eubank on 6/15/20.
//  Copyright © 2020 Cameron Eubank. All rights reserved.
//

import Foundation

/// The entity which represents the different annotations of a `Place` object.
struct PlaceAnnotations: Decodable {
    
    /// The optional `PlaceOpenStreetMapAnnotations` of the place.
    let openStreetMap: PlaceOpenStreetMapAnnotations?
    
    enum CodingKeys: String, CodingKey {
        case openStreetMap = "OSM"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        openStreetMap = try container.decodeIfPresent(PlaceOpenStreetMapAnnotations.self, forKey: .openStreetMap)
    }
}

/// The entity representing an annotation of a `Place` object in OpenStreetMaps.
struct PlaceOpenStreetMapAnnotations: Decodable {
    
    /// The optional `URL` of the annotation in OpenStreetMaps.
    let url: URL?
}
