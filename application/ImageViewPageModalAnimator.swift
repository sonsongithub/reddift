//
//  ImageViewPageModalAnimator.swift
//  reddift
//
//  Created by sonson on 2016/10/13.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

private let duration = Double(0.4)

protocol ImageViewAnimator {
    func targetImageView(thumbnail: Thumbnail) -> UIImageView?
    func imageViews() -> [UIImageView]
}

protocol ImageViewDestination {
    func thumbnailImageView() -> UIImageView
}

/**
 Animator, when user moves to ImageViewController from FrontViewController/CommentViewController.
 */
class ImageViewPageModalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    /**
     Animate view controllers when user moves to ImageViewController from FrontViewController/CommentViewController.
     
     - parameter transitionContext: The context object containing information about the transition.
     */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // This code is called when unexpected error is happened.
        func exitCode() {
            let containerView = transitionContext.containerView
            if let modalViewController = transitionContext.viewController(forKey: .to) {
                containerView.addSubview(modalViewController.view)
                transitionContext.completeTransition(true)
            }
        }
        
        // Get container view
        let containerView = transitionContext.containerView
        
        // Get destination view controller
        guard let pageViewController = transitionContext.viewController(forKey: .to) as? ImageViewPageController else { return exitCode() }
        guard let toViewController = pageViewController.imageViewController else { return exitCode() }
        
        // Get starting view controller
        guard let toNavigationController = transitionContext.viewController(forKey: .from) as? UINavigationController else { return exitCode() }
        guard let fromViewController = toNavigationController.topViewController as? ImageViewAnimator else { return exitCode() }
        
        let destinationView = toViewController.thumbnailImageView()
        destinationView.isHidden = true
        
        // Get starting view
        let thumbnail = pageViewController.thumbnails[pageViewController.currentIndex]
        guard let thumbnailView = fromViewController.targetImageView(thumbnail: thumbnail) else { return exitCode() }
        guard let thumbnailView_superview = thumbnailView.superview else { return exitCode() }
        let startImageViewFrame = containerView.convert(thumbnailView.frame, from: thumbnailView_superview)
        thumbnailView.isHidden = true
        
        // Get image from image view controller
        guard let newImage = thumbnailView.image else { return exitCode() }
        var newImageSize = newImage.size
        if newImageSize.width == 0 { newImageSize.width = 1 }
        if newImageSize.height == 0 { newImageSize.height = 1 }
        
        /**< Ratio of start size to full screen. This ratio is used to descide the fainal size of animatingImageView. */
        var ratioOfImageToFullScreen = CGFloat(1)
        if destinationView.frame.size.width / destinationView.frame.size.height < newImageSize.width / newImageSize.height {
            ratioOfImageToFullScreen = destinationView.frame.size.width / newImageSize.width
        } else {
            ratioOfImageToFullScreen = destinationView.frame.size.height / newImageSize.height
        }
        
        /**< Final frame of animating image view */
        let endFrame = CGRect(
            x: (containerView.frame.size.width - newImageSize.width * ratioOfImageToFullScreen)/2,
            y: (containerView.frame.size.height - newImageSize.height * ratioOfImageToFullScreen)/2,
            width: newImageSize.width * ratioOfImageToFullScreen,
            height: newImageSize.height * ratioOfImageToFullScreen
        )
        
        let animatingView = UIImageView(image: newImage)
        animatingView.contentMode = thumbnailView.contentMode
        animatingView.clipsToBounds = true
        
        var ratioToImageOfStartImageViewFrame = CGFloat(1)

        /**< Initial frame of animating image view */
        var startFrame = CGRect.zero
        if animatingView.contentMode == .scaleAspectFill {
            // Fit the size of animating image view to a smaller one of width or height.
            if endFrame.size.width < endFrame.size.height {
                startFrame.size = startImageViewFrame.size
                ratioToImageOfStartImageViewFrame = startImageViewFrame.size.width / startFrame.size.width
            } else {
                startFrame.size = startImageViewFrame.size
                ratioToImageOfStartImageViewFrame = startImageViewFrame.size.height / startFrame.size.height
            }
        } else {
            // Fit the size of animating image view to a larger one of width or height.
            if newImageSize.height / newImageSize.width > startImageViewFrame.size.height / startImageViewFrame.size.width {
                let ratio = startImageViewFrame.size.height / newImageSize.height
                startFrame.size = CGSize(width: newImageSize.width * ratio, height: newImageSize.height * ratio)
                ratioToImageOfStartImageViewFrame = startImageViewFrame.size.height / startFrame.size.height
            } else {
                let ratio = startImageViewFrame.size.width / newImageSize.width
                startFrame.size = CGSize(width: newImageSize.width * ratio, height: newImageSize.height * ratio)
                ratioToImageOfStartImageViewFrame = startImageViewFrame.size.width / startFrame.size.width
            }
        }
        containerView.addSubview(pageViewController.view)
        
        // Set parameters to animating image view
        animatingView.frame = startFrame
        animatingView.transform = CGAffineTransform(scaleX: ratioToImageOfStartImageViewFrame, y: ratioToImageOfStartImageViewFrame)
        animatingView.center = CGPoint(x: startImageViewFrame.midX, y: startImageViewFrame.midY)
        containerView.addSubview(animatingView)
        
        pageViewController.alphaWithoutMainContent = 0
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: {
                        animatingView.transform = CGAffineTransform.identity
                        animatingView.frame = endFrame
                        pageViewController.alphaWithoutMainContent = 1
            }) { (_) in
                animatingView.removeFromSuperview()
                destinationView.isHidden = false
                thumbnailView.isHidden = false
                transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
}
