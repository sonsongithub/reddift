//
//  UZTextViewCell.swift
//  reddift
//
//  Created by sonson on 2015/04/23.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import reddift

protocol UZTextViewCellDelegate: class {
    func pushedMoreButton(_ cell: UZTextViewCell)
}

class UZTextViewCell: UITableViewCell {
    @IBOutlet var textView: UZTextView? = nil
    @IBOutlet var moreButton: UIButton? = nil
    var delegate: UZTextViewCellDelegate? = nil
    var content: Thing? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView?.isUserInteractionEnabled = false
        
        if let button = moreButton {
            button.addTarget(self, action: #selector(UZTextViewCell.pushedMoreButton(_:)), for: UIControlEvents.touchUpInside)
        }
    }
    
    func pushedMoreButton(_ sender: AnyObject?) {
        if let delegate = self.delegate {
            delegate.pushedMoreButton(self)
        }
    }
    
    class func margin() -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 0, 5, 0)
    }
    
}
