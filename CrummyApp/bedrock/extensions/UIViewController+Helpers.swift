//
//  UIViewController+Helpers.swift
//  Bedrock
//
//  Created by Nick Bolton on 7/14/16.
//  Copyright © 2016 Pixelbleed LLC. All rights reserved.
//

import UIKit

extension UIViewController {
        
    func wrapInNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
    @discardableResult
    func presentViewControllerInNavigation(vc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) -> UINavigationController {
        let nav = vc.wrapInNavigationController()
        present(nav, animated: animated, completion: completion)
        return nav
    }
    
    // MARK: Navigation
    
    func navigateTo(vc: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(vc, animated: animated)
    }
}
