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
    private let scalingFactor: CGFloat = 0.1
    
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
        
        let toViewController = transitionContext.viewController(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!

        container.addSubview(toView)
        
        toView.frame = transitionContext.finalFrame(for: toViewController)
        toView.alpha = 0.0
        
        let scale = 1.0 + scalingFactor
        toView.transform = CGAffineTransform(scaleX: scale, y: scale)
    
        let duration = self.transitionDuration(using: transitionContext)
        let options = UIViewAnimationOptions.beginFromCurrentState.union(.allowAnimatedContent)

        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: options, animations: {
            let scale = 1.0 - self.scalingFactor
            toView.alpha = 1.0
            fromView.transform = CGAffineTransform(scaleX: scale, y: scale)
            toView.transform = .identity
        }, completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    private func animateDismissingTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let container = transitionContext.containerView
        
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        
        container.insertSubview(toView, at: 0)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        let options = UIViewAnimationOptions.beginFromCurrentState.union(.allowAnimatedContent)
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: options, animations: {
            fromView.alpha = 0.0
            toView.transform = .identity
            
            let scale = 1.0 + self.scalingFactor
            fromView.transform = CGAffineTransform(scaleX: scale, y: scale)

        }, completion: { finished in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
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
