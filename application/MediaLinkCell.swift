//
//  MediaLinkCell.swift
//  reddift
//
//  Created by sonson on 2016/10/06.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

let MediaLinkCellSingleImageSize = false

class MediaLinkCell: LinkCell, ImageViewAnimator {
    var titleTextViewHeightConstraint: NSLayoutConstraint?
    var thumbnailViewHeightConstraint: NSLayoutConstraint?
    var thumbnailView: ImageLinkThumbnailView?
    
    func targetImageView(thumbnail: Thumbnail) -> UIImageView? {
        if let container = container as? LinkContainer, let thumbnailView = thumbnailView {
            if container.link.id == thumbnail.parentID {
                if var index = container.thumbnails.index(where: {$0.url == thumbnail.url}) {
                    if thumbnailView.imageViews.count > 0 {
                        index = index >= thumbnailView.imageViews.count ? thumbnailView.imageViews.count - 1 : index
                        return thumbnailView.imageViews[index]
                    }
                }
                return thumbnailView.imageViews.last
            }
        }
        return nil
    }
    
    func imageViews() -> [UIImageView] {
        if let thumbnailView = thumbnailView {
            return thumbnailView.imageViews
        } else {
            return []
        }
    }
    
    class func estimateHeight(titleHeight: CGFloat, numberOfThumbnails: Int) -> CGFloat {
        let thumbnailAreaHeight = ImageLinkThumbnailView.estimateHeight(numberOfThumbnails: numberOfThumbnails)
        return ThumbnailLinkCell.verticalTopMargin + ThumbnailLinkCell.verticalBotttomMargin + ContentInfoView.height + ContentToolbar.height + thumbnailAreaHeight + ceil(titleHeight)
    }
    
    // MARK: - Override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        if let container = container as? MediaLinkContainer {
            thumbnailViewHeightConstraint?.constant = container.imageHeight(for: self.frame.size.width)
            titleTextViewHeightConstraint?.constant = floor(container.titleSize.height)
        }
        super.layoutSubviews()
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
    
    init(numberOfThumbnails: Int) {
        super.init(style: .default, reuseIdentifier: ImageLinkThumbnailView.identifier(numberOfThumbnails: numberOfThumbnails))
        self.thumbnailView = ImageLinkThumbnailView(numberOfThumbnails: numberOfThumbnails)
        setup()
    }
    
    // MARK: - getter/setter
    
    override var container: LinkContainable? {
        didSet {
            if let container = container as? MediaLinkContainer {
                titleTextView.attributedString = container.attributedTitle
                contentInfoView.setNameText(name: container.link.author)
                contentInfoView.setDateText(created: container.link.createdUtc)
                contentInfoView.setDomainText(domain: container.link.domain)
                contentToolbar.setCommentCount(count: container.link.numComments)
                contentToolbar.setVotingCount(count: container.link.score)
                contentToolbar.setVotingDirection(direction: container.link.likes)
                thumbnailView?.thumbnails = container.thumbnails
            }
        }
    }
    
    // MARK: - Action
    
    @objc override func didTapTitleGesture(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: self.contentView)
        if titleTextView.frame.contains(location) {
            if let container = container {
                let userInfo: [String: Any] = ["link": container.link]
                NotificationCenter.default.post(name: LinkCellDidTapTitleNotification, object: nil, userInfo: userInfo)
            }
        }
    }
    
    @objc func didTapThumbnailGesture(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: thumbnailView)
        if let thumbnailView = self.thumbnailView, let container = container {
            for i in 0..<thumbnailView.imageViews.count {
                if thumbnailView.imageViews[i].frame.contains(location) {
                    let userInfo: [String: Any] = ["link": container.link, "thumbnail": thumbnailView.thumbnails[i], "view": thumbnailView.imageViews[i]]
                    NotificationCenter.default.post(name: LinkCellDidTapThumbnailNotification, object: nil, userInfo: userInfo)
                }
            }
        }
    }
    
    // MARK: - Setup
    
    override func setupDispatching() {
        super.setupDispatching()
        let rec1 = UITapGestureRecognizer(target: self, action: #selector(MediaLinkCell.didTapTitleGesture(recognizer:)))
        self.addGestureRecognizer(rec1)
        let rec2 = UITapGestureRecognizer(target: self, action: #selector(MediaLinkCell.didTapThumbnailGesture(recognizer:)))
        thumbnailView?.addGestureRecognizer(rec2)
    }
    
    override func setupViews() {
        selectionStyle = .none
        self.thumbnailView?.backgroundColor = UIColor.clear
        self.contentView.addSubview(titleTextView)
        self.contentView.addSubview(contentInfoView)
        self.contentView.addSubview(contentToolbar)
        titleTextView.backgroundColor = UIColor.clear
        titleTextView.isUserInteractionEnabled = false
        
        if let thumbnailView = self.thumbnailView {
            self.contentView.addSubview(thumbnailView)
        }
    }
    
    override func setupConstraints() {
        self.thumbnailView?.translatesAutoresizingMaskIntoConstraints = false
        contentInfoView.translatesAutoresizingMaskIntoConstraints = false
        contentToolbar.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        self.thumbnailView?.translatesAutoresizingMaskIntoConstraints = false
        if let thumbnailView = self.thumbnailView {
            setupHorizontalConstraints(thumbnailView: thumbnailView)
            setupVerticalConstraints(thumbnailView: thumbnailView)
        }
    }
    
    func setupHorizontalConstraints(thumbnailView: ImageLinkThumbnailView) {
        let views: [String: Any] = [
            "titleTextView": titleTextView,
            "contentInfoView": contentInfoView,
            "contentToolbar": contentToolbar,
            "thumbnailView": thumbnailView
            ]
        
        let metric: [String: Any] = [
            "thumbnailHeight": thumbnailView.height,
            "left": LinkCell.titleLeftMargin,
            "right": LinkCell.titleRightMargin
        ]
        
        ["thumbnailView", "contentInfoView", "contentToolbar"].forEach({
            self.contentView.addConstraints (
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[\($0)]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
            )
        })
        self.contentView.addConstraints (
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-left-[titleTextView]-right-|", options: NSLayoutFormatOptions(), metrics: metric, views: views)
        )
    }
    
    func setupVerticalConstraints(thumbnailView: ImageLinkThumbnailView) {
        // |-verticalTopMargin-[titleTextView]
        self.contentView.addConstraint(NSLayoutConstraint(item: titleTextView, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: LinkCell.verticalTopMargin))
        
        // [titleTextView(==titleTextViewHeightConstraint)]
        let titleTextViewHeightConstraint = NSLayoutConstraint(item: titleTextView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        titleTextView.addConstraint(titleTextViewHeightConstraint)
        self.titleTextViewHeightConstraint = titleTextViewHeightConstraint
        
        // [titleTextView]-verticalBottomMargin-[thumbnailView]
        self.contentView.addConstraint(NSLayoutConstraint(item: thumbnailView, attribute: .top, relatedBy: .equal, toItem: titleTextView, attribute: .bottom, multiplier: 1, constant: LinkCell.verticalBotttomMargin))
        
        // [thumbnailView(==thumbnailHeight)]
        let thumbnailViewHeightConstraint = NSLayoutConstraint(item: thumbnailView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        thumbnailView.addConstraint(thumbnailViewHeightConstraint)
        self.thumbnailViewHeightConstraint = thumbnailViewHeightConstraint
        
        // [thumbnailView]-0-[contentInfoView]
        self.contentView.addConstraint(NSLayoutConstraint(item: thumbnailView, attribute: .bottom, relatedBy: .equal, toItem: contentInfoView, attribute: .top, multiplier: 1, constant: 0))
        
        // [contentInfoView(==contentInfoViewHeight)]
        contentInfoView.addConstraint(NSLayoutConstraint(item: contentInfoView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: ContentInfoView.height))
        
        // [contentInfoView]-0-[contentToolbar]
        self.contentView.addConstraint(NSLayoutConstraint(item: contentInfoView, attribute: .bottom, relatedBy: .equal, toItem: contentToolbar, attribute: .top, multiplier: 1, constant: 0))
        
        // [contentToolbar(==constraintInfoViewAndToolbar)]
        contentToolbar.addConstraint(NSLayoutConstraint(item: contentToolbar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: ContentToolbar.height))
        
        // Comment out to avoid autolayout errors.
        // [contentToolbar]-0-|
        // self.contentView.addConstraint(NSLayoutConstraint(item: contentToolbar, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: 0))
    }
}
