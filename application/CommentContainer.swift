//
//  CommentContainer.swift
//  reddift
//
//  Created by sonson on 2016/09/29.
//  Copyright © 2016年 sonson. All rights reserved.
//

import reddift
import Foundation

private let asciiArtDetector: NSRegularExpression! = {
    do {
        return try NSRegularExpression(pattern: "(?:　{4}|(?: 　){2}|[─￣_＿]{4})", options: .caseInsensitive)
    } catch {
        assert(false, "Fatal error: \(#file) \(#line) \(error)")
        return nil
    }
}()

private func prepareHTML(html: String, constrainedBy width: CGFloat, fontSize: CGFloat) -> (NSAttributedString, CGFloat, Bool, CGFloat) {
    let html = html.preprocessedHTMLStringBeforeNSAttributedStringParsing
    do {
        if let data = html.data(using: .unicode) {
            let attr = try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            
            let isAA = (asciiArtDetector.firstMatch(in: attr.string, options: [], range: attr.string.fullRange) != nil)
            
            if isAA {
                let font = UIFont(name: "Mona", size: fontSize)!
                let output = NSMutableAttributedString(string: attr.string)
                output.addAttribute(NSAttributedString.Key.font, value: font, range: attr.string.fullRange)
                let bodySize = UZTextView.size(for: output, withBoundWidth: CGFloat.greatestFiniteMagnitude, margin: UIEdgeInsets.zero)
                print("--------------------------------")
                print("boundWidth=\(width)")
                print("bodySize.width=\(bodySize.width)")
                var AAScale = CGFloat(1)
                if bodySize.width > 0 {
                    AAScale = (width / bodySize.width)
                    AAScale = AAScale < 1 ? AAScale : 1
                } else {
                    AAScale = 1
                }
                let bodyHeight = bodySize.height * AAScale
                return (output, bodyHeight, isAA, AAScale)
            } else {
                let body = attr.reconstruct(with: UIFont.systemFont(ofSize: fontSize), color: UIColor.black, linkColor: UIColor.blue)
                let bodySize = UZTextView.size(for: body, withBoundWidth: width, margin: UIEdgeInsets.zero)
                let bodyHeight = bodySize.height
                return (body, bodyHeight, false, 1)
            }
        } else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
    } catch {
        return (NSAttributedString(string: ""), 0, false, 1)
    }
}

class CommentContainer: CommentContainable {
    // Payload
    internal var intrinsicComment: Comment
    var comment: Comment {
        get {
            return intrinsicComment
        }
    }
    
    // Contents
    var body: NSAttributedString
    var bodyHeight: CGFloat
    var isAA = false
    var AAScale = CGFloat(1)
    
    // Thumbnails
    var urlContainer: [ImageURLContainer] = []
    var thumbnails: [Thumbnail] {
        get {
            return urlContainer.flatMap({$0.imageURL})
        }
    }
    
    init(with comment: Comment, depth: Int, width: CGFloat, fontSize: CGFloat = 14) {
        self.intrinsicComment = comment
        let boundWidth = CommentCell.estimateCommentAreaWidth(depth: depth, width: width)
        (self.body, self.bodyHeight, self.isAA, self.AAScale) = prepareHTML(html: comment.bodyHtml, constrainedBy: boundWidth, fontSize: fontSize)
        super.init(with: comment, depth: depth)
        urlContainer = extractURLsFromBody()
    }
    
    override var intrinsicThing: Thing {
        didSet {
            DispatchQueue.main.async(execute: { () -> Void in
                if let comment = self.thing as? Comment {
                    self.intrinsicComment = comment
                    NotificationCenter.default.post(name: ThingContainableDidUpdate, object: nil, userInfo: ["contents": self])
                }
            })
        }
    }
    
    override var height: CGFloat {
        get {
            if isHidden {
                return 0
            }
            if isCollapsed {
                return CommentCell.informationViewHeight
            }
            return bodyHeight + CommentCell.informationViewHeight + CommentCell.toolbarHeight + CommentCell.toolbarTopSpace + CommentThumbnailView.estimateHeight(numberOfThumbnails: numberOfThumbnails)
        }
    }

    var numberOfThumbnails: Int {
        get {
            return thumbnails.count
        }
    }
    
    func extractURLsFromBody() -> [ImageURLContainer] {
        var list: [ImageURLContainer] = []
        body.enumerateAttribute(NSAttributedString.Key.link, in: NSRange(location: 0, length: body.length), options: NSAttributedString.EnumerationOptions(), using: { (value: Any?, _, _) -> Void in
            if let url = value as? URL {
                if url.isImageURL {
                    list.append(ImageURLInComment(sourceURL: url, parentID: self.thing.id))
                } else if url.isYouTubeURL {
                    if let urlset = url.extractYouTubeURL() {
                        list.append(MovieURLInComment(sourceURL: urlset.0, thumbnailURL: urlset.1, parentID: self.thing.id))
                    }
                } else if url.isImgurURL {
                    list.append(ImgurURLInComment(sourceURL: url, parentID: self.thing.id))
                } else if url.isGfygatURL {
                    if let urlset = url.extractGfycatURL() {
                        list.append(MovieURLInComment(sourceURL: urlset.0, thumbnailURL: urlset.1, parentID: self.thing.id))
                    }
                }
            }
        })
        return list
    }
    
    ///
    override func layout(with width: CGFloat, fontSize: CGFloat) {
        let boundWidth = CommentCell.estimateCommentAreaWidth(depth: depth, width: width)
        (self.body, self.bodyHeight, self.isAA, self.AAScale) = prepareHTML(html: comment.bodyHtml, constrainedBy: boundWidth, fontSize: fontSize)
    }
    
    override func downloadImages() {
        download(imageURLs: thumbnails.map({$0.thumbnailURL}), sender: self)
    }
    
    override var cellIdentifier: String {
        get {
            if isHidden {
                return "InvisibleCell"
            }
            if isCollapsed {
                return "CloseCommentCell"
            }
            if isLoading {
                return "LoadingCell"
            }
            return CommentThumbnailView.identifier(numberOfThumbnails: numberOfThumbnails)
        }
    }
}
