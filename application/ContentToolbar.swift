//
//  ContentToolbar.swift
//  reddift
//
//  Created by sonson on 2016/01/31.
//  Copyright © 2016年 sonson. All rights reserved.
//

import reddift
import UIKit

class ContentToolbar: UIView {
    /// flag to colorize each view on this view.
    let viewDebugFlag = false
    
    static let height: CGFloat = 34
    let textColor = UIColor(red: 170.0/255.0, green: 184.0/255.0, blue: 194.0/255.0, alpha: 1)
    
    /// base views
    let commentBaseButton = UIButton.init(type: .custom)
    let voteBaseView = UIView.init(frame: CGRect.zero)
    let actionButton = UIButton.init(type: .custom)
    let saveButton = UIButton.init(type: .custom)

    /// subviews on comment base view.
    let commentContainerView = UIView.init(frame: CGRect.zero)
    let commentImageView = UIImageView.init(frame: CGRect.zero)
    let commentLabel  = UILabel.init(frame: CGRect.zero)
    var commentLabelWidthConstraint: NSLayoutConstraint?
    
    /// subviews on vote base view
    let upVoteButton = UIButton.init(type: .custom)
    let downVoteButton = UIButton.init(type: .custom)
    let voteInsideContainerView = UIView.init(frame: CGRect.zero)
    let voteImageView = UIImageView.init(frame: CGRect.zero)
    let voteLabel  = UILabel.init(frame: CGRect.zero)
    var voteLabelWidthConstraint: NSLayoutConstraint?
    
    /// Colorize all views on this view for debugging
    func colorizeBackgroundForDebuging() {
        commentBaseButton.backgroundColor = UIColor.red
        voteBaseView.backgroundColor = UIColor.green
        actionButton.backgroundColor = UIColor.blue
        
        commentImageView.backgroundColor = UIColor.cyan
        commentLabel.backgroundColor = UIColor.magenta
        commentContainerView.backgroundColor = UIColor.purple
        
        voteInsideContainerView.backgroundColor = UIColor.purple
        voteImageView.backgroundColor = UIColor.cyan
        voteLabel.backgroundColor = UIColor.magenta
        
        upVoteButton.backgroundColor = UIColor.green
        downVoteButton.backgroundColor = UIColor.blue
    }
    
    /**
    Update voting count of this view
    - parameter count: Voting count as Int.
    */
    func setVotingCount(count: Int) {
        if count > 0 { voteLabel.text = "+\(count)" } else if count < 0 { voteLabel.text = "\(count)" } else if count == 0 { voteLabel.text = " \(count)" }
        let max = CGFloat.greatestFiniteMagnitude
        let r = voteLabel.textRect(forBounds: CGRect(x: 0, y: 0, width: max, height: max), limitedToNumberOfLines: 1)
        if let constraint = self.voteLabelWidthConstraint {
            constraint.constant = r.size.width
        } else {
            let voteLabelWidthConstraint = NSLayoutConstraint(item: voteLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: r.size.width
            )
            voteLabel.addConstraint(voteLabelWidthConstraint)
            self.voteLabelWidthConstraint = voteLabelWidthConstraint
        }
    }
    
    /**
     Update comment count of this view
     - parameter count: Number of comments as Int.
     */
    func setCommentCount(count: Int) {
        commentLabel.text = "\(count)"
        let max = CGFloat.greatestFiniteMagnitude
        let r = commentLabel.textRect(forBounds: CGRect(x: 0, y: 0, width: max, height: max), limitedToNumberOfLines: 1)
        if let constraint = self.commentLabelWidthConstraint {
            constraint.constant = r.size.width
        } else {
            let commentLabelWidthConstraint = NSLayoutConstraint(item: commentLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: r.size.width
            )
            commentLabel.addConstraint(commentLabelWidthConstraint)
            self.commentLabelWidthConstraint = commentLabelWidthConstraint
        }
    }
    
    /**
     Update current user voting direction.
     - parameter direction: Vote direction as VoteDirection.
    */
    func setVotingDirection(direction: VoteDirection) {
        switch direction {
        case .up:
            upVoteButton.setImage(UIImage(named: "upVoteFill"), for: [])
            downVoteButton.setImage(UIImage(named: "downVote"), for: [])
        case .none:
            upVoteButton.setImage(UIImage(named: "upVote"), for: [])
            downVoteButton.setImage(UIImage(named: "downVote"), for: [])
        case .down:
            upVoteButton.setImage(UIImage(named: "upVote"), for: [])
            downVoteButton.setImage(UIImage(named: "downVoteFill"), for: [])
        }
    }
    
    func setSaved(saved: Bool) {
        if saved {
            saveButton.setImage(UIImage(named: "saveFill"), for: [])
        } else {
            saveButton.setImage(UIImage(named: "save"), for: [])
        }
    }
    
    func setup() {
        prepareBaseViews()
        autolayoutingBaseViews()
        prepareCommentCountView()
        autolayoutingCommentCountView()
        prepareVoteView()
        autolayoutingVoteView()
        
        /// Colorize views for debugging
        if viewDebugFlag { colorizeBackgroundForDebuging() }
        
        //// set initial content
        setCommentCount(count: 0)
        setVotingCount(count: 999999)
        setVotingDirection(direction: .none)
        setSaved(saved: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    /// init
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    /// Prepare base three views
    func prepareBaseViews() {
        /// Action button image
        actionButton.setImage(UIImage(named: "action"), for: [])
        saveButton.setImage(UIImage(named: "save"), for: [])
        
        /// Add subviews to this view.
        self.addSubview(commentBaseButton)
        self.addSubview(voteBaseView)
        self.addSubview(actionButton)
        self.addSubview(saveButton)
    }
    
    /// Autolayout, three base views.
    func autolayoutingBaseViews() {
        /// for Autolayout
        commentBaseButton.translatesAutoresizingMaskIntoConstraints = false
        voteBaseView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["commentBaseButton": commentBaseButton, "voteBaseView": voteBaseView, "actionButton": actionButton, "saveButton": saveButton]
        
        /// Vertical layouting
        ["commentBaseButton", "voteBaseView", "actionButton", "saveButton"].forEach {
            self.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|-0-[\($0)]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views
                )
            )
        }
        
        /// Horizontal layout
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[commentBaseButton]-0-[voteBaseView]-0-[saveButton]-0-[actionButton]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views
            )
        )
        
        /// Setup ratio of each width
        [(commentBaseButton, 0.6), (voteBaseView, 0.4), (saveButton, 1)].forEach {
            let constraint = NSLayoutConstraint(item: actionButton, attribute: .width, relatedBy: .equal, toItem: $0.0, attribute: .width, multiplier: CGFloat($0.1), constant: 0)
            self.addConstraint(constraint)
        }
    }
    
    /// Prepare, left comment count view.
    func prepareCommentCountView() {
        commentImageView.image = UIImage(named: "comments")
        
        commentLabel.font = UIFont.systemFont(ofSize: 12)
        
        commentBaseButton.addSubview(commentContainerView)
        commentContainerView.addSubview(commentImageView)
        commentContainerView.addSubview(commentLabel)
        
        commentLabel.textColor = textColor
        
        commentImageView.isUserInteractionEnabled = false
        commentLabel.isUserInteractionEnabled = false
        commentContainerView.isUserInteractionEnabled = false
    }
    
    /// Autolayout, left comment count view.
    func autolayoutingCommentCountView() {
        let iconImage = commentImageView.image
        let iconSize = iconImage?.size
        
        commentImageView.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        if let iconSize = iconSize {
            commentImageView.addConstraint(
                NSLayoutConstraint(item: commentImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: iconSize.width)
            )
            commentContainerView.addConstraint(
                NSLayoutConstraint(item: commentContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: iconSize.height)
            )
        }
        commentContainerView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[commentImageView]-4-[commentLabel]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["commentImageView": commentImageView, "commentLabel": commentLabel])
        )
        commentContainerView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[commentImageView]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["commentImageView": commentImageView, "commentLabel": commentLabel])
        )
        commentContainerView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[commentLabel]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["commentImageView": commentImageView, "commentLabel": commentLabel])
        )
        commentBaseButton.addConstraint(
            NSLayoutConstraint(item: commentContainerView, attribute: .centerX, relatedBy: .equal, toItem: commentBaseButton, attribute: .centerX, multiplier: 1, constant: 0)
        )
        commentBaseButton.addConstraint(
            NSLayoutConstraint(item: commentContainerView, attribute: .centerY, relatedBy: .equal, toItem: commentBaseButton, attribute: .centerY, multiplier: 1, constant: 0)
        )
    }
    
    /// Prepare center vote view.
    func prepareVoteView() {
        voteImageView.contentMode = .center
        voteLabel.font = UIFont.systemFont(ofSize: 12)
        voteLabel.textColor = textColor
        
        voteBaseView.addSubview(voteInsideContainerView)
        voteInsideContainerView.addSubview(upVoteButton)
        voteInsideContainerView.addSubview(downVoteButton)
        voteInsideContainerView.addSubview(voteImageView)
        voteInsideContainerView.addSubview(voteLabel)
        
        /// set images
        ["upVote": upVoteButton, "downVote": downVoteButton, "vote": voteImageView, "voteLabel": voteLabel].forEach {
            if let icon = UIImage(named: $0) {
                if let button = $1 as? UIButton {
                    button.setImage(icon, for: [])
                } else if let imageView = $1 as? UIImageView {
                    imageView.image = icon
                }
            }
        }
    }
    
    /// Autolayouting, center vote view.
    func autolayoutingVoteView() {
        voteImageView.translatesAutoresizingMaskIntoConstraints = false
        voteLabel.translatesAutoresizingMaskIntoConstraints = false
        voteInsideContainerView.translatesAutoresizingMaskIntoConstraints = false
        upVoteButton.translatesAutoresizingMaskIntoConstraints = false
        downVoteButton.translatesAutoresizingMaskIntoConstraints = false
        
        //
        voteBaseView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[voteInsideContainerView]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["voteInsideContainerView": voteInsideContainerView])
        )
        
        // horizontal constraints
        voteInsideContainerView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[voteImageView]-4-[voteLabel]-16-[upVoteButton]-12-[downVoteButton]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["upVoteButton": upVoteButton, "downVoteButton": downVoteButton, "voteImageView": voteImageView, "voteLabel": voteLabel])
        )
        
        // vertical constraints to title
        voteInsideContainerView.addConstraint(
            NSLayoutConstraint(item: voteLabel, attribute: .centerY, relatedBy: .equal, toItem: voteInsideContainerView, attribute: .centerY, multiplier: 1, constant: 0)
        )
        
        // prepare buttons
        [upVoteButton, downVoteButton, voteImageView, voteLabel].forEach {
            var iconImage: UIImage? = nil
            if let button = $0 as? UIButton {
                iconImage = button.imageView?.image
            } else if let imageView = $0 as? UIImageView {
                iconImage = imageView.image
            }
            if let iconImage = iconImage {
                $0.addConstraint(
                    NSLayoutConstraint(item: $0, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: iconImage.size.width)
                )
            }
            
            if let sv = $0.superview {
                let view = $0
                sv.addConstraints(NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["view": view])
                )
                
            }
        }
        
        voteBaseView.addConstraint(
            NSLayoutConstraint(item: voteInsideContainerView, attribute: .centerX, relatedBy: .equal, toItem: voteBaseView, attribute: .centerX, multiplier: 1, constant: 0)
        )
    }
}
