//
//  LocationTransitionManager.swift
//  Places
//
//  Created by Nick Bolton on 5/20/17.
//  Copyright © 2017 Pixelbleed LLC. All rights reserved.
//

import UIKit

class LocationTransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {

    private var presenting = true
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        if presenting {
            animatePresentingTransition(using: transitionContext)
        } else {
            animateDismissingTransition(using: transitionContext)
        }
    }
    
    private func animatePresentingTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        container.addSubview(fromView)
        container.addSubview(toView)
        
        toView.alpha = 0.0
    
        // get the duration of the animation
        // DON'T just type '0.5s' -- the reason why won't make sense until the next post
        // but for now it's important to just follow this approach
        let duration = self.transitionDuration(using: transitionContext)
        
        // perform the animation!
        // for this example, just slid both fromView and toView to the left at the same time
        // meaning fromView is pushed off the screen and toView slides into view
        // we also use the block animation usingSpringWithDamping for a little bounce
        let options = UIViewAnimationOptions.beginFromCurrentState.union(.allowAnimatedContent)
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: options, animations: {
            
            toView.alpha = 1.0
            fromView.alpha = 0.0
            
        }, completion: { finished in
            
            // tell our transitionContext object that we've finished animating
            transitionContext.completeTransition(true)
            
        })
    }
    
    private func animateDismissingTransition(using transitionContext: UIViewControllerContextTransitioning) {
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.75
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
}
