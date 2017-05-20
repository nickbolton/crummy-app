//
//  LocationViewController.swift
//  Places
//
//  Created by Nick Bolton on 5/19/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: BaseViewController<LocationRootView>, LocationInteractionHandler, MKMapViewDelegate {

    private let result: ForwardGeocodingResult

    required init(result: ForwardGeocodingResult) {
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    
    private func setupRootView() {
        rootView?.interactionHandler = self
        rootView?.address = result.address
    }
    
    private func setupMapView() {
        rootView?.mapView.delegate = self
        rootView?.mapView.addAnnotation(LocationAnnotation(title: result.address.name, coordinate: result.coordinate))
        centerMapOnCurrentLocation(result.coordinate)
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRootView()
        setupMapView()
    }
    
    // MARK: Helpers
    
    private func centerMapOnCurrentLocation(_ coordinate: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        rootView?.mapView.setRegion(coordinateRegion, animated: false)
    }
    
    // MARK: LocationInteractionHandler Conformance
    
    internal func locationViewDidTapCloseButton(_: LocationRootView) {
        dismiss(animated: true)
    }
    
    internal func locationViewDidTapMapsButton(_: LocationRootView) {
        let placemark = MKPlacemark(coordinate: result.coordinate)
        let item = MKMapItem(placemark: placemark)
        item.name = result.address.name
        let options = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        item.openInMaps(launchOptions: options)
    }
    
    // MARK: MKMapViewDelegate Conformance
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        return view
    }
    
//    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//        if let annotation = annotation as? Artwork {
//            let identifier = "pin"
//            var view: MKPinAnnotationView
//            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
//                as? MKPinAnnotationView { // 2
//                dequeuedView.annotation = annotation
//                view = dequeuedView
//            } else {
//                // 3
//                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                view.canShowCallout = true
//                view.calloutOffset = CGPoint(x: -5, y: 5)
//                view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
//            }
//            return view
//        }
//        return nil
//    }
    
    // MARK: Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    override var prefersStatusBarHidden: Bool { return false }
}
