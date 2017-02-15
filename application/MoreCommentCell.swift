//
//  MoreCommentCell.swift
//  reddift
//
//  Created by sonson on 2016/03/08.
//  Copyright © 2016年 sonson. All rights reserved.
//

import UIKit

class MoreCommentCell: UITableViewCell {
    var moreContainer: MoreContainer? = nil {
        didSet {
            if let moreContainer = self.moreContainer {
                leftMarginVarticalBar?.constant = moreContainer.depth == 1 ? -CommentCell.verticalBarWidth : (CGFloat(moreContainer.depth) - 1) * CommentCell.verticalBarWidth
            }
        }
    }
    
    @IBOutlet var leftMarginVarticalBar: NSLayoutConstraint?
    @IBOutlet var widthOfVerticalBar: NSLayoutConstraint?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets.zero
        widthOfVerticalBar?.constant = CommentCell.verticalBarWidth
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
