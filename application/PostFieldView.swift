//
//  PostFieldView.swift
//  reddift
//
//  Created by sonson on 2016/12/12.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

class PostFieldView: UIView {
    let label = UILabel(frame: CGRect.zero)
    let field = UITextField(frame: CGRect.zero)
    let line = UIView(frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    func setupSubviews() {
        let views: [String: Any] = [
            "label": label,
            "line": line,
            "field": field
        ]
        label.text = "from"
        field.text = "aa"
        line.backgroundColor = UIColor.black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        field.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        
        label.textAlignment = .right
        field.textAlignment = .left
        
        self.addSubview(label)
        self.addSubview(field)
        self.addSubview(line)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[label]-10-[field]-10-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[label]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[field]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[line]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(==0.5)]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        self.addConstraint(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.1, constant: 0))
    }
}
