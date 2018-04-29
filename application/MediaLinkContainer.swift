//
//  MediaLinkContainer.swift
//  reddift
//
//  Created by sonson on 2016/10/06.
//  Copyright © 2016年 sonson. All rights reserved.
//

import reddift
import Foundation

let MediaLinkContainerPrefetchAtIndexPathKey = "IndexPath"
let MediaLinkContainerPrefetchContentKey = "Content"
let MediaLinkContainerSingleImageSizeDidUpdate = Notification.Name(rawValue: "MediaLinkContainerSingleImageSizeDidUpdate")

class MediaLinkContainer: LinkContainer {
    
    /// Cell identifier for dequeueReusableCellWithIdentifier of FrontViewController class.
    override var cellIdentifier: String {
        get {
            if isHidden {
                return "InvisibleCell"
            } else {
                return ImageLinkThumbnailView.identifier(numberOfThumbnails: thumbnails.count)
            }
        }
    }
    
    override var thumbnails: [Thumbnail] {
        didSet {
            if thumbnails.count == 1 && MediaLinkCellSingleImageSize {
                let thumbnail = thumbnails[0]
                do {
                    let image = try cachedImageInThumbnail(of: thumbnail.thumbnailURL)
                    singleImageSize = image.size
                } catch {
                }
            }
        }
    }
    var singleImageSize = CGSize.zero
    
    override var height: CGFloat {
        if isHidden {
            return 0
        } else {
            if singleImageSize.height > 0 && thumbnails.count == 1 && MediaLinkCellSingleImageSize {
                let ih = width / singleImageSize.width * singleImageSize.height
                return ThumbnailLinkCell.verticalTopMargin + ThumbnailLinkCell.verticalBotttomMargin + ContentInfoView.height + ContentToolbar.height + ih + ceil(titleSize.height)
            } else {
                return MediaLinkCell.estimateHeight(titleHeight: titleSize.height, numberOfThumbnails: thumbnails.count)
            }
        }
    }
    
    func imageHeight(for width: CGFloat) -> CGFloat {
        if singleImageSize.height > 0 && thumbnails.count == 1 && MediaLinkCellSingleImageSize {
            return width / singleImageSize.width * singleImageSize.height
        } else {
            return ImageLinkThumbnailView.estimateHeight(numberOfThumbnails: thumbnails.count)
        }
    }
    
    func download(imageURLs: [URL], sender: AnyObject) {
        imageURLs.forEach({
            let url = $0
            if existsCachedImage(of: url) { return }
            let https_url = url.httpsSchemaURL
            let request = URLRequest(url: https_url)
            let task = sessionForImageDownloadable().dataTask(with: request, completionHandler: { (data, _, error) -> Void in
                do {
                    if let data = data {
                        try self.save(data, of: url)
                        if imageURLs.count == 1 && MediaLinkCellSingleImageSize {
                            DispatchQueue.main.async(execute: { () -> Void in
                                do {
                                    let image = try self.cachedImageInThumbnail(of: url)
                                    self.singleImageSize = image.size
                                    NotificationCenter.default.post(name: MediaLinkContainerSingleImageSizeDidUpdate, object: nil, userInfo: ["obj": self])
                                } catch {
                                    
                                }
                            })
                            self.postNotificationForImageDownload(url: url, sender: sender, error: nil)
                        } else {
                            self.postNotificationForImageDownload(url: url, sender: sender, error: nil)
                        }
                    } else {
                        let error = ReddiftAPPError.canNotAcceptDataFromServer as NSError
                        self.postNotificationForImageDownload(url: url, sender: sender, error: error)
                    }
                } catch {
                    self.postNotificationForImageDownload(url: url, sender: sender, error: error as NSError)
                }
            })
            task.resume()
            
        })
    }
    
    init(link: Link, width: CGFloat, fontSize: CGFloat = 18, thumbnails: [Thumbnail]) {
        super.init(with: link, width: width, fontSize: fontSize)
        self.thumbnails = thumbnails
        let font = UIFont(name: UIFont.systemFont(ofSize: fontSize).fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        attributedTitle = NSAttributedString(string: link.title).reconstruct(with: font, color: UIColor.black, linkColor: UIColor.blue)
        titleSize = ThumbnailLinkCell.estimateTitleSize(attributedString: attributedTitle, withBountWidth: width, margin: .zero)
        pageLoaded = true
    }
    
    /// download thumbnail
    override func downloadImages() {
        download(imageURLs: thumbnails.map({$0.thumbnailURL}), sender: self)
    }
}
