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
}
