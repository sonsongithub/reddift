//
//  UZTextViewCell.swift
//  reddift
//
//  Created by sonson on 2015/04/23.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

protocol UZTextViewCellDelegate: class {
    func pushedMoreButton(cell:UZTextViewCell)
}

class UZTextViewCell: UITableViewCell {
    @IBOutlet var textView:UZTextView? = nil
    @IBOutlet var moreButton:UIButton? = nil
    var delegate:UZTextViewCellDelegate? = nil
    var content:Comment? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView?.userInteractionEnabled = false
        
        if let button = moreButton {
            button.addTarget(self, action: "pushedMoreButton:", forControlEvents: UIControlEvents.ValueChanged)
        }
    }
    
    func pushedMoreButton(sender:AnyObject?) {
        if let delegate = self.delegate {
            delegate.pushedMoreButton(self)
        }
    }
    
    class func margin() -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
}
