//
//  CommentThumbnailView.swift
//  reddift
//
//  Created by sonson on 2016/03/16.
//  Copyright © 2016年 sonson. All rights reserved.
//

import UIKit

let ThumbnailDidTap = Notification.Name(rawValue: "ThumbnailDidTap")

class CommentThumbnailView: UIView, ImageDownloadable {
    
    var thumbnails: [Thumbnail] = []
    
    static let numberOfColumns: Int = 5
    static let thumbnailHeight: CGFloat = 80
    
    var imageViews: [UIImageView] = []
    
    var viewTupleForURL: [String: (UIImageView, UIActivityIndicatorView)] = [:]
    var activityIndicators: [UIActivityIndicatorView] = []
    var activityIndicatorURLDictionary: [String: UIActivityIndicatorView] = [:]
    let numberOfRows: Int
    var numberOfThumbnails: Int
    
    var height: CGFloat {
        get {
            return CommentThumbnailView.thumbnailHeight * CGFloat(numberOfRows) + (numberOfRows > 0 ? 2 * CGFloat(numberOfRows - 1) : 0)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let p = touch?.location(in: self) {
            for i in 0 ..< thumbnails.count {
                if imageViews[i].frame.contains(p) {
                    let userInfo = [
                        "Thumbnail": thumbnails[i]
                    ]
                    NotificationCenter.default.post(name: ThumbnailDidTap, object: nil, userInfo: userInfo)
                }
            }
        }
    }
    
    static func estimateHeight(numberOfThumbnails: Int) -> CGFloat {
        let numberOfRows = numberOfThumbnails / CommentThumbnailView.numberOfColumns + ((numberOfThumbnails % CommentThumbnailView.numberOfColumns > 0) ? 1 : 0)
        return CommentThumbnailView.thumbnailHeight * CGFloat(numberOfRows) + (numberOfRows > 0 ? 2 * CGFloat(numberOfRows - 1) : 0)
    }
    
    static func identifier(numberOfThumbnails: Int) -> String {
        let numberOfRows = numberOfThumbnails / CommentThumbnailView.numberOfColumns + ((numberOfThumbnails % CommentThumbnailView.numberOfColumns > 0) ? 1 : 0)
        return "CommentCell_\(numberOfRows)"
    }
    
    func prepareImageViews() {
        for i in 0 ..< numberOfRows {
            var temp: [UIImageView] = []
            for _ in 0 ..< CommentThumbnailView.numberOfColumns {
                let ac = UIActivityIndicatorView(activityIndicatorStyle: .gray)
                let iv = UIImageView(frame: CGRect.zero)
                iv.clipsToBounds = true
                iv.image = UIImage(named: "account")
                iv.translatesAutoresizingMaskIntoConstraints = false
                ac.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(iv)
                self.addSubview(ac)
                temp.append(iv)
                
                do {
                    let centerx = NSLayoutConstraint(item: iv, attribute: .centerX, relatedBy: .equal, toItem: ac, attribute: .centerX, multiplier: 1, constant: 0)
                    self.addConstraint(centerx)
                    let centery = NSLayoutConstraint(item: iv, attribute: .centerY, relatedBy: .equal, toItem: ac, attribute: .centerY, multiplier: 1, constant: 0)
                    self.addConstraint(centery)
                    ac.startAnimating()
                    activityIndicators.append(ac)
                }
            }
            for j in 1 ..< CommentThumbnailView.numberOfColumns {
                let con = NSLayoutConstraint(item: temp[j-1], attribute: .width, relatedBy: .equal, toItem: temp[j], attribute: .width, multiplier: 1, constant: 0)
                self.addConstraint(con)
            }
            for j in 1 ..< CommentThumbnailView.numberOfColumns {
                let con = NSLayoutConstraint(item: temp[j], attribute: .left, relatedBy: .equal, toItem: temp[j-1], attribute: .right, multiplier: 1, constant: 2)
                self.addConstraint(con)
            }
            do {
                let con = NSLayoutConstraint(item: temp[0], attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
                self.addConstraint(con)
            }
            do {
                let con = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: temp[CommentThumbnailView.numberOfColumns - 1], attribute: .right, multiplier: 1, constant: 0)
                self.addConstraint(con)
            }
            
            for j in 0 ..< CommentThumbnailView.numberOfColumns {
                let con = NSLayoutConstraint(item: temp[j], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CommentThumbnailView.thumbnailHeight)
                temp[j].addConstraint(con)
                let con2 = NSLayoutConstraint(item: temp[j], attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: CGFloat(i) * 2 + CGFloat(i) * CommentThumbnailView.thumbnailHeight)
                self.addConstraint(con2)
            }
            imageViews.append(contentsOf: temp)
        }
    }
    
    func updateThumbnailInfos(list: [Thumbnail]) {
        thumbnails = list
        numberOfThumbnails = thumbnails.count
        
        viewTupleForURL.removeAll()
        
        imageViews.forEach({
            $0.image = nil
            $0.isHidden = true
        })
        
        activityIndicators.forEach({
            $0.isHidden = true
            $0.stopAnimating()
        })
        
        let count = imageViews.count < thumbnails.count ? imageViews.count : thumbnails.count
        
        for i in 0 ..< count {
            imageViews[i].isHidden = false
            activityIndicators[i].isHidden = false
            activityIndicators[i].startAnimating()
        }
        
        for i in 0 ..< count {
            let url = thumbnails[i]
            let md5 = url.thumbnailURL.absoluteString.md5
            viewTupleForURL[md5] = (imageViews[i], activityIndicators[i])
        }
        
        thumbnails.forEach({
            let url = $0.thumbnailURL
            do {
                try setImage(of: url)
            } catch {
            }
        })
    }
    
    init(numberOfThumbnails: Int) {
        self.numberOfThumbnails = numberOfThumbnails
        self.numberOfRows = numberOfThumbnails / CommentThumbnailView.numberOfColumns + ((numberOfThumbnails % CommentThumbnailView.numberOfColumns > 0) ? 1 : 0)
        super.init(frame: CGRect.zero)
        prepareImageViews()
        NotificationCenter.default.addObserver(self, selector: #selector(CommentThumbnailView.didFinishDownloading(notification:)), name: ImageDownloadableDidFinishDownloadingName, object: nil)
    }

    required init?(coder: NSCoder) {
        self.numberOfThumbnails = 0
        self.numberOfRows = 0
        super.init(coder: coder)
        prepareImageViews()
        NotificationCenter.default.addObserver(self, selector: #selector(CommentThumbnailView.didFinishDownloading(notification:)), name: ImageDownloadableDidFinishDownloadingName, object: nil)
    }
}

// MARK: ImageDownloadable

extension CommentThumbnailView {
    
    func setImage(of url: URL) throws {
        if !existsCachedImage(of: url) { throw ReddiftAPPError.cachedImageFileIsNotFound }
        let urlString = url.absoluteString
        let urlStringMD5 = urlString.md5
        
        if let (imageView, activityIndicator) = self.viewTupleForURL[urlStringMD5] {
            do {
                let image = try self.cachedImageInThumbnail(of: url)
                imageView.contentMode = .scaleAspectFill
                imageView.image = image
                activityIndicator.isHidden = true
                activityIndicator.stopAnimating()
            } catch {
                throw error
            }
        }
    }
    
    func setErrorImage(of url: URL) throws {
        let urlString = url.absoluteString
        let urlStringMD5 = urlString.md5
        if let (imageView, activityIndicator) = self.viewTupleForURL[urlStringMD5] {
            let image = UIImage(named: "error")
            imageView.image = image
            imageView.contentMode = .center
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        } else {
            throw ReddiftAPPError.canNotGetImageViewForSpecifiedImageURL
        }
    }
    
    @objc func didFinishDownloading(notification: NSNotification) {
        if let userInfo = notification.userInfo, let _ = userInfo[ImageDownloadableSenderKey], let url = userInfo[ImageDownloadableUrlKey] as? URL {
            if let _ = thumbnails.index(where: {$0.thumbnailURL == url}) {
                do {
                    if let _ = userInfo[ImageDownloadableErrorKey] as? NSError {
                        try setErrorImage(of: url)
                    } else {
                        try setImage(of: url)
                    }
                } catch {
                }
            }
        }
    }
    
}
