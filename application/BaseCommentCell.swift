//
//  BaseCommentCell.swift
//  reddift
//
//  Created by sonson on 2016/08/27.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

class BaseCommentCell: UITableViewCell {
    let topInformationView: UIView = UIView(frame: CGRect.zero)
    
    let verticalBar: UIView = UIView(frame: CGRect.zero)
    
    var topInformationViewHeight: NSLayoutConstraint?
    var varticalBarWidth: NSLayoutConstraint?
    var varticalBarLeftMargin: NSLayoutConstraint?
    
    let authorButton = UIButton(type: .custom)
    let voteLabel = UILabel(frame: CGRect.zero)
    let dateLabel = UILabel(frame: CGRect.zero)
    let childlenLabel = UILabel(frame: CGRect.zero)
    let toggleButton = UIButton(type: .custom)
    
    var authorButtonWidth: NSLayoutConstraint?
    var authorButtonHeight: NSLayoutConstraint?
    var voteLabellWidth: NSLayoutConstraint?
    var voteLabelHeight: NSLayoutConstraint?
    var dateLabelWidth: NSLayoutConstraint?
    var dateLabelHeight: NSLayoutConstraint?
    var childlenLabelWidth: NSLayoutConstraint?
    var childlenLabelHeight: NSLayoutConstraint?
    var toggleButtonWidth: NSLayoutConstraint?
    var toggleButtonHeight: NSLayoutConstraint?
    
    static let verticalBarWidth         = CGFloat(3)
    
    static let informationViewHeight    = CGFloat(37)
    static let labelHeight              = CGFloat(20)
    static let leftMargin               = CGFloat(5)
    static let infoLabelHorizontalSpace = CGFloat(5)
    static let expandIconWidth          = CGFloat(20)
    static let expandIconHeight         = CGFloat(20)
    
    weak var parentCommentViewController: CommentViewController?
    
    @objc func didPushToggleButton(sender: Any) {
        if let cc = parentCommentViewController {
            cc.didPushToggleButtonOnCell(self)
        }
    }
    
    class func estimateCommentAreaWidth(depth: Int, width: CGFloat) -> CGFloat {
        // depth = 1 -> 5 (special case)
        // depth = 2 -> 11
        // depth = 3 -> 14
        // depth = 5 -> 17
        return width - (estimateBarLeftMargin(depth: depth) + leftMargin + verticalBarWidth)
    }
    
    class func estimateBarLeftMargin(depth: Int) -> CGFloat {
        // depth = 1 -> -3 (special case)
        // depth = 2 -> 3
        // depth = 3 -> 6
        // depth = 5 -> 9
        switch depth {
        case 1:
            return -verticalBarWidth
        default:
            return (CGFloat(depth) - 1) * verticalBarWidth
        }
    }
    
    func prepareLabel(label: UIView, baseView: UIView) -> (NSLayoutConstraint?, NSLayoutConstraint?) {
        label.translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        label.addConstraint(widthConstraint)
        let heightConstraint = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CommentCell.labelHeight)
        label.addConstraint(heightConstraint)
        let verticalCentering = NSLayoutConstraint(item: baseView, attribute: .centerY, relatedBy: .equal, toItem: label, attribute: .centerY, multiplier: 1, constant: 0)
        baseView.addConstraint(verticalCentering)
        
        return (widthConstraint, heightConstraint)
    }
    
    func updateSizeOfLabel(label: UILabel, widthConstraint: NSLayoutConstraint?, heightConstraint: NSLayoutConstraint?) {
        let max = CGFloat.greatestFiniteMagnitude
        let bounds = label.textRect(forBounds: CGRect(x: 0, y: 0, width: max, height: max), limitedToNumberOfLines: 1)
        if let c = widthConstraint {
            c.constant = bounds.size.width
        }
        if let c = heightConstraint {
            c.constant = bounds.size.height
        }
    }
    
    func updateSizeOfButton(button: UIButton, widthConstraint: NSLayoutConstraint?, heightConstraint: NSLayoutConstraint?) {
        if let label = button.titleLabel {
            let max = CGFloat.greatestFiniteMagnitude
            let bounds = label.textRect(forBounds: CGRect(x: 0, y: 0, width: max, height: max), limitedToNumberOfLines: 1)
            if let c = widthConstraint {
                c.constant = bounds.size.width
            }
            if let c = heightConstraint {
                c.constant = bounds.size.height
            }
        }
    }
    
    func prepareToggleButton() {
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        toggleButtonWidth = NSLayoutConstraint(item: toggleButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        toggleButton.addConstraint(toggleButtonWidth!)
        toggleButtonHeight = NSLayoutConstraint(item: toggleButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        toggleButton.addConstraint(toggleButtonHeight!)
        let verticalCentering = NSLayoutConstraint(item: topInformationView, attribute: .centerY, relatedBy: .equal, toItem: toggleButton, attribute: .centerY, multiplier: 1, constant: 0)
        topInformationView.addConstraint(verticalCentering)
        toggleButton.setImage(UIImage.init(named: "fold"), for: .normal)
        toggleButtonWidth?.constant = BaseCommentCell.expandIconWidth
        toggleButtonHeight?.constant = BaseCommentCell.expandIconHeight
    }
    
    func prepareInformationView() {
        
        let views = [
            "topInformationView": topInformationView,
            "authorButton": authorButton,
            "voteLabel": voteLabel,
            "dateLabel": dateLabel,
            "childlenLabel": childlenLabel,
            "toggleButton": toggleButton
        ]
        
        let metric = [
            "space": CommentCell.infoLabelHorizontalSpace
        ]
        
        authorButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        voteLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        childlenLabel.font = UIFont.systemFont(ofSize: 14)
        
        authorButton.setTitleColor(UIColor.black, for: [])
        voteLabel.textColor = UIColor(red: 154/255.0, green: 169/255.0, blue: 180/255.0, alpha: 1)
        dateLabel.textColor = UIColor(red: 154/255.0, green: 169/255.0, blue: 180/255.0, alpha: 1)
        childlenLabel.textColor = UIColor(red: 154/255.0, green: 169/255.0, blue: 180/255.0, alpha: 1)
        
        topInformationView.addSubview(authorButton)
        topInformationView.addSubview(voteLabel)
        topInformationView.addSubview(dateLabel)
        topInformationView.addSubview(childlenLabel)
        topInformationView.addSubview(toggleButton)
        
        (authorButtonWidth, authorButtonHeight) = prepareLabel(label: authorButton, baseView: topInformationView)
        (voteLabellWidth, voteLabelHeight) = prepareLabel(label: voteLabel, baseView: topInformationView)
        (dateLabelWidth, dateLabelHeight) = prepareLabel(label: dateLabel, baseView: topInformationView)
        (childlenLabelWidth, childlenLabelHeight) = prepareLabel(label: childlenLabel, baseView: topInformationView)
        
        prepareToggleButton()
        
        topInformationView.addConstraints (
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-space-[authorButton]-space-[voteLabel]-space-[dateLabel]-(>=0)-[childlenLabel]-space-[toggleButton]-space-|", options: NSLayoutFormatOptions(), metrics: metric, views: views)
        )
        
        voteLabel.text = "+100"
        dateLabel.text = "3h"
        updateSizeOfLabel(label: voteLabel, widthConstraint: voteLabellWidth, heightConstraint: voteLabelHeight)
        updateSizeOfLabel(label: dateLabel, widthConstraint: dateLabelWidth, heightConstraint: dateLabelHeight)
        
        authorButton.setTitle("sonson", for: [])
        updateSizeOfButton(button: authorButton, widthConstraint: authorButtonWidth, heightConstraint: authorButtonHeight)
        childlenLabel.text = ""
        updateSizeOfLabel(label: childlenLabel, widthConstraint: childlenLabelWidth, heightConstraint: childlenLabelHeight)
        
        toggleButton.addTarget(self, action: #selector(BaseCommentCell.didPushToggleButton(sender:)), for: .touchUpInside)
    }
}
