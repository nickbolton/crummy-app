//
//  BaseTableViewCell.swift
//  Bedrock
//
//  Created by Nick Bolton on 8/10/16.
//  Copyright © 2016 Pixelbleed LLC. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    var didAddMissingConstraints = false;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _commonInit()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _commonInit()
    }
    
    // MARK: Setup
    
    private func _commonInit() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        initializeViews()
        assembleViews()
        constrainViews()
        didInit()
    }
    
    func didInit() {
    }
    
    func initializeViews() {
    }
    
    func assembleViews() {
    }
    
    func constrainViews() {
    }
    
    func canAddMissingConstraints() -> Bool {
        return true
    }
    
    func addMissingConstraints() {
    }
    
    func _addMissingConstraintsIfNecessary() {
        if canAddMissingConstraints() && !didAddMissingConstraints {
            didAddMissingConstraints = true;
            addMissingConstraints()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _addMissingConstraintsIfNecessary()
    }
    
    override var frame: CGRect {
        didSet {
            _addMissingConstraintsIfNecessary()
        }
    }
}
