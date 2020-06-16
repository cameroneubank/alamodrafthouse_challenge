//
//  PlaceAnnotation.swift
//  alamo_coding_challenge
//
//  Created by Cameron Eubank on 6/15/20.
//  Copyright © 2020 Cameron Eubank. All rights reserved.
//

import Foundation
import MapKit

/// `MKPointAnnotation` which represents a given `Place`.
final class PlaceAnnotation: MKPointAnnotation {
    
    // MARK: - Initialization
    
    /// The instance of `Place` whose values are displayed in the annotation.
    let place: Place
    
    /// Initialize an instance of `PlaceAnnotation`.
    ///
    /// - parameter place: The instance of `Place` whose values are displayed.
    ///
    init(place: Place) {
        self.place = place
        super.init()
        title = place.displayName
        coordinate = place.coordinate.mapKitCoordinate
    }
}
