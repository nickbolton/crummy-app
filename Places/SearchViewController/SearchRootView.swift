//
//  SearchRootView.swift
//  Places
//
//  Created by Nick Bolton on 5/17/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import UIKit

protocol SearchInteractionHandler {
    func searchView(_: SearchRootView, didUpdateSearchTerm: String)
    func searchViewDidTapSearchButton(_: SearchRootView, searchTerm: String)
}

class SearchRootView: BaseView, UITextFieldDelegate {
    
    var interactionHandler: SearchInteractionHandler?
    var emptyState = false { didSet { updateEmptyState() } }
    var isSearching = false { didSet { updateSearchingState() } }
    var isConnectedToInternet = false { didSet { updateConnectivityState() } }

    var isLookingForOtherPlaces = true {
        didSet {
            let placeholder = isLookingForOtherPlaces ? "search-placeholder-other-title" : "search-placeholder-title"
            updateSearchPlaceholder(placeholder.localized())
        }
    }

    let tableView = UITableView()
    private let searchContainer = UIView()
    private let searchIconImageView = UIImageView()
    private let searchField = UITextField()
    private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
    private let messageLabel = UILabel()
    private let topCoverView = UIView()
    private var searchBottomConstraint: NSLayoutConstraint?
    
    private let defaultMargins: CGFloat = 6.0
    
    // MARK: View Hierarchy Construction
    
    override func initializeViews() {
        super.initializeViews()
        self.backgroundColor = UIColor.defaultBackgroundColor
        initializeSearchContainer()
        initializeSearchIconImageView()
        initializeSearchField()
        initializeMessageLabel()
        initializeTableView()
        initializeTopCoverView()
    }
    
    override func assembleViews() {
        super.assembleViews()
        addSubview(searchContainer)
        addSubview(tableView)
        addSubview(topCoverView)
        addSubview(messageLabel)
        searchContainer.addSubview(searchIconImageView)
        searchContainer.addSubview(activityIndicatorView)
        searchContainer.addSubview(searchField)
    }
    
    override func constrainViews() {
        super.constrainViews()
        constrainMessageLabel()
        constrainSearchContainer()
        constrainSearchIconImageView()
        constrainActivityIndicatorView()
        constrainSearchField()
        constrainTableView()
        constrainTopCoverView()
    }
    
    // MARK: Message Label
    
    private func initializeMessageLabel() {
        messageLabel.textColor = UIColor.titleColor
        messageLabel.font = UIFont.systemFont(ofSize: 32.0)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.isHidden = true
    }
    
    private func constrainMessageLabel() {
        messageLabel.alignTop()
        messageLabel.expandWidth()
        messageLabel.alignBottom(toTopOfView: searchContainer)
    }
    
    // MARK: Search Container
    
    private func initializeSearchContainer() {
        let cornerRadius: CGFloat = 8.0
        searchContainer.backgroundColor = UIColor.searchBackgroundColor
        searchContainer.layer.cornerRadius = cornerRadius
    }
    
    private func constrainSearchContainer() {
        let height: CGFloat = 55.0
        searchContainer.alignLeading(offset: defaultMargins)
        searchContainer.alignTrailing(offset: -defaultMargins)
        searchContainer.layout(height: height)
        searchBottomConstraint = searchContainer.alignBottom(offset: -defaultMargins)
    }
    
    // MARK: Search Icon Image View
    
    private func initializeSearchIconImageView() {
        searchIconImageView.image = UIImage(named: "search")?.withRenderingMode(.alwaysTemplate)
        searchIconImageView.contentMode = .scaleAspectFit
        searchIconImageView.tintColor = UIColor.appTintColor
    }
    
    private func constrainSearchIconImageView() {
        let size: CGFloat = 22.0
        let leftMargin: CGFloat = 12.0
        searchIconImageView.centerY()
        searchIconImageView.alignLeading(offset: leftMargin)
        searchIconImageView.layout(width: size)
        searchIconImageView.layout(height: size)
    }
    
    // MARK: Activity Indicator View
    
    private func constrainActivityIndicatorView() {
        let rightMargin: CGFloat = 15.0
        activityIndicatorView.centerY()
        activityIndicatorView.alignTrailing(offset: -rightMargin)
    }
    
    // MARK: Search Field
    
    private func initializeSearchField() {
        
        searchField.keyboardAppearance = .dark
        searchField.autocorrectionType = .no
        searchField.returnKeyType = .search
        searchField.delegate = self
        searchField.adjustsFontSizeToFitWidth = true
        searchField.minimumFontSize = 17.0
        
        searchField.textColor = UIColor.searchFieldTextColor
        searchField.tintColor = UIColor.appTintColor
        isLookingForOtherPlaces = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(nameFieldUpdated(noti:)),
                                               name: Notification.Name.UITextFieldTextDidChange,
                                               object: searchField)
    }
    
    private func constrainSearchField() {
        let sideMargin: CGFloat = 10.0
        let yOffset: CGFloat = 0.0
        searchField.centerY(offset: yOffset)
        searchField.alignLeft(toRightOfView: searchIconImageView, offset: sideMargin)
        searchField.alignRight(toLeftOfView: activityIndicatorView, offset: -sideMargin)
    }
    
    // MARK: Top Cover View
    
    private func initializeTopCoverView() {
        topCoverView.backgroundColor = UIColor.defaultBackgroundColor
    }
    
    private func constrainTopCoverView() {
        topCoverView.expandWidth()
        topCoverView.alignTop()
        topCoverView.layout(height: UIApplication.shared.statusBarFrame.height)
    }
    
    // MARK: Table View
    
    private func initializeTableView() {
        let rowHeight: CGFloat = 72.0
        tableView.rowHeight = rowHeight
        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = UIColor.defaultBackgroundColor
        tableView.separatorColor = .clear
        tableView.register(SearchResultCell.self, forCellReuseIdentifier: NSStringFromClass(SearchResultCell.self))
        tableView.contentInset = UIEdgeInsetsMake(UIApplication.shared.statusBarFrame.height, 0.0, 0.0, 0.0)
    }
    
    private func constrainTableView() {
        tableView.alignTop()
        tableView.expandWidth()
        tableView.alignBottom(toTopOfView: searchContainer, offset: -defaultMargins)
    }
    
    // MARK: Helpers
    
    private func updateSearchPlaceholder(_ placeholder: String) {
        let font = UIFont.systemFont(ofSize: 22.0)
        let placeholderDescriptor = TextDescriptor(text: placeholder,
                                                   color: UIColor.searchFieldPlaceholderTextColor,
                                                   font: font)
        searchField.attributedPlaceholder = placeholderDescriptor.attributedText
    }
    
    private func updateEmptyState() {
        guard isConnectedToInternet else { return }
        tableView.isHidden = emptyState
        messageLabel.isHidden = !emptyState
        updateMessageView(message: "search-empty-title".localized())
    }
    
    private func updateSearchingState() {
        if isSearching {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }
    
    private func updateConnectivityState() {
        tableView.isHidden = !isConnectedToInternet
        messageLabel.isHidden = isConnectedToInternet
        if isConnectedToInternet {
            updateEmptyState()
        } else {
            updateMessageView(message: "no-connectivity-message".localized())
        }
    }
    
    private func updateMessageView(message: String) {
        messageLabel.text = message
    }
    
    // MARK: Search Container Layout
    
    func moveSearchContainer(by offset: CGFloat) {
        searchIconImageView.tintColor = (offset == 0.0) ? UIColor.appTintColor : UIColor.searchIconTypingTintColor
        searchBottomConstraint?.constant = -defaultMargins + offset
        layoutIfNeeded()
    }
    
    // MARK: UITextFieldDelegate Conformance
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = searchField.text {
            interactionHandler?.searchViewDidTapSearchButton(self, searchTerm: text.trimmed)
        }
        return true
    }
    
    func nameFieldUpdated(noti: Notification) {
        if let text = searchField.text {
            interactionHandler?.searchView(self, didUpdateSearchTerm: text.trimmed)
        }
    }
}
