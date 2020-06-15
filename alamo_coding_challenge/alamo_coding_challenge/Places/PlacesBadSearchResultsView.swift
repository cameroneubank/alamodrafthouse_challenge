//
//  PlacesBadSearchResultsView.swift
//  alamo_coding_challenge
//
//  Created by Cameron Eubank on 6/15/20.
//  Copyright © 2020 Cameron Eubank. All rights reserved.
//

import Foundation
import UIKit

final class PlacesBadSearchResultsView: UIView {
    
    enum DisplayConfiguration {
        case emptyResults(keyword: String)
        case error
        
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
    
    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textAlignment = .center
        label.textColor = .label
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
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
    
    private func addSubviews() {
        contentStackView.addArrangedSubviews([messageLabel, emojiLabel])
        contentScrollView.addSubview(contentStackView)
        addSubview(contentScrollView)
    }
    
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
