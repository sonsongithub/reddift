//
//  LinkContainable.swift
//  reddift
//
//  Created by sonson on 2016/09/29.
//  Copyright © 2016年 sonson. All rights reserved.
//

import reddift
import Foundation

let LinkContainerDidLoadImageName = Notification.Name(rawValue: "LinkContainerDidLoadImageName")

private let regexForImageURL: NSRegularExpression! = {
    do {
        return try NSRegularExpression(pattern: "((jpg)|(jpeg)|(gif)|(png))$", options: .caseInsensitive)
    } catch {
        assert(false, "Fatal error: \(#file) \(#line) \(error)")
        return nil
    }
}()

class LinkContainable: ThingContainable, ImageDownloadable {
    /// reddift raw data
    internal var intrinsicLink: Link
    var link: Link {
        get {
            return intrinsicLink
        }
    }
    
    /// Attributed string for UITableViewCell's title
    var attributedTitle: NSAttributedString
    
    /// Size of view to render title as an attributed string in the cell, including margin size.
    var titleSize: CGSize
    
    ///
    var pageLoaded: Bool
    
    var thumbnails: [Thumbnail] = []
    
    var width = CGFloat(0)

    /// Height of cell which contains the content
    override var height: CGFloat {
        if isHidden {
            return 0
        } else {
            return LinkCell.estimateHeight(titleHeight: titleSize.height)
        }
    }
    
    override var intrinsicThing: Thing {
        didSet {
            DispatchQueue.main.async(execute: { () -> Void in
                if let link = self.thing as? Link {
                    self.intrinsicLink = link
                    NotificationCenter.default.post(name: ThingContainableDidUpdate, object: nil, userInfo: ["contents": self])
                }
            })
        }
    }

    /// Method to download attional contents or images when the cell is updated.
    func downloadImages() {
    }

    /// Download and parse html page, like imgur image list.
    func prefetch(at: IndexPath) {
    }
    
    func layout(with width: CGFloat, fontSize: CGFloat) {
        self.width = width
        let font = UIFont(name: UIFont.systemFont(ofSize: fontSize).fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        attributedTitle = NSAttributedString(string: link.title).reconstruct(with: font, color: UIColor.black, linkColor: UIColor.blue)
        titleSize = LinkCell.estimateTitleSize(attributedString: attributedTitle, withBountWidth: width, margin: .zero)
    }
    
    init(with link: Link, width: CGFloat, fontSize: CGFloat = 18) {
        self.intrinsicLink = link
        self.width = width
        let font = UIFont(name: UIFont.systemFont(ofSize: fontSize).fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        attributedTitle = NSAttributedString(string: link.title).reconstruct(with: font, color: UIColor.black, linkColor: UIColor.blue)
        titleSize = LinkCell.estimateTitleSize(attributedString: attributedTitle, withBountWidth: width, margin: .zero)
        pageLoaded = true
        super.init(with: link)
    }
    
    static func createContainer(with link: Link, width: CGFloat, fontSize: CGFloat = 14) -> LinkContainable {
        guard let url = URL(string: link.url) else { return LinkContainer(with: link, width: width, fontSize: fontSize) }
        
        // simple image URL
        if let _ = regexForImageURL.firstMatch(in: link.url as String, options: [], range: NSRange(location: 0, length: (link.url as NSString).length)) {
            if let imageURL = URL(string: link.url) {
                let thumbnail = Thumbnail.Image(imageURL: imageURL, parentID: link.id)
                return MediaLinkContainer(link: link, width: width, fontSize: fontSize, thumbnails: [thumbnail])
            }
        }
        
        if url.isGfygatURL {
            if let urlset = url.extractGfycatURL() {
                let thumbnail = Thumbnail.Movie(movieURL: urlset.0, thumbnailURL: urlset.1, parentID: link.id)
                return MediaLinkContainer(link: link, width: width, fontSize: fontSize, thumbnails: [thumbnail])
            }
        }
        
        if url.isYouTubeURL {
            if let urlset = url.extractYouTubeURL() {
                let thumbnail = Thumbnail.Movie(movieURL: urlset.0, thumbnailURL: urlset.1, parentID: link.id)
                return MediaLinkContainer(link: link, width: width, fontSize: fontSize, thumbnails: [thumbnail])
            }
        }
        
        // image URL of imgur
        if url.isImgurURL {
            return ImgurLinkContainer(link: link, width: width, fontSize: fontSize, thumbnails: [])
        }
        
        // contents with thumbnail
        if let thumbnailURL = URL(string: link.thumbnail), let _ = URL(string: link.url), let _ = thumbnailURL.scheme {
            let thumbnail = Thumbnail.Image(imageURL: thumbnailURL, parentID: link.id)
            return ThumbnailLinkContainer(link: link, width: width, fontSize: fontSize, thumbnail: thumbnail)
        }
        
        return LinkContainer(with: link, width: width, fontSize: fontSize)
    }
}
