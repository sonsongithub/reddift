//
//  TVUZTextVIewCell.swift
//  reddift
//
//  Created by sonson on 2015/11/18.
//  Copyright © 2015年 sonson. All rights reserved.
//

import UIKit

class TVUZTextVIewCell: UICollectionViewCell {
    @IBOutlet var textView:UZTextView? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.clearColor()
    
        let layer = self.layer
        layer.rasterizationScale = UIScreen.mainScreen().scale
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSizeMake(0, 1)
        layer.shouldRasterize = true
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        /*
        Update the label's alpha value using the `UIFocusAnimationCoordinator`.
        This will ensure all animations run alongside each other when the focus
        changes.
        */
        coordinator.addCoordinatedAnimations({ [unowned self] in
            if self.focused {
                self.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }
            else {
                self.transform = CGAffineTransformIdentity
            }
            }, completion: nil)
    }
}
