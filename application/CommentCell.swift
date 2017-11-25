//
//  CommentCell.swift
//  reddift
//
//  Created by sonson on 2016/03/16.
//  Copyright © 2016年 sonson. All rights reserved.
//

import reddift
import UIKit

let CommentCellReplyNotificationName = Notification.Name(rawValue: "CommentCellReplyNotificationName")
let CommentCellActionNotificationName = Notification.Name(rawValue: "CommentCellActionNotificationName")

class CommentCell: BaseCommentCell, ImageViewAnimator {
    let numberOfThumbnails: Int
    
    var thumbnailView = CommentThumbnailView(numberOfThumbnails: 0)
    
    let textView = ReddiftTextView(frame: CGRect.zero)
    let toolbar = UIView(frame: CGRect.zero)
    let upVoteButton = UIButton(type: .custom)
    let downVoteButton = UIButton(type: .custom)
    let saveButton = UIButton(type: .custom)
    let replyButton = UIButton(type: .custom)
    let actionButton = UIButton(type: .custom)
    
    var textViewHeight: NSLayoutConstraint?
    var thumbnailViewHeight: NSLayoutConstraint?
    var toolbarHeight: NSLayoutConstraint?
    
    static let iconWidth                = CGFloat(20)
    static let iconHeight               = CGFloat(20)
    static let toolbarHeight            = CGFloat(30)
    static let iconHorizontalSpace      = CGFloat(15)
    static let toolbarTopSpace          = CGFloat(5)
    
    func imageViews() -> [UIImageView] {
        return thumbnailView.imageViews
    }
    
    func targetImageView(thumbnail: Thumbnail) -> UIImageView? {
        if let commentContainer = commentContainer {
            if let index = commentContainer.thumbnails.index(where: {$0.url == thumbnail.url}) {
                if 0..<thumbnailView.imageViews.count ~= index {
                    return thumbnailView.imageViews[index]
                }
            }
        }
        return nil
    }
    
    func prepareToolbar() {
        [upVoteButton, downVoteButton, saveButton, replyButton, actionButton].forEach({
            toolbar.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            let widthConstraint = NSLayoutConstraint(item: $0, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CommentCell.iconWidth)
            $0.addConstraint(widthConstraint)
            let heightConstraint = NSLayoutConstraint(item: $0, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CommentCell.iconHeight)
            $0.addConstraint(heightConstraint)
            let verticalCentering = NSLayoutConstraint(item: toolbar, attribute: .centerY, relatedBy: .equal, toItem: $0, attribute: .centerY, multiplier: 1, constant: 0)
            toolbar.addConstraint(verticalCentering)
        })
        
        let views = [
            "upVote": upVoteButton,
            "downVote": downVoteButton,
            "save": saveButton,
            "reply": replyButton,
            "action": actionButton
        ]
        
        views.forEach({$1.setImage(UIImage(named: $0), for: [])})
        
        let metric = [
            "space": CommentCell.iconHorizontalSpace
        ]
        
        toolbar.addConstraints (
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(>=0)-[upVote]-space-[downVote]-space-[save]-space-[reply]-space-[action]-space-|", options: NSLayoutFormatOptions(), metrics: metric, views: views)
        )
        
        upVoteButton.addTarget(self, action: #selector(tapUpVoteButton(sender:)), for: .touchUpInside)
        downVoteButton.addTarget(self, action: #selector(tapDownVoteButton(sender:)), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(tapSaveButton(sender:)), for: .touchUpInside)
        replyButton.addTarget(self, action: #selector(tapReplyButton(sender:)), for: .touchUpInside)
        actionButton.addTarget(self, action: #selector(tapActionButton(sender:)), for: .touchUpInside)
    }
    
    func prepareSubviews() {
        preservesSuperviewLayoutMargins = false
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets.zero
        
        thumbnailView = CommentThumbnailView(numberOfThumbnails: numberOfThumbnails)
        
        topInformationView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        verticalBar.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(topInformationView)
        self.contentView.addSubview(textView)
        self.contentView.addSubview(thumbnailView)
        self.contentView.addSubview(toolbar)
        self.contentView.addSubview(verticalBar)
    
        verticalBar.backgroundColor = UIColor.lightGray
        textView.backgroundColor = UIColor.white
        
        let views = [
            "topInformationView": topInformationView,
            "textView": textView,
            "thumbnailView": thumbnailView,
            "toolbar": toolbar,
            "verticalBar": verticalBar
        ]
        
        let metric = [
            "toolbarTopSpace": CommentCell.toolbarTopSpace
        ]
    
        self.contentView.addConstraints (
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[topInformationView]-0-[textView]-toolbarTopSpace-[thumbnailView]-0-[toolbar]-0-|", options: NSLayoutFormatOptions(), metrics: metric, views: views)
        )
        
        let topInformationViewHeight = NSLayoutConstraint(item: topInformationView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CommentCell.informationViewHeight)
        topInformationView.addConstraint(topInformationViewHeight)
        self.topInformationViewHeight = topInformationViewHeight
            
        let thumbnailViewHeight = NSLayoutConstraint(item: thumbnailView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: thumbnailView.height)
        thumbnailView.addConstraint(thumbnailViewHeight)
        self.thumbnailViewHeight = thumbnailViewHeight
        
        let toolbarHeight = NSLayoutConstraint(item: toolbar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CommentCell.toolbarHeight)
        toolbar.addConstraint(toolbarHeight)
        self.toolbarHeight = toolbarHeight
        
        self.addConstraints (
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[verticalBar]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
        )
        
        self.addConstraints (
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[thumbnailView]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
        )
        self.addConstraints (
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolbar]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
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
        do {
            let con3 = NSLayoutConstraint(item: textView, attribute: .left, relatedBy: .equal, toItem: verticalBar, attribute: .right, multiplier: 1, constant: CommentCell.leftMargin)
            self.contentView.addConstraint(con3)
            let con4 = NSLayoutConstraint(item: textView, attribute: .right, relatedBy: .equal, toItem: self.contentView, attribute: .right, multiplier: 1, constant: 0)
            self.contentView.addConstraint(con4)
        }
        prepareToolbar()
        prepareInformationView()
        self.contentView.bringSubview(toFront: thumbnailView)
        childlenLabel.isHidden = true
    }
    
    override func prepareForReuse() {
        print("prepareForReuse - \(String(describing: self.reuseIdentifier)) - \(numberOfThumbnails)")
        super.prepareForReuse()
    }
    
    init(numberOfThumbnails: Int) {
        self.numberOfThumbnails = numberOfThumbnails
        super.init(style: .default, reuseIdentifier: CommentThumbnailView.identifier(numberOfThumbnails: numberOfThumbnails))
        prepareSubviews()
        print("init - \(numberOfThumbnails) - \(self.reuseIdentifier!)")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.numberOfThumbnails = 0
        super.init(style: .default, reuseIdentifier: CommentThumbnailView.identifier(numberOfThumbnails: 0))
        prepareSubviews()
    }

    required init?(coder: NSCoder) {
        self.numberOfThumbnails = 0
        super.init(coder: coder)
        prepareSubviews()
    }
    
    var commentContainer: CommentContainer? = nil {
        didSet {
            if let commentContainer = self.commentContainer {
                varticalBarLeftMargin?.constant = CommentCell.estimateBarLeftMargin(depth: commentContainer.depth)
                
                updateTextViewWith(commentContainer)
                updateAuthorLabelWith(commentContainer.comment.author)
                updateDateLabelWith(commentContainer.comment.createdUtc)
                updateVoteCountLabelWith(commentContainer.comment.score)
                updateVotingButtonWith(commentContainer.comment.likes)
                updateSaveButtonWith(commentContainer.comment.saved)
                updateThumbnailViewWith(commentContainer)
                toolbar.isHidden = commentContainer.isTop
                
                selectionStyle = commentContainer.comment.isExpandable ? .default : .none
                setNeedsUpdateConstraints()
            }
        }
    }
    
    // MARK: - User action
    
    @objc func tapReplyButton(sender: Any) {
        if let container = self.commentContainer {
            NotificationCenter.default.post(name: CommentCellReplyNotificationName, object: nil, userInfo: ["comment": container.comment, "container": container])
        }
    }
    
    @objc func tapActionButton(sender: Any) {
        if let container = self.commentContainer {
            NotificationCenter.default.post(name: CommentCellActionNotificationName, object: nil, userInfo: ["comment": container.comment, "container": container])
        }
    }
    
    @objc func tapUpVoteButton(sender: Any) {
        if let commentContainer = self.commentContainer {
            switch commentContainer.comment.likes {
            case .up:
                self.updateVotingButtonWith(.up)
            case .down:
                commentContainer.vote(voteDirection: .none)
                self.updateVotingButtonWith(.none)
            case .none:
                commentContainer.vote(voteDirection: .up)
                self.updateVotingButtonWith(.up)
            }
        }
    }
    
    @objc func tapDownVoteButton(sender: Any) {
        if let commentContainer = self.commentContainer {
            switch commentContainer.comment.likes {
            case .up:
                commentContainer.vote(voteDirection: .none)
                self.updateVotingButtonWith(.none)
            case .down:
                do {}
                self.updateVotingButtonWith(.down)
            case .none:
                commentContainer.vote(voteDirection: .down)
                self.updateVotingButtonWith(.down)
            }
        }
    }
    
    @objc func tapSaveButton(sender: Any) {
        if let commentContainer = self.commentContainer {
            self.updateSaveButtonWith(!commentContainer.comment.saved)
            commentContainer.save(saved: !commentContainer.comment.saved)
        }
    }

    // MARK: - Support 3D touch

    func urlAt(_ location: CGPoint, peekView: UIView) -> (URL, CGRect)? {
        let tappedLocation = peekView.convert(location, to: textView)
        if let attr = textView.attributes(at: tappedLocation) {
            if let url = attr[NSAttributedStringKey.link] as? URL, let rect = attr[UZTextViewClickedRect] as? CGRect {
                let tappedLocation = textView.convert(rect, to: peekView)
                return (url, tappedLocation)
            }
        }
        return nil
    }
    
    func thumbnailAt(_ location: CGPoint, peekView: UIView) -> (Thumbnail, CGRect, CommentContainer, Int)? {
        let tappedLocation = peekView.convert(location, to: thumbnailView)
        for i in 0..<thumbnailView.imageViews.count {
            if thumbnailView.imageViews[i].frame.contains(tappedLocation) {
                let index = i
                let thumbnail = thumbnailView.thumbnails[index]
                let sourceRect = thumbnailView.convert(thumbnailView.imageViews[index].frame, to: peekView)
                if let commentContainer = commentContainer {
                    return (thumbnail, sourceRect, commentContainer, index)
                }
            }
        }
        return nil
    }

    // MARK: - Update user interface

    func updateVoteCountLabelWith(_ score: Int) {
        voteLabel.text = score > 0 ? "+\(score)" : "\(score)"
        updateSizeOfLabel(label: voteLabel, widthConstraint: voteLabellWidth, heightConstraint: voteLabelHeight)
    }
    
    func updateDateLabelWith(_ utc: Int) {
        dateLabel.text = NSDate.createdDateDescription(createdUtc: utc)
        updateSizeOfLabel(label: dateLabel, widthConstraint: dateLabelWidth, heightConstraint: dateLabelHeight)
    }
    
    func updateAuthorLabelWith(_ name: String) {
        authorButton.setTitle(name, for: [])
        updateSizeOfButton(button: authorButton, widthConstraint: authorButtonWidth, heightConstraint: authorButtonHeight)
    }
    
    func updateTextViewWith(_ commentContainer: CommentContainer) {
        textView.attributedString = commentContainer.body
        textView.scale = commentContainer.AAScale
    }
    
    func updateThumbnailViewWith(_ commentContainer: CommentContainer) {
        thumbnailView.updateThumbnailInfos(list: commentContainer.thumbnails)
        if let constraints = self.thumbnailViewHeight {
            constraints.constant = CommentThumbnailView.estimateHeight(numberOfThumbnails: commentContainer.numberOfThumbnails)
        }
    }
    
    func updateVotingButtonWith(_ direction: VoteDirection) {
        switch direction {
        case .up:
            upVoteButton.setImage(#imageLiteral(resourceName: "upVoteFill"), for: [])
            downVoteButton.setImage(#imageLiteral(resourceName: "downVote"), for: [])
        case .down:
            upVoteButton.setImage(#imageLiteral(resourceName: "upVote"), for: [])
            downVoteButton.setImage(#imageLiteral(resourceName: "downVoteFill"), for: [])
        case .none:
            upVoteButton.setImage(#imageLiteral(resourceName: "upVote"), for: [])
            downVoteButton.setImage(#imageLiteral(resourceName: "downVote"), for: [])
        }
    }
    
    func updateSaveButtonWith(_ saved: Bool) {
        if saved {
            saveButton.setImage(#imageLiteral(resourceName: "saveFill"), for: [])
        } else {
            saveButton.setImage(#imageLiteral(resourceName: "save"), for: [])
        }
    }
}
