//
//  AppDelegate.swift
//  CrummyApp
//
//  Created by Nick Bolton on 5/17/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        LocationHelper.shared.initialize()
        NetworkActivityIndicatorManager.shared.isEnabled = true
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()
        return true
    }
}

