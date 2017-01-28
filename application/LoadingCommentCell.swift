//
//  LoadingCommentCell.swift
//  reddift
//
//  Created by sonson on 2016/03/14.
//  Copyright © 2016年 sonson. All rights reserved.
//

import UIKit

class LoadingCommentCell: UITableViewCell {
    @IBOutlet var activityIndicator: UIActivityIndicatorView? = nil
    
    override func awakeFromNib() {
        activityIndicator?.startAnimating()
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets.zero
        selectionStyle = .none
    }
}
