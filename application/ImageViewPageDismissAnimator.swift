//
//  ImageViewPageDismissAnimator.swift
//  reddift
//
//  Created by sonson on 2016/10/13.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

private let duration = Double(0.4)

class ImageViewPageDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // This code is called when unexpected error is happened.
        func exitCode() {
            if let modalViewController = transitionContext.viewController(forKey: .from) {
                modalViewController.view.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
        
        // Get container view
        let containerView = transitionContext.containerView
        
        // Get destination view controller
        guard let toNavigationController = transitionContext.viewController(forKey: .to) as? UINavigationController else { return exitCode() }
        guard let toViewController = toNavigationController.topViewController as? ImageViewAnimator else { return exitCode() }
        
        // Get starting view controller
        guard let pageViewController = transitionContext.viewController(forKey: .from) as? ImageViewPageController else { return exitCode() }
        guard let fromViewController = pageViewController.imageViewController else { return exitCode() }

        // Get destination view
        let thumbnail = pageViewController.thumbnails[pageViewController.currentIndex]
        guard let destinationView = toViewController.targetImageView(thumbnail: thumbnail) else { return exitCode() }
        destinationView.isHidden = true
        
        guard let destinationView_superview = destinationView.superview else { return exitCode() }
        let destinationFrame = containerView.convert(destinationView.frame, from: destinationView_superview)

        // Get starting view
        let imageView = fromViewController.thumbnailImageView()
        guard let imageView_superview = imageView.superview else { return exitCode() }
        let startViewFrame = containerView.convert(imageView.frame, from: imageView_superview)
        
        // Get image from image view controller
        guard let newImage = imageView.image else { return exitCode() }
        var newImageSize = newImage.size
        if newImageSize.width == 0 { newImageSize.width = 1 }
        if newImageSize.height == 0 { newImageSize.height = 1 }
        
        // Create animating view
        let animatingView = UIImageView(image: newImage)
        animatingView.frame = startViewFrame
        animatingView.contentMode = destinationView.contentMode
        animatingView.clipsToBounds = true
        containerView.addSubview(animatingView)
        
        // Calculate the destination frame of the animatig view
        let targetCenter = CGPoint(x: destinationFrame.midX, y: destinationFrame.midY)
        var endFrame = startViewFrame
        endFrame.size = CGSize(width: animatingView.frame.size.height, height: animatingView.frame.size.height)
        endFrame.origin = CGPoint(x: targetCenter.x - endFrame.size.width/2, y: targetCenter.y - endFrame.size.height/2)
        
        var ratioOfDestinationFrameToStartFrame = CGFloat(1)
        
        let aspectRatioOfDestinationView = destinationFrame.size.width / destinationFrame.size.height
        
        if animatingView.contentMode == .scaleAspectFill {
            // Fit the size of animating image view to a smaller one of width or height.
            if startViewFrame.size.width < startViewFrame.size.height {
                endFrame.size = CGSize(width: startViewFrame.size.width, height: startViewFrame.size.width / aspectRatioOfDestinationView)
                endFrame.origin = CGPoint(x: targetCenter.x - endFrame.size.width/2, y: targetCenter.y - endFrame.size.height/2)
                ratioOfDestinationFrameToStartFrame = destinationFrame.size.width / startViewFrame.size.width
            } else {
                endFrame.size = CGSize(width: startViewFrame.size.height * aspectRatioOfDestinationView, height: startViewFrame.size.height)
                endFrame.origin = CGPoint(x: targetCenter.x - endFrame.size.width/2, y: targetCenter.y - endFrame.size.height/2)
                ratioOfDestinationFrameToStartFrame = destinationFrame.size.height / startViewFrame.size.height
            }
        } else if animatingView.contentMode == .scaleAspectFit {
            // Fit the size of animating image view to a larger one of width or height.
            if newImageSize.height / newImageSize.width > startViewFrame.size.height / startViewFrame.size.width {
                endFrame = startViewFrame
                endFrame.origin = CGPoint(x: targetCenter.x - endFrame.size.width/2, y: targetCenter.y - endFrame.size.height/2)
                ratioOfDestinationFrameToStartFrame = destinationFrame.size.height / startViewFrame.size.height
            } else {
                endFrame = startViewFrame
                endFrame.origin = CGPoint(x: targetCenter.x - endFrame.size.width/2, y: targetCenter.y - endFrame.size.height/2)
                ratioOfDestinationFrameToStartFrame = destinationFrame.size.width / startViewFrame.size.width
            }
        }
        
        pageViewController.view.removeFromSuperview()
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: [.curveEaseInOut],
            animations: {
                animatingView.frame = endFrame
                animatingView.center = CGPoint(x: destinationFrame.midX, y: destinationFrame.midY)
                animatingView.transform = CGAffineTransform(scaleX: ratioOfDestinationFrameToStartFrame, y: ratioOfDestinationFrameToStartFrame)
        }) { (_) in
            destinationView.isHidden = false
            animatingView.removeFromSuperview()
            transitionContext.completeTransition(true)
            UIView.animate(withDuration: 0.1,
                           animations: {
//                            toNavigationController.toolbar.alpha = 1
//                            toNavigationController.navigationBar.alpha = 1
            })
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}
