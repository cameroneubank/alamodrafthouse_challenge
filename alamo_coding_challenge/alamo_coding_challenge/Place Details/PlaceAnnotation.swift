//
//  PlaceAnnotation.swift
//  alamo_coding_challenge
//
//  Created by Cameron Eubank on 6/15/20.
//  Copyright © 2020 Cameron Eubank. All rights reserved.
//

import Foundation
import MapKit

final class PlaceAnnotation: MKPointAnnotation {
    
    let place: Place
    
    init(place: Place) {
        self.place = place
        super.init()
        title = place.displayName
        coordinate = place.coordinate.mapKitCoordinate
    }
}
