//
//  CloseCommentCell.swift
//  reddift
//
//  Created by sonson on 2016/08/28.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

class CloseCommentCell: BaseCommentCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        prepareSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareSubviews()
    }
    
    func prepareSubviews() {
        preservesSuperviewLayoutMargins = false
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets.zero
        
        topInformationView.translatesAutoresizingMaskIntoConstraints = false
        verticalBar.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(topInformationView)
        self.contentView.addSubview(verticalBar)
        
        verticalBar.backgroundColor = UIColor.lightGray
        
        let views = [
            "topInformationView": topInformationView,
            "verticalBar": verticalBar
        ]
        
        let metric = [
            "toolbarTopSpace": CommentCell.toolbarTopSpace
        ]
        
        self.contentView.addConstraints (
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[topInformationView]-0-|", options: NSLayoutFormatOptions(), metrics: metric, views: views)
        )
        
        let topInformationViewHeight = NSLayoutConstraint(item: topInformationView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CommentCell.informationViewHeight)
        topInformationView.addConstraint(topInformationViewHeight)
        self.topInformationViewHeight = topInformationViewHeight
        
        self.addConstraints (
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[verticalBar]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
        )
        
        let varticalBarWidth = NSLayoutConstraint(item: verticalBar, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CommentCell.verticalBarWidth)
        verticalBar.addConstraint(varticalBarWidth)
        self.varticalBarWidth = varticalBarWidth
        
        let varticalBarLeftMargin = NSLayoutConstraint(item: verticalBar, attribute: .left, relatedBy: .equal, toItem: self.contentView, attribute: .left, multiplier: 1, constant: -CommentCell.verticalBarWidth)
        self.contentView.addConstraint(varticalBarLeftMargin)
        self.varticalBarLeftMargin = varticalBarLeftMargin
        
        do {
            let con3 = NSLayoutConstraint(item: topInformationView, attribute: .left, relatedBy: .equal, toItem: verticalBar, attribute: .right, multiplier: 1, constant: CommentCell.leftMargin)
            self.contentView.addConstraint(con3)
            let con4 = NSLayoutConstraint(item: topInformationView, attribute: .right, relatedBy: .equal, toItem: self.contentView, attribute: .right, multiplier: 1, constant: 0)
            self.contentView.addConstraint(con4)
        }
        prepareInformationView()
        
        toggleButton.setImage(UIImage.init(named: "expand"), for: .normal)
        
        selectionStyle = .none
    }
    
    var commentContainer: CommentContainer? = nil {
        didSet {
            if let commentContainer = self.commentContainer {
                varticalBarLeftMargin?.constant = CommentCell.estimateBarLeftMargin(depth: commentContainer.depth)
                authorButton.setTitle(commentContainer.comment.author, for: [])
                dateLabel.text = NSDate.createdDateDescription(createdUtc: commentContainer.comment.createdUtc)
                voteLabel.text = commentContainer.comment.score > 0 ? "+\(commentContainer.comment.score)" : "\(commentContainer.comment.score)"
                
                updateSizeOfLabel(label: voteLabel, widthConstraint: voteLabellWidth, heightConstraint: voteLabelHeight)
                updateSizeOfLabel(label: dateLabel, widthConstraint: dateLabelWidth, heightConstraint: dateLabelHeight)
                updateSizeOfButton(button: authorButton, widthConstraint: authorButtonWidth, heightConstraint: authorButtonHeight)
                
                childlenLabel.text = "\(commentContainer.numberOfChildren) children"
                updateSizeOfLabel(label: childlenLabel, widthConstraint: childlenLabelWidth, heightConstraint: childlenLabelHeight)
            }
        }
    }
}
