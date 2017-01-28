//
//  ThumbnailLinkContainer.swift
//  reddift
//
//  Created by sonson on 2016/10/05.
//  Copyright © 2016年 sonson. All rights reserved.
//

import reddift
import Foundation

class ThumbnailLinkContainer: LinkContainer {
    let thumbnailURL: URL
    
    /// Cell identifier for dequeueReusableCellWithIdentifier of FrontViewController class.
    override var cellIdentifier: String {
        get {
            if isHidden {
                return "InvisibleCell"
            } else {
                return "ThumbnailLinkCell"
            }
        }
    }
    
    override var height: CGFloat {
        if isHidden {
            return 0
        } else {
            return ThumbnailLinkCell.estimateHeight(titleHeight: titleSize.height)
        }
    }
    
    init(link: Link, width: CGFloat, fontSize: CGFloat = 18, thumbnail: Thumbnail) {
        self.thumbnailURL = thumbnail.url
        super.init(with: link, width: width, fontSize: fontSize)
        self.thumbnails = [thumbnail]
        let font = UIFont(name: UIFont.systemFont(ofSize: fontSize).fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        attributedTitle = NSAttributedString(string: link.title).reconstruct(with: font, color: UIColor.black, linkColor: UIColor.blue)
        titleSize = ThumbnailLinkCell.estimateTitleSize(attributedString: attributedTitle, withBountWidth: width, margin: .zero)
        pageLoaded = true
    }
    
    /// download thumbnail
    override func downloadImages() {
        download(imageURLs: [thumbnailURL], sender: self)
    }
}
