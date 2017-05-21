//
//  SearchResultCell.swift
//  Places
//
//  Created by Nick Bolton on 5/18/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import UIKit

class SearchResultCell: BaseTableViewCell {
    
    private let contentContainer = UIView()
    private let titleLabel = UILabel()
    private let addressLabel = UILabel()
    
    private let margins: CGFloat = 8.0
    private let textSideMargins: CGFloat = 12.0
    
    var title: String = "" { didSet { titleLabel.text = title } }
    var address: String = "" { didSet { addressLabel.text = address } }
    
    override func didInit() {
        super.didInit()
        textLabel?.removeFromSuperview()
        detailTextLabel?.removeFromSuperview()
    }

    // MARK: View Hierarchy Construction
    
    override func initializeViews() {
        super.initializeViews()
        backgroundColor = UIColor.defaultBackgroundColor
        contentView.backgroundColor = UIColor.defaultBackgroundColor
        initializeContentContainer()
        initializeTitleLabel()
        initializeAddressLabel()
    }
    
    override func assembleViews() {
        super.assembleViews()
        addSubview(contentContainer)
        contentContainer.addSubview(titleLabel)
        contentContainer.addSubview(addressLabel)
    }
    
    override func constrainViews() {
        super.constrainViews()
        constrainContentContainer()
        constrainTitleLabel()
        constrainAddressLabel()
    }
    
    // MARK: Content Container
    
    private func initializeContentContainer() {
        let cornerRadius: CGFloat = 8.0
        contentContainer.layer.cornerRadius = cornerRadius
        contentContainer.backgroundColor = UIColor.searchResultColor
    }
    
    private func constrainContentContainer() {
        contentContainer.alignTop()
        contentContainer.alignBottom(offset: -margins)
        contentContainer.alignLeading(offset: margins)
        contentContainer.alignTrailing(offset: -margins)
    }
    
    // MARK: Title Label
    
    private func initializeTitleLabel() {
        titleLabel.textColor = UIColor.primaryTextColor
        titleLabel.font = UIFont.systemFont(ofSize: 22.0)
    }
    
    private func constrainTitleLabel() {
        let topSpace: CGFloat = 9.5
        titleLabel.alignLeading(offset: textSideMargins)
        titleLabel.alignTrailing(offset: -textSideMargins)
        titleLabel.alignTop(offset: topSpace)
    }
    
    // MARK: Address Label
    
    private func initializeAddressLabel() {
        addressLabel.font = UIFont.systemFont(ofSize: 17.0)
        addressLabel.textColor = UIColor.secondaryTextColor
    }
    
    private func constrainAddressLabel() {
        let topSpace: CGFloat = -3.0
        addressLabel.alignLeading(offset: textSideMargins)
        addressLabel.alignTrailing(offset: -textSideMargins)
        addressLabel.alignTop(toBottomOfView: titleLabel, offset: topSpace)
    }
    
    // MARK: Subclass
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        contentContainer.alpha = highlighted ? 0.7 : 1.0
    }
}
