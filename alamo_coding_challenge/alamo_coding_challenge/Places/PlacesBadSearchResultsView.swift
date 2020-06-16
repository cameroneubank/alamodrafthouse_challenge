//
//  PlacesBadSearchResultsView.swift
//  alamo_coding_challenge
//
//  Created by Cameron Eubank on 6/15/20.
//  Copyright © 2020 Cameron Eubank. All rights reserved.
//

import Foundation
import UIKit

/// `UIView` informing the user that there was an issue when querying for places.
/// Informs the user an error occured with the request, or there were no places found.
final class PlacesBadSearchResultsView: UIView {
    
    /// The object representing the use cases of the view.
    enum DisplayConfiguration {
        /// There were no results found for the given `keyword`.
        case emptyResults(keyword: String)
        /// There was an error with the request.
        case error
        
        /// The `String` emoji capturing the spirit of the configuration.
        var emojiRepresentation: String {
            switch self {
            case .emptyResults:
                return "🤷"
            case .error:
                return "⚠️"
            }
        }
    }
    
    // MARK: - Subviews
    
    /// `UIScrollView` containing `contentStackView`.
    ///
    /// Allows for content to be scrolled if `contentStackView` exceeds the bounds of the scroll view.
    ///
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    /// `UIStackView` containing all scrollable content.
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    /// `UILabel` displaying a message to the user.
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        label.textColor = .label
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    /// `UILabel` displaying an emoji to the user.
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubviews()
        constrainSubviews()
    }
    
    // MARK: - View utility
    
    /// Adds subviews to the view hierarchy.
    private func addSubviews() {
        contentStackView.addArrangedSubviews([messageLabel, emojiLabel])
        contentScrollView.addSubview(contentStackView)
        addSubview(contentScrollView)
    }
    
    /// Constrains subviews in view hierarchy.
    private func constrainSubviews() {
        NSLayoutConstraint.activate([
            contentScrollView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentScrollView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            contentStackView.topAnchor.constraint(greaterThanOrEqualTo: contentScrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentScrollView.bottomAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: contentScrollView.centerYAnchor)
        ])
    }
    
    // MARK: - Public API
    
    /// Configure the view with a given configuration.
    ///
    /// - parameter configuration: The instance of `DisplayConfiguration` whose properties are shown in the view.
    ///
    func configureMessage(with configuration: DisplayConfiguration) {
        let errorMessage: String
        switch configuration {
        case .emptyResults(let keyword):
            errorMessage = String.localizedStringWithFormat(
                NSLocalizedString("no.search.results",
                                  value: "Oops! We couldn't find any search results for \"%@\"",
                                  comment: "Informs the user there were no search results for the given keyword."),
                keyword
            )
            
        case .error:
            errorMessage = NSLocalizedString("generic.error",
                                             value: "Oops! Something went wrong! Please try again.",
                                             comment: "Informs the user something went wrong and asks them to try again.")
        }
        messageLabel.text = errorMessage
        emojiLabel.text = configuration.emojiRepresentation
    }
}
