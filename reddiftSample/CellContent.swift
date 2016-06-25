//
//  CellContent.swift
//  reddift
//
//  Created by sonson on 2015/04/25.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

struct CellContent {
    let attributedString: AttributedString
    let textHeight: CGFloat
    
    init(string: AttributedString, width: CGFloat) {
        attributedString = string
        let horizontalMargin = UZTextViewCell.margin().left + UZTextViewCell.margin().right
        let verticalMargin = UZTextViewCell.margin().top + UZTextViewCell.margin().bottom
        let size = UZTextView.size(for: attributedString, withBoundWidth:width - horizontalMargin, margin: UIEdgeInsetsMake(0, 0, 0, 0))
        textHeight = size.height + verticalMargin
    }
    
    init(string: String, width: CGFloat, fontSize: CGFloat = 14) {
        let font = UIFont(name: UIFont.systemFont(ofSize: fontSize).fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        attributedString = AttributedString(string: string, attributes: [NSFontAttributeName : font])
        let horizontalMargin = UZTextViewCell.margin().left + UZTextViewCell.margin().right
        let verticalMargin = UZTextViewCell.margin().top + UZTextViewCell.margin().bottom
        let size = UZTextView.size(for: attributedString, withBoundWidth:width - horizontalMargin, margin: UIEdgeInsetsMake(0, 0, 0, 0))
        textHeight = size.height + verticalMargin
    }
    
    init(string: AttributedString, width: CGFloat, hasRelies: Bool) {
        attributedString = string
        let horizontalMargin = UZTextViewCell.margin().left + UZTextViewCell.margin().right
        let verticalMargin = UZTextViewCell.margin().top + UZTextViewCell.margin().bottom
        let size = UZTextView.size(for: attributedString, withBoundWidth:width - horizontalMargin, margin: UIEdgeInsetsMake(0, 0, 0, 0))
        if hasRelies {
            textHeight = size.height + verticalMargin + 39
        } else {
            textHeight = size.height + verticalMargin
        }
    }
    
    init(string: String, width: CGFloat, hasRelies: Bool, fontSize: CGFloat = 14) {
        let font = UIFont(name: UIFont.systemFont(ofSize: fontSize).fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        attributedString = AttributedString(string: string, attributes: [NSFontAttributeName : font])
        let horizontalMargin = UZTextViewCell.margin().left + UZTextViewCell.margin().right
        let verticalMargin = UZTextViewCell.margin().top + UZTextViewCell.margin().bottom
        let size = UZTextView.size(for: attributedString, withBoundWidth:width - horizontalMargin, margin: UIEdgeInsetsMake(0, 0, 0, 0))
        if hasRelies {
            textHeight = size.height + verticalMargin + 39
        } else {
            textHeight = size.height + verticalMargin
        }
    }
}
