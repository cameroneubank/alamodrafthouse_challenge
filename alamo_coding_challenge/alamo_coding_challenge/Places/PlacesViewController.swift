//
//  PlacesViewController.swift
//  alamo_coding_challenge
//
//  Created by Cameron Eubank on 6/15/20.
//  Copyright © 2020 Cameron Eubank. All rights reserved.
//

import Foundation
import UIKit

final class PlacesViewController: UIViewController {
    
    // MARK: - Subviews
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: String(describing: PlaceTableViewCell.self))
        tableView.tableFooterView = UIView() // Removes extraneous cell separators.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var progressIndicatorContainerView: UIView = {
        let view = UIView()
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        indicator.startAnimating()
        let preferredSize = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        view.frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: preferredSize.height)
        return view
    }()
    
    private let badSearchResultsView: PlacesBadSearchResultsView = {
        let view = PlacesBadSearchResultsView()
        view.alpha = 0.0 // Initially hidden until `showBadSearchResultsViewIfNeeded()` is called.
        view.translatesAutoresizingMaskIntoConstraints = false
        view.preservesSuperviewLayoutMargins = true
        return view
    }()
    
    // MARK: - Controllers
    
    private let networkingController = PlacesNetworkingController()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.searchBar.returnKeyType = .done
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = NSLocalizedString("search.intruction",
                                                             value: "Search for a keyword",
                                                             comment: "Instructs the user to search for places using a keyword.")
        return controller
    }()
    
    // MARK: - Data source(s)
    
    private var places = [Place]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - UIViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        title = NSLocalizedString("places",
                                  value: "Places",
                                  comment: "Indicates the title of the feature.")
        view.backgroundColor = .systemBackground
        navigationItem.searchController = searchController
        addSubviews()
        constrainSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Deselect any selected indexPath in `tableView`.
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }
    
    // MARK: - View utility
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func constrainSubviews() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    private func showProgressIndicator() {
        tableView.tableFooterView = progressIndicatorContainerView
    }
    
    private func hideProgressIndicator() {
        tableView.tableFooterView = UIView()
    }
    
    private func showBadSearchResultsViewIfNeeded(with configuration: PlacesBadSearchResultsView.DisplayConfiguration) {
        guard badSearchResultsView.superview == nil else { return }
        badSearchResultsView.configureMessage(with: configuration)
        view.addSubview(badSearchResultsView)
        NSLayoutConstraint.activate([
            badSearchResultsView.topAnchor.constraint(equalTo: tableView.topAnchor),
            badSearchResultsView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            badSearchResultsView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            badSearchResultsView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.badSearchResultsView.alpha = 1.0
        }
    }
    
    private func hideBadSearchResultsViewIfNeeded() {
        guard badSearchResultsView.superview != nil else { return }
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.badSearchResultsView.alpha = 0.0
        }) { [weak self] _ in
            self?.badSearchResultsView.removeFromSuperview()
        }
    }
    
    // MARK: - Target-action
    
    @objc private func getPlaces(_ keyword: String) {
        showProgressIndicator()
        networkingController.getPlaces(keyword: keyword) { result in
            self.hideProgressIndicator()
            switch result {
            case .success(let places):
                self.places = places
                if places.isEmpty {
                    self.showBadSearchResultsViewIfNeeded(with: .emptyResults(keyword: keyword))
                } else {
                    self.hideBadSearchResultsViewIfNeeded()
                }
            case .failure:
                self.showBadSearchResultsViewIfNeeded(with: .error)
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension PlacesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard (0...places.count).contains(indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlaceTableViewCell.self)) as? PlaceTableViewCell
        else {
            return UITableViewCell()
        }
        let place = places[indexPath.row]
        cell.textLabel?.text = place.displayName
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PlacesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        let placeDetailViewController = PlaceDetailViewController(place: place)
        show(placeDetailViewController, sender: self)
    }
}

// MARK: - UISearchResultsUpdating

extension PlacesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchInput = searchController.searchBar.text, !searchInput.isEmpty else {
            // Clear any places displayed and remove `badSearchResultsView` if necessary.
            places.removeAll()
            hideBadSearchResultsViewIfNeeded()
            return
        }
        
        // In an effort to not bombard the service with requests per keystroke:
        // - Cancel any previous perform requests in flight.
        // - Perform the action 1.0 second after the user stops typing.
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(getPlaces(_:)), with: searchInput, afterDelay: 1.0)
    }
}
