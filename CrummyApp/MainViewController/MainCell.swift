//
//  MainCell.swift
//  CrummyApp
//
//  Created by Nick Bolton on 5/18/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import UIKit

class MainCell: BaseTableViewCell {
    
    private let contentContainer = UIView()
    private let titleLabel = UILabel()
    private let margins: CGFloat = 6.0
    
    var title: String = "" { didSet { titleLabel.text = title } }
    
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
    }
    
    override func assembleViews() {
        super.assembleViews()
        contentView.addSubview(contentContainer)
        contentContainer.addSubview(titleLabel)
    }
    
    override func constrainViews() {
        super.constrainViews()
        constrainContentContainer()
        constrainTitleLabel()
    }
    
    // MARK: Content Container
    
    private func initializeContentContainer() {
        let cornerRadius: CGFloat = 8.0
        contentContainer.layer.cornerRadius = cornerRadius
        contentContainer.backgroundColor = UIColor.searchBackgroundColor
    }
    
    private func constrainContentContainer() {
        contentContainer.alignTop(offset: margins)
        contentContainer.alignBottom(offset: -margins)
        contentContainer.alignLeading(offset: margins)
        contentContainer.alignTrailing(offset: -margins)
    }
    
    // MARK: Title Label
    
    private func initializeTitleLabel() {
        titleLabel.textColor = UIColor.searchFieldTextColor
        titleLabel.font = UIFont.systemFont(ofSize: 22.0)
    }
    
    private func constrainTitleLabel() {
        let sideMargins: CGFloat = 15.0
        titleLabel.alignLeading(offset: sideMargins)
        titleLabel.alignTrailing(offset: -sideMargins)
        titleLabel.expandHeight()
    }
}
