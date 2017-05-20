//
//  LocationRootView.swift
//  Places
//
//  Created by Nick Bolton on 5/19/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import UIKit
import MapKit

protocol LocationInteractionHandler {
    func locationViewDidTapCloseButton(_: LocationRootView)
    func locationViewDidTapMapsButton(_: LocationRootView)
}

class LocationRootView: BaseView {
    
    var interactionHandler: LocationInteractionHandler?

    private let dismissContainer = UIView()
    private let contentContainer = UIView()
    private let closeButton = UIButton()
    private let shareButton = UIButton()
    private let favoriteButton = UIButton()
    private let mapsButton = UIButton()
    private let addressSideMargins: CGFloat = 12.0
    private let containerSizeMargins: CGFloat = 8.0
    private let addressLabel = UILabel()
    var address: Address? { didSet { updateAddressLabel() } }
    
    let mapView = MKMapView()
    
    // MARK: View Hierarchy Construction
    
    override func canAddMissingConstraints() -> Bool {
        return frame.width >= (2.0 * containerSizeMargins)
    }
    
    override func addMissingConstraints() {
        constrainDismissContainer()
        constrainContentContainer()
        constrainCloseButton()
        constrainShareButton()
        constrainFavoriteButton()
        constrainMapsButton()
        constrainAddressLabel()
        constrainMapView()
    }
    
    override func initializeViews() {
        super.initializeViews()
        backgroundColor = UIColor.defaultBackgroundColor
        initializeDismissContainer()
        initializeContentContainer()
        initializeCloseButton()
        initializeShareButton()
        initializeFavoriteButton()
        initializeMapsButton()
        initializeAddressLabel()
        initializeMapView()
    }
    
    override func assembleViews() {
        super.assembleViews()
        addSubview(dismissContainer)
        addSubview(contentContainer)
        addSubview(closeButton)
        addSubview(shareButton)
        addSubview(favoriteButton)
        addSubview(mapsButton)
        contentContainer.addSubview(addressLabel)
        contentContainer.addSubview(mapView)
    }
    
    override func constrainViews() {
        super.constrainViews()
    }
    
    // MARK: Dismiss Container
    
    private func initializeDismissContainer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleCloseTap))
        dismissContainer.addGestureRecognizer(gesture)
    }
    
    private func constrainDismissContainer() {
        dismissContainer.expand()
    }
    
    // MARK: Content Container
    
    private func initializeContentContainer() {
        let cornerRadius: CGFloat = 8.0
        contentContainer.layer.cornerRadius = cornerRadius
        contentContainer.backgroundColor = UIColor.locationBackgroundColor
        contentContainer.clipsToBounds = true
    }
    
    private func constrainContentContainer() {
        let aspect: CGFloat = 1.4
        contentContainer.alignLeft(offset: containerSizeMargins)
        contentContainer.alignRight(offset: -containerSizeMargins)
        contentContainer.centerY()
        
        let heightConstraint = NSLayoutConstraint(
            item: contentContainer,
            attribute: .height,
            relatedBy: .equal,
            toItem: contentContainer,
            attribute: .width,
            multiplier: aspect,
            constant: 0);

        heightConstraint.isActive = true
    }
    
    // MARK: Close Button
    
    private func initializeCloseButton() {
        closeButton.setImage(UIImage(named: "x")?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        closeButton.tintColor = UIColor.appTintColor
    }
    
    private func constrainCloseButton() {
        if let image = closeButton.image(for: .normal) {
            closeButton.layout(size: image.size)
            closeButton.alignLeft()
            closeButton.alignBottom()
        }
    }
    
    // MARK: Share Button
    
    private func initializeShareButton() {
        shareButton.setImage(UIImage(named: "share")?.withRenderingMode(.alwaysTemplate), for: .normal)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        shareButton.tintColor = UIColor.appTintColor
    }
    
    private func constrainShareButton() {
        if let image = shareButton.image(for: .normal) {
            shareButton.layout(size: image.size)
            shareButton.alignLeft(toRightOfView: closeButton)
            shareButton.alignBottom()
        }
    }
    
    // MARK: Favorite Button
    
    private func initializeFavoriteButton() {
        favoriteButton.setImage(UIImage(named: "favorite")?.withRenderingMode(.alwaysTemplate), for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        favoriteButton.tintColor = UIColor.appTintColor
    }
    
    private func constrainFavoriteButton() {
        if let image = favoriteButton.image(for: .normal) {
            favoriteButton.layout(size: image.size)
            favoriteButton.alignLeft(toRightOfView: shareButton)
            favoriteButton.alignBottom()
        }
    }
    
    // MARK: Maps Button
    
    private func initializeMapsButton() {
        mapsButton.setImage(UIImage(named: "map")?.withRenderingMode(.alwaysTemplate), for: .normal)
        mapsButton.addTarget(self, action: #selector(mapsTapped), for: .touchUpInside)
        mapsButton.tintColor = UIColor.appTintColor
    }
    
    private func constrainMapsButton() {
        if let image = mapsButton.image(for: .normal) {
            mapsButton.layout(size: image.size)
            mapsButton.alignLeft(toRightOfView: favoriteButton)
            mapsButton.alignBottom()
        }
    }
    
    // MARK: Address Label
    
    private func initializeAddressLabel() {
        addressLabel.numberOfLines = 0
    }
    
    private func constrainAddressLabel() {
        let topSpace: CGFloat = 20.0
        addressLabel.alignLeading(offset: addressSideMargins)
        addressLabel.alignTrailing(offset: -addressSideMargins)
        addressLabel.alignTop(offset: topSpace)
    }
    
    // MARK: Map View
    
    private func initializeMapView() {
    }
    
    private func constrainMapView() {
        let topSpace: CGFloat = 20.0
        mapView.expandWidth()
        mapView.alignBottom()
        mapView.alignTop(toBottomOfView: addressLabel, offset: topSpace)
    }
    
    // MARK: Actions
    
    internal func closeTapped() {
        interactionHandler?.locationViewDidTapCloseButton(self)
    }
    
    internal func handleCloseTap(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            interactionHandler?.locationViewDidTapCloseButton(self)
        }
    }
    
    internal func shareTapped() {
    }
    
    internal func favoriteTapped() {
    }
    
    internal func mapsTapped() {
        interactionHandler?.locationViewDidTapMapsButton(self)
    }
    
    // MARK: Helpers
    
    private func updateAddressLabel() {
        guard let address = address else {
            addressLabel.attributedText = nil
            return
        }
        let nameDescriptor = TextDescriptor(text: address.name,
                                            color: UIColor.locationNameColor,
                                            font: UIFont.systemFont(ofSize: 22.0))
        let attributedText = nameDescriptor.attributedText.mutableCopy() as! NSMutableAttributedString

        if address.street.length > 0 {
            let streetDescriptor = TextDescriptor(text: "\n" + address.street,
                                                  color: UIColor.locationNameColor,
                                                  font: UIFont.systemFont(ofSize: 17.0))
            attributedText.append(streetDescriptor.attributedText)
        }
        
        if address.cityStateZipCode.length > 0 {
            let cityStateZipCodeDescriptor = TextDescriptor(text: "\n" + address.cityStateZipCode,
                                                            color: UIColor.locationNameColor,
                                                            font: UIFont.systemFont(ofSize: 17.0))
            attributedText.append(cityStateZipCodeDescriptor.attributedText)
        }
        
        addressLabel.attributedText = attributedText
        addressLabel.sizeToFit()
    }
}
