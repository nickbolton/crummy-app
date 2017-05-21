//
//  SearchViewController.swift
//  Places
//
//  Created by Nick Bolton on 5/17/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import UIKit
import ReachabilitySwift

class SearchViewController: BaseViewController<SearchRootView>, SearchInteractionHandler, UITableViewDataSource, UITableViewDelegate {
    
    private var dataSource = [ForwardGeocodingResult]()
    private var searchOperation: OpenCageForwardGeocodingOperation?
    private let transitionManager = LocationTransitionManager()
    
    // request throttling
    private let throttle = Throttle()
    private var lastSearchTerm: String? // used to perform a final search if requests came in while throttling

    // reachability
    private let reachability = Reachability()!
    
    deinit {
        reachability.stopNotifier()
    }

    // MARK: Setup
    
    private func setupNavigationBar() {
        navigationController?.makeNavBarTransparent()
    }
    
    private func setupRootView() {
        rootView?.tableView.dataSource = self
        rootView?.tableView.delegate = self
        rootView?.interactionHandler = self
    }
    
    private func setupReachability() {
        reachability.whenReachable = { reachability in
            DispatchQueue.main.async { [weak self] in
                self?.rootView?.isConnectedToInternet = true
            }
        }
        reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async { [weak self] in
                self?.rootView?.isConnectedToInternet = false
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            Logger.shared.error("Unable to reability start notifier")
        }
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRootView()
        setupReachability()
        setupNavigationBar()
        observeKeyboardWillHide()
        observeKeyboardWillShow()
        doSearchPlaces("Drafthouse", onlyCinemas: true)
    }
    
    // MARK: Keyboard Handlers
    
    override internal func keyboardWillShow(userInfo: [AnyHashable : Any]?, curve: UIViewAnimationOptions, duration: TimeInterval, translation: CGFloat) {
        guard let _ = view.window else { return }
        rootView?.setNeedsLayout()
        UIView.animate(withDuration: duration, delay: 0.0, options: curve, animations: { [weak self] in
            self?.rootView?.moveSearchContainer(by: translation)
        }, completion: nil)
    }
    
    override internal func keyboardWillHide(userInfo: [AnyHashable : Any]?, curve: UIViewAnimationOptions, duration: TimeInterval, translation: CGFloat) {
        rootView?.setNeedsLayout()
        UIView.animate(withDuration: duration, delay: 0.0, options: curve, animations: { [weak self] in
            self?.rootView?.moveSearchContainer(by: 0.0)
        }, completion: nil)
    }
    
    // MARK: Helpers
    
    private func reloadData() {
        self.rootView?.tableView.reloadData()
        self.rootView?.emptyState = (dataSource.count == 0)
    }
    
    private func searchPlaces(_ term: String, onlyCinemas: Bool) {
        lastSearchTerm = term
        throttle.throttle { [weak self] in
            self?.doSearchPlaces(term, onlyCinemas: onlyCinemas)
        }
    }
    
    private func doSearchPlaces(_ term: String, onlyCinemas: Bool) {
    
        guard let rootView = rootView else { return }
        guard reachability.isReachable else { return }
        guard term.length > 0 else { return }
        guard !rootView.isSearching else { return }

        lastSearchTerm = nil
        rootView.isSearching = true

        LocationHelper.shared.currentLocation { [weak self] location in
            guard let `self` = self else { return }
            Rest.shared.findPlaces(named: term,
                                   near: location,
                                   onSuccess: { result in
                if onlyCinemas {
                    self.dataSource = result.filter { $0.type == .cinema }
                } else {
                    self.dataSource = result.sorted { ($0.type.rawValue, $0.address.name) < ($1.type.rawValue, $1.address.name) }
                }
                self.reloadData()
                rootView.isSearching = false
                if let term = self.lastSearchTerm {
                    self.doSearchPlaces(term, onlyCinemas: false)
                }
            }, onFailure: { error in
                rootView.isSearching = false
            })
        }
    }
    
    private func presentLocationViewController(with result: ForwardGeocodingResult) {
        let vc = LocationViewController(result: result)
        vc.transitioningDelegate = transitionManager
        present(vc, animated: true)
    }
    
    // MARK: SearchInteractionHandler Conformance
    
    func searchView(_: SearchRootView, didUpdateSearchTerm term: String) {
        searchPlaces(term, onlyCinemas: false)
        if let rootView = rootView {
            if rootView.isLookingForOtherPlaces && term.length > 0 {
                rootView.isLookingForOtherPlaces = false
            }
        }
    }

    func searchViewDidTapSearchButton(_: SearchRootView, searchTerm: String) {
        searchPlaces(searchTerm, onlyCinemas: false)
    }
    
    func searchViewDidTapClearTextButton(_: SearchRootView) {
        dataSource = []
        reloadData()
    }
    
    // MARK: UITableViewDataSource Conformance
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SearchResultCell.self)) as! SearchResultCell
        
        if indexPath.row < dataSource.count {
            let item = dataSource[indexPath.row]
            cell.title = item.address.name
            cell.address = item.address.formattedAddress
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count;
    }
    
    // MARK: UITableViewDelegate Conformance
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item < dataSource.count {
            let result = dataSource[indexPath.item]
            presentLocationViewController(with: result)
        }
    }
    
    // MARK: Status Bar
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    override var prefersStatusBarHidden: Bool { return false }
}
