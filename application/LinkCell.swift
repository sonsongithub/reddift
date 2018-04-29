//
//  LinkCell.swift
//  reddift
//
//  Created by sonson on 2016/02/15.
//  Copyright © 2016年 sonson. All rights reserved.
//

import UIKit

let LinkCellDidTapActionNotification = Notification.Name(rawValue: "LinkCellDidTapActionNotification")
let LinkCellDidTapCommentNotification = Notification.Name(rawValue: "LinkCellDidTapCommentNotification")
let LinkCellDidTapNameNotification = Notification.Name(rawValue: "LinkCellDidTapNameNotification")
let LinkCellDidTapTitleNotification = Notification.Name(rawValue: "LinkCellDidTapTitleNotification")
let LinkCellDidTapThumbnailNotification = Notification.Name(rawValue: "LinkCellDidTapThumbnailNotification")

class LinkCell: UITableViewCell {
    var titleTextView: UZTextView = UZTextView(frame: CGRect.zero)
    var contentInfoView: ContentInfoView = ContentInfoView(frame: CGRect.zero)
    var contentToolbar: ContentToolbar = ContentToolbar(frame: CGRect.zero)
    
    static let verticalTopMargin      = CGFloat(5)
    static let verticalBotttomMargin  = CGFloat(5)
    static let titleLeftMargin        = CGFloat(5)
    static let titleRightMargin       = CGFloat(5)
    
    // MARK: - Class method
    
    class func estimateTitleSize(attributedString: NSAttributedString, withBountWidth: CGFloat, margin: UIEdgeInsets) -> CGSize {
        let width = withBountWidth - titleLeftMargin - titleRightMargin
        return UZTextView.size(for: attributedString, withBoundWidth: width, margin: UIEdgeInsets.zero)
    }
    
    class func estimateHeight(titleHeight: CGFloat) -> CGFloat {
        return ThumbnailLinkCell.verticalTopMargin + titleHeight + ThumbnailLinkCell.verticalBotttomMargin + ContentInfoView.height + ContentToolbar.height
    }
    
    // MARK: - Support 3D touch
    
    func userAt(_ location: CGPoint, peekView: UIView) -> (String, CGRect)? {
        let p = peekView.convert(location, to: contentInfoView)
        if contentInfoView.nameButton.frame.contains(p) {
            let sourceRect = contentInfoView.convert(contentInfoView.nameButton.frame, to: peekView)
            if let name = contentInfoView.nameButton.titleLabel?.text {
                return (name, sourceRect)
            }
        }
        return nil
    }
    
    func commentAt(_ location: CGPoint, peekView: UIView) -> (CGRect, LinkContainable)? {
        guard let container = container else { return nil }
        
        if "self.\(container.link.subreddit)" == container.link.domain {
            let p = peekView.convert(location, to: contentView)
            if titleTextView.frame.contains(p) {
                let sourceRect = contentView.convert(titleTextView.frame, to: peekView)
                return (sourceRect, container)
            }
        }
        
        let p = peekView.convert(location, to: contentToolbar)
        if contentToolbar.commentBaseButton.frame.contains(p) {
            let sourceRect = contentToolbar.convert(contentToolbar.commentBaseButton.frame, to: peekView)
            return (sourceRect, container)
        }
        return  nil
    }
    
    func urlAt(_ location: CGPoint, peekView: UIView) -> (URL, CGRect)? {
        guard let container = container else { return nil }
        
        if "self.\(container.link.subreddit)" == container.link.domain {
            return nil
        }
        
        let p = peekView.convert(location, to: contentView)
        if titleTextView.frame.contains(p) {
            let sourceRect = contentView.convert(titleTextView.frame, to: peekView)
            if let url = URL(string: container.link.url) {
                return (url, sourceRect)
            }
        }
        
        return nil
    }
    
    func thumbnailAt(_ location: CGPoint, peekView: UIView) -> (Thumbnail, CGRect, LinkContainable, Int)? {
        if let mediaLinkCell = self as? MediaLinkCell {
            if let thumbnailView = mediaLinkCell.thumbnailView {
                let p = peekView.convert(location, to: thumbnailView)
                for i in 0 ..< thumbnailView.imageViews.count {
                    if thumbnailView.imageViews[i].frame.contains(p) {
                        let index = i
                        let thumbnail = thumbnailView.thumbnails[index]
                        let sourceRect = thumbnailView.convert(thumbnailView.imageViews[index].frame, to: peekView)
                        if let container = container {
                            return (thumbnail, sourceRect, container, index)
                        }
                    }
                }
            }
        }
        return nil
    }
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Instance method
    
    func coloringForDebug() {
        //        contentInfoView.backgroundColor = UIColor.lightGray
        //        contentToolbar.backgroundColor = UIColor.darkGray
    }
    
    // MARK: - getter/setter
    
    var container: LinkContainable? = nil {
        didSet {
            if let container = container as? LinkContainer {
                titleTextView.attributedString = container.attributedTitle
                contentInfoView.setNameText(name: container.link.author)
                contentInfoView.setDateText(created: container.link.createdUtc)
                contentInfoView.setDomainText(domain: container.link.domain)
                contentToolbar.setCommentCount(count: container.link.numComments)
                contentToolbar.setVotingCount(count: container.link.score)
                contentToolbar.setVotingDirection(direction: container.link.likes)
                contentToolbar.setSaved(saved: container.link.saved)
            }
        }
    }
    
    // MARK: - Setup
    
    func setupDispatching() {
        self.contentToolbar.upVoteButton.addTarget(self, action: #selector(LinkCell.tapUpVoteButton(sender:)), for: .touchUpInside)
        self.contentToolbar.downVoteButton.addTarget(self, action: #selector(LinkCell.tapDownVoteButton(sender:)), for: .touchUpInside)
        self.contentInfoView.nameButton.addTarget(self, action: #selector(LinkCell.didTapNameButton(sender:)), for: .touchUpInside)
        self.contentToolbar.actionButton.addTarget(self, action: #selector(LinkCell.didTapActionButton(sender:)), for: .touchUpInside)
        self.contentToolbar.saveButton.addTarget(self, action: #selector(LinkCell.didTapSaveButton(sender:)), for: .touchUpInside)
        self.contentToolbar.commentBaseButton.addTarget(self, action: #selector(LinkCell.didTapCommentButton(sender:)), for: .touchUpInside)
    }
    
    func setupViews() {
        
        selectionStyle = .none
        layoutMargins = UIEdgeInsets.zero
        separatorInset = UIEdgeInsets.zero
        titleTextView.isUserInteractionEnabled = false
        titleTextView.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(titleTextView)
        self.contentView.addSubview(contentInfoView)
        self.contentView.addSubview(contentToolbar)
        self.contentView.addSubview(titleTextView)
    }
    
    func setupConstraints() {
        contentInfoView.translatesAutoresizingMaskIntoConstraints = false
        contentToolbar.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let views: [String: Any] = [
            "titleTextView": titleTextView,
            "contentInfoView": contentInfoView,
            "contentToolbar": contentToolbar
            ]
        
        let metric = [
            "left": LinkCell.titleLeftMargin,
            "right": LinkCell.titleRightMargin,
            "contentInfoViewHeight": ContentInfoView.height,
            "contentToolbarHeight": ContentToolbar.height,
            "verticalTopMargin": LinkCell.verticalTopMargin,
            "verticalBottomMargin": LinkCell.verticalBotttomMargin
        ]
        
        ["contentInfoView", "contentToolbar"].forEach({
            self.contentView.addConstraints (
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[\($0)]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
            )
        })
        self.contentView.addConstraints (
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-left-[titleTextView]-right-|", options: NSLayoutFormatOptions(), metrics: metric, views: views)
        )
        self.contentView.addConstraints (
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-verticalTopMargin-[titleTextView]-verticalBottomMargin-[contentInfoView(==contentInfoViewHeight)]-0-[contentToolbar(==contentToolbarHeight)]-0-|", options: NSLayoutFormatOptions(), metrics: metric, views: views)
        )
    }
    
    func setup() {
        setupViews()
        setupConstraints()
        setupDispatching()
        
        let rec = UITapGestureRecognizer(target: self, action: #selector(LinkCell.didTapTitleGesture(recognizer:)))
        self.addGestureRecognizer(rec)
    }
    
    @objc func didTapTitleGesture(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: self.contentView)
        if titleTextView.frame.contains(location) {
            if let container = container {
                let userInfo: [String: Any] = ["link": container.link, "contents": container]
                NotificationCenter.default.post(name: LinkCellDidTapTitleNotification, object: nil, userInfo: userInfo)
            }
        }
    }
    
    // MARK: - Action
    
    @objc func didTapNameButton(sender: Any) {
        if let container = container {
            let userInfo: [String: Any] = ["name": container.link.author, "contents": container]
            NotificationCenter.default.post(name: LinkCellDidTapNameNotification, object: nil, userInfo: userInfo)
        }
    }
    
    @objc func didTapActionButton(sender: Any) {
        if let container = container {
            let userInfo: [String: Any] = ["link": container.link, "contents": container]
            NotificationCenter.default.post(name: LinkCellDidTapActionNotification, object: nil, userInfo: userInfo)
        }
    }
    
    @objc func didTapSaveButton(sender: Any) {
        if let container = container {
            container.save(saved: !container.link.saved)
            contentToolbar.setSaved(saved: !container.link.saved)
        }
    }
    
    @objc func didTapCommentButton(sender: Any) {
        if let container = container {
            let userInfo: [String: Any] = ["link": container.link, "contents": container]
            NotificationCenter.default.post(name: LinkCellDidTapCommentNotification, object: nil, userInfo: userInfo)
        }
    }
    
    @objc func tapUpVoteButton(sender: Any) {
        if let contents = self.container {
            switch contents.link.likes {
            case .up:
                contentToolbar.setVotingDirection(direction: .up)
            case .down:
                contentToolbar.setVotingDirection(direction: .none)
                contents.vote(voteDirection: .none)
            case .none:
                contentToolbar.setVotingDirection(direction: .up)
                contents.vote(voteDirection: .up)
            }
        }
    }
    
    @objc func tapDownVoteButton(sender: Any) {
        if let contents = self.container {
            switch contents.link.likes {
            case .up:
                contentToolbar.setVotingDirection(direction: .none)
                contents.vote(voteDirection: .none)
            case .down:
                contentToolbar.setVotingDirection(direction: .down)
            case .none:
                contentToolbar.setVotingDirection(direction: .down)
                contents.vote(voteDirection: .down)
            }
        }
    }
    
}
