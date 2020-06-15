//
//  PlaceTableViewCell.swift
//  alamo_coding_challenge
//
//  Created by Cameron Eubank on 6/15/20.
//  Copyright © 2020 Cameron Eubank. All rights reserved.
//

import Foundation
import UIKit

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
        // Dynamic Type
        textLabel?.numberOfLines = 0
        textLabel?.adjustsFontForContentSizeCategory = true
    }
    
    // MARK: - UITableViewCell life cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
    }
    
    // MARK: - Public API
    
    var place: Place? {
        didSet {
            textLabel?.text = place?.displayName
        }
    }
}
