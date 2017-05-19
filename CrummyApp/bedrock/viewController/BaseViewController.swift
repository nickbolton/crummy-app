//
//  BaseViewController.swift
//  Bedrock
//
//  Created by Nick Bolton on 7/13/16.
//  Copyright © 2016 Pixelbleed LLC. All rights reserved.
//

import UIKit

class BaseViewController<T:UIView>: UIViewController {

    private(set) var firstAppearance = true
    private(set) var appearanceCount = 0
    private(set) var hasAppeared = false
    private(set) var isAppeared = false
    
    var rootView: T? {
        get {
            return view as? T
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: View Lifecycle
    
    override func loadView() {
        view = T()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        appearanceCount += 1
        isAppeared = true
        firstAppearance = (appearanceCount == 1);
        super.viewDidAppear(animated)
        hasAppeared = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isAppeared = false
    }
    
    // MARK: Notifications
    
    func observeApplicationWillEnterForeground() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground(noti:)),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
    }
    
    func unobserveApplicationWillEnterForeground() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIApplicationWillEnterForeground,
                                                  object: nil)
    }
    
    func observeApplicationDidEnterBackground() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground(noti:)),
                                               name: NSNotification.Name.UIApplicationDidEnterBackground,
                                               object: nil)
    }
    
    func unobserveApplicationDidEnterBackground() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIApplicationDidEnterBackground,
                                                  object: nil)
    }
    
    func observeApplicationWillResignActive() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillResignActive(noti:)),
                                               name: NSNotification.Name.UIApplicationWillResignActive,
                                               object: nil)
    }
    
    func unobserveApplicationWillResignActive() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIApplicationWillResignActive,
                                                  object: nil)
    }
    
    func observeApplicationDidBecomeActive() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive(noti:)),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
    }
    
    func unobserveApplicationDidBecomeActive() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIApplicationDidBecomeActive,
                                                  object: nil)
    }
    
    func observeKeyboardWillHide() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(noti:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func unobserveKeyboardWillHide() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillHide,
                                                  object: nil)
    }
    
    func observeKeyboardWillShow() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(noti:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
    }
    
    func unobserveKeyboardWillShow() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillShow,
                                                  object: nil)
    }
    
    func applicationWillEnterForeground(noti: NSNotification) {
        
    }
    
    func applicationDidEnterBackground(noti: NSNotification) {
        
    }
    
    func applicationWillResignActive(noti: NSNotification) {
        
    }
    
    func applicationDidBecomeActive(noti: NSNotification) {
        
    }
    
    func keyboardWillShow(noti: NSNotification) {
        
        guard let userInfo = noti.userInfo else {
            return
        }
        
        guard let curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }
        
        guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        guard let frameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let translation = -frameValue.cgRectValue.height
        let curve = UIViewAnimationOptions(rawValue: curveValue)
        
        keyboardWillShow(userInfo: userInfo, curve: curve, duration: duration, translation: translation)
    }
    
    func keyboardWillHide(noti: NSNotification) {
        
        if isAppeared {
            
            guard let userInfo = noti.userInfo else {
                return
            }
            
            guard let curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt else {
                return
            }
            
            guard let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                return
            }
            
            guard let frameValue = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            
            let curve = UIViewAnimationOptions(rawValue: curveValue)
            let translation = frameValue.cgRectValue.height

            keyboardWillHide(userInfo: userInfo, curve: curve, duration: duration, translation: translation)
        }
    }
    
    internal func keyboardWillShow(userInfo: [AnyHashable : Any]?, curve: UIViewAnimationOptions, duration: TimeInterval, translation: CGFloat) {
        // abstract
    }
    
    internal func keyboardWillHide(userInfo: [AnyHashable : Any]?, curve: UIViewAnimationOptions, duration: TimeInterval, translation: CGFloat) {
        // abstract
    }
}
