//
//  BaseView.swift
//  Traits
//
//  Created by Nick Bolton on 8/2/16.
//  Copyright © 2016 Pixelbleed LLC. All rights reserved.
//

import UIKit

class BaseView: UIView {
    
    private var didAddMissingConstraints = false;
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _commonInit()
    }
    
    // MARK: Setup
    
    private func _commonInit() {
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
