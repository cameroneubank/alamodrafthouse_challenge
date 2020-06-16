//
//  PlaceDetailViewController.swift
//  alamo_coding_challenge
//
//  Created by Cameron Eubank on 6/15/20.
//  Copyright © 2020 Cameron Eubank. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SafariServices

/// `UIViewController` allowing a user to view the details for a given `Place`.
final class PlaceDetailViewController: UIViewController {
    
    private enum Constant {
        static let metersThirtyMiles: Double = 48280
    }
    
    // MARK: - Subviews
    
    /// `MKMapView` displaying the coordinates of `place`.
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    // MARK: - Initialization
    
    /// The instance of `Place` whose coordinates are displayed by `mapView`.
    private let place: Place
    
    /// Initialize an instance of `PlaceDetailViewController`.
    ///
    /// - parameter place: The instance of `Place` displayed.
    ///
    init(place: Place) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("details",
                                  value: "Details",
                                  comment: "Indicates the title of the feature.")
        view.backgroundColor = .systemBackground
        addSubviews()
        constrainSubviews()
        setupSubviews()
    }
    
    // MARK: - View utilty
    
    /// Adds subviews to the view hierarchy of `view`.
    private func addSubviews() {
        view.addSubview(mapView)
    }
    
    /// Constrains subviews in view hierarchy of `view`.
    private func constrainSubviews() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Congigure the subviews in the view hierarchy of `view`.
    private func setupSubviews() {
        let annotation = PlaceAnnotation(place: place)
        let region = MKCoordinateRegion(center: annotation.coordinate,
                                        latitudinalMeters: Constant.metersThirtyMiles,
                                        longitudinalMeters: Constant.metersThirtyMiles)
        mapView.setRegion(mapView.regionThatFits(region), animated: false)
        mapView.addAnnotation(annotation)
    }
    
    /// Presents a `UIAlertController` whose style is actionSheet allowing the user to get directions to a given `Place`.
    ///
    /// - parameter place: The `Place` to provide directions for.
    /// - parameter sourceVice: The `UIView` to provide a source view for the presented `UIAlertController`.
    ///
    private func showMapsAlertSheet(with place: Place, sourceView: UIView) {
        // Create the `UIAlertController` we'll present.
        let alertController = UIAlertController(title: nil,
                                                message: place.displayName,
                                                preferredStyle: .actionSheet)
        
        // Add the "Get directions in Apple Maps" action.
        let directionsInAppleMapsTitle = NSLocalizedString("directions.applemaps",
                                                           value: "Get directions in Apple Maps",
                                                           comment: "Informs the user they may get directions in Apple Maps")
        let appleMapsAction = UIAlertAction(title: directionsInAppleMapsTitle, style: .default) { [weak self] _ in
            guard let self = self else { return }
            let placemark = MKPlacemark(coordinate: self.place.coordinate.mapKitCoordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
        alertController.addAction(appleMapsAction)
        
        // If we have an OpenStreetMap URL, add the "Get directions in Open Street Maps" action.
        if let openStreetMapURL = place.annotations.openStreetMap?.url {
            let directionsInWebTitle = NSLocalizedString("directions.openstreetmap",
                                                         value: "Get directions in Open Street Maps",
                                                         comment: "Informs the user they may get directions in Open Street Maps")
            let openStreetMapAction = UIAlertAction(title: directionsInWebTitle, style: .default) { [weak self] _ in
                // If SFSafariViewController is initialized with a URL whose scheme isn't http or https, a crash will occur.
                guard let self = self, openStreetMapURL.absoluteString.contains("http") else { return }
                let sfSafariViewController = SFSafariViewController(url: openStreetMapURL)
                sfSafariViewController.modalPresentationStyle = .formSheet
                self.present(sfSafariViewController, animated: true, completion: nil)
            }
            alertController.addAction(openStreetMapAction)
        }
        
        // Add a "Cancel" action.
        let cancelTitle = NSLocalizedString("cancel",
                                            value: "Cancel",
                                            comment: "Informs the user they may cancel the operation")
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
        alertController.addAction(cancelAction)
        
        // iPad
        alertController.popoverPresentationController?.sourceView = sourceView
        alertController.popoverPresentationController?.sourceRect = sourceView.bounds
        
        // Lastly, present `alertController`.
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - MKMapViewDelegate

extension PlaceDetailViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? PlaceAnnotation else { return }
        showMapsAlertSheet(with: annotation.place, sourceView: view)
    }
}
