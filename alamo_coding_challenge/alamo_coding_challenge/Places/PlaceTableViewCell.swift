//
//  PlaceTableViewCell.swift
//  alamo_coding_challenge
//
//  Created by Cameron Eubank on 6/15/20.
//  Copyright © 2020 Cameron Eubank. All rights reserved.
//

import Foundation
import UIKit

/// `UITableViewCell` shown in `PlacesViewController` to represent a single `Place`.
final class PlaceTableViewCell: UITableViewCell {
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        accessoryType = .disclosureIndicator
        textLabel?.numberOfLines = 0 // Dynamic type support
        textLabel?.adjustsFontForContentSizeCategory = true // Dynamic type support
    }
    
    // MARK: - UITableViewCell life cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
    }
    
    // MARK: - Public API
    
    /// The `Place` object displayed by the cell.
    var place: Place? {
        didSet {
            textLabel?.text = place?.displayName
        }
    }
}
