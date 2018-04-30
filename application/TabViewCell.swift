//
//  TabViewCell.swift
//  reddift
//
//  Created by sonson on 2015/10/28.
//  Copyright © 2015年 sonson. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    func setMultiplier(multiplier: CGFloat) {
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        newConstraint.isActive = self.isActive
        
        NSLayoutConstraint.deactivate([self])
        NSLayoutConstraint.activate([newConstraint])
    }
}

class TabViewCell: UICollectionViewCell {
    @IBOutlet var screenImageView: UIImageView?
    @IBOutlet var numberLabel: UILabel?
    @IBOutlet var widthRatio: NSLayoutConstraint?
    @IBOutlet var aspectRatio: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let size = UIApplication.shared.keyWindow?.rootViewController?.view.frame.size {
            let ratio = size.width / (size.height)
            widthRatio?.setMultiplier(multiplier: 0.95)
            aspectRatio?.setMultiplier(multiplier: ratio)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
