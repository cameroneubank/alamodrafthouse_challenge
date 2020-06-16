//
//  UIStackView+.swift
//  alamo_coding_challenge
//
//  Created by Cameron Eubank on 6/15/20.
//  Copyright © 2020 Cameron Eubank. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    
    /// Adds the provided views, each as an arranged subview.
    ///
    /// - parameter views: The array of `UIView` to add.
    ///
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
