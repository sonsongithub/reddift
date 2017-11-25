//
//  ContentInfoView.swift
//  reddift
//
//  Created by sonson on 2016/02/02.
//  Copyright © 2016年 sonson. All rights reserved.
//

import UIKit

protocol ContentInfoViewDelegate {
    func didTapAuthorsNameButtonOnContentInfoView(contentInfoView: ContentInfoView)
}

extension NSDate {
    /**
    Generate string which means created date, such as 3d, 1h, 1y.
    - parameter createdUtc: Created UTC time as Int.
    - returns: String, means created date.
    */
    class func createdDateDescription(createdUtc: Int) -> String {
        let d = NSDate(timeIntervalSince1970: Double(createdUtc))
        let diff = Int(NSDate().timeIntervalSince1970 - d.timeIntervalSince1970)
        if diff < 3600 {
            let minutes = diff / 60
            return "\(minutes)m"
        }
        if diff < 3600 * 24 {
            let hours = diff / 3600
            return "\(hours)h"
        }
        if diff < 3600 * 24 * 31 {
            let days = diff / 3600 / 24
            return "\(days)d"
        }
        if diff < 3600 * 24 * 31 * 365 {
            let months = diff / 3600 / 24 / 31
            return "\(months)mo"
        }
        let years = diff / 3600 / 365
        return "\(years)y"
    }
}

/**
 A view on Link content cell.
 This view shows created time, author and domain.
 User can tap author's name as UIButton.
*/
class ContentInfoView: UIView {
    ///
    static let height = CGFloat(34)
    static let labelHorizontalMargin = CGFloat(8)
    
    let viewDebugFlag = false
    
    /// Default text color
    static let defaultTextColor = UIColor(red: 170.0/255.0, green: 184.0/255.0, blue: 194.0/255.0, alpha: 1)
    
    let dateLabel: UILabel = UILabel.init(frame: CGRect.zero)
    let nameButton: UIButton = UIButton.init(type: .custom)
    let domainLabel: UILabel = UILabel.init(frame: CGRect.zero)
    
    var dateLabelWidthContraint: NSLayoutConstraint?
    var nameButtonWidthContraint: NSLayoutConstraint?
    var domainLabelWidthContraint: NSLayoutConstraint?
    
    var delegate: ContentInfoViewDelegate?
    
    /// Text color of all strings.
    var textColor = ContentInfoView.defaultTextColor {
        didSet {
            dateLabel.textColor = textColor
            nameButton.titleLabel?.textColor = textColor
            domainLabel.textColor = textColor
        }
    }
    
    /// Background color of all views.
    override var backgroundColor: UIColor? {
        didSet {
            dateLabel.backgroundColor = self.backgroundColor
            nameButton.backgroundColor = self.backgroundColor
            domainLabel.backgroundColor = self.backgroundColor
        }
    }
    
    func setup() {
        /// colorize for debugging
        if viewDebugFlag {
            dateLabel.backgroundColor = UIColor.red
            nameButton.backgroundColor = UIColor.green
            domainLabel.backgroundColor = UIColor.blue
        }
        
        domainLabel.textAlignment = .right
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        nameButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        domainLabel.font = UIFont.systemFont(ofSize: 14)
        
        dateLabel.textColor = textColor
        nameButton.setTitleColor(textColor, for: [])
        domainLabel.textColor = textColor
        
        self.addSubview(domainLabel)
        self.addSubview(nameButton)
        self.addSubview(dateLabel)
        
        setupAutolayout()
        
        /// set initial data
        setDateText(created: 0)
        setNameText(name: "")
        setDomainText(domain: "")
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
    
    /// setup autolayout
    func setupAutolayout() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        nameButton.translatesAutoresizingMaskIntoConstraints = false
        domainLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setupVerticalContraintsToLabel(view: dateLabel)
        setupVerticalContraintsToLabel(view: nameButton)
        setupVerticalContraintsToLabel(view: domainLabel)
        
        let metric = [
            "labelHorizontalMargin": ContentInfoView.labelHorizontalMargin
        ]
        
        self.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-labelHorizontalMargin-[dateLabel]-labelHorizontalMargin-[nameButton]-(>=0)-[domainLabel]-labelHorizontalMargin-|",
                options: NSLayoutFormatOptions(),
                metrics: metric,
                views: ["dateLabel": dateLabel, "nameButton": nameButton, "domainLabel": domainLabel])
        )
        
        self.dateLabelWidthContraint = setupHorizontalContraintsToLabel(view: dateLabel)
        self.nameButtonWidthContraint = setupHorizontalContraintsToLabel(view: nameButton)
        self.domainLabelWidthContraint = setupHorizontalContraintsToLabel(view: domainLabel)
    }
    
    /**
     Set date description to the view.
     - parameter created: Created time interval since 1970 at UTC as Int.
    */
    func setDateText(created: Int) {
        let max = CGFloat.greatestFiniteMagnitude
        dateLabel.text = NSDate.createdDateDescription(createdUtc: created)
        let rect = dateLabel.textRect(forBounds: CGRect(x: 0, y: 0, width: max, height: max), limitedToNumberOfLines: 1)
        if let constraint = dateLabelWidthContraint {
            constraint.constant = rect.size.width
        }
    }
    
    /**
     Set author's name to the view.
     - parameter name: Author's name as String.
     */
    func setNameText(name: String) {
        let max = CGFloat.greatestFiniteMagnitude
        nameButton.setTitle(name, for: [])
        let rect = nameButton.titleLabel?.textRect(forBounds: CGRect(x: 0, y: 0, width: max, height: max), limitedToNumberOfLines: 1)
        if let constraint = nameButtonWidthContraint, let rect = rect {
            constraint.constant = rect.size.width
        }
    }
    
    /**
     Set domain to the view.
     - parameter name: Domain as String.
     */
    func setDomainText(domain: String) {
        let max = CGFloat.greatestFiniteMagnitude
        domainLabel.text = domain
        let rect = domainLabel.textRect(forBounds: CGRect(x: 0, y: 0, width: max, height: max), limitedToNumberOfLines: 1)
        if let constraint = domainLabelWidthContraint {
            constraint.constant = rect.size.width
        }
    }
    
    /**
     Set horizontal constraints to each view.
     - parameter view: Target view.
     - returns: Cosntraint object as NSLayoutConstraint.
     */
    func setupHorizontalContraintsToLabel(view: UIView) -> NSLayoutConstraint {
        let initialWidth = CGFloat(0)
        let constraint = NSLayoutConstraint(item: view,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: initialWidth)
        view.addConstraints([constraint])
        return constraint
    }
    
    /**
     Set vertical constraints to each view.
     - parameter view: Target view.
     */
    func setupVerticalContraintsToLabel(view: UIView) {
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[view]-0-|",
                options: NSLayoutFormatOptions(),
                metrics: nil,
                views: ["view": view]
            )
        )
//        let constraintCenterY = NSLayoutConstraint(
//            item: self,
//            attribute: .CenterY,
//            relatedBy: .Equal,
//            toItem: view,
//            attribute: .CenterY,
//            multiplier: 1,
//            constant: 0)
//        let constraintHeight = NSLayoutConstraint(
//            item: view,
//            attribute: .Height,
//            relatedBy: .Equal,
//            toItem: nil,
//            attribute: .NotAnAttribute,
//            multiplier: 1,
//            constant: 24)
//        self.addConstraints([constraintCenterY, constraintHeight])
    }
}
