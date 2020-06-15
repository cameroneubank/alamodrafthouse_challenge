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

final class PlaceDetailViewController: UIViewController {
    
    private enum Constant {
        static let metersThirtyMiles: Double = 48280
    }
    
    // MARK: - Subviews
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    // MARK: - Initialization
    
    private let place: Place
    
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
        setupSubviews()
        addSubviews()
        constrainSubviews()
        setupSubviews()
    }
    
    // MARK: - View utilty
    
    private func setupView() {
        title = place.displayName
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(mapView)
    }
    
    private func constrainSubviews() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupSubviews() {
        let annotation = PlaceAnnotation(place: place)
        let region = MKCoordinateRegion(center: annotation.coordinate,
                                        latitudinalMeters: Constant.metersThirtyMiles,
                                        longitudinalMeters: Constant.metersThirtyMiles)
        mapView.setRegion(mapView.regionThatFits(region), animated: false)
        mapView.addAnnotation(annotation)
    }
    
    private func showMapsAlertSheet(with place: Place) {
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
        
        // Lastly, present `alertController`.
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - MKMapViewDelegate

extension PlaceDetailViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? PlaceAnnotation else { return }
        showMapsAlertSheet(with: annotation.place)
    }
}
