//
//  ImgurLinkContainer.swift
//  reddift
//
//  Created by sonson on 2016/10/06.
//  Copyright © 2016年 sonson. All rights reserved.
//

import reddift
import Foundation

class ImgurLinkContainer: MediaLinkContainer {

    /// Shared session configuration
    var sessionConfiguration: URLSessionConfiguration {
        get {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            configuration.timeoutIntervalForResource = 30
            return configuration
        }
    }
    
    override init(link: Link, width: CGFloat, fontSize: CGFloat = 18, thumbnails: [Thumbnail]) {
        super.init(link: link, width: width, fontSize: fontSize, thumbnails: [])
        self.thumbnails = thumbnails
        let font = UIFont(name: UIFont.systemFont(ofSize: fontSize).fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        attributedTitle = NSAttributedString(string: link.title).reconstruct(with: font, color: UIColor.black, linkColor: UIColor.blue)
        titleSize = ThumbnailLinkCell.estimateTitleSize(attributedString: attributedTitle, withBountWidth: width, margin: .zero)
        pageLoaded = false
    }
    
    override func prefetch(at: IndexPath) {
        if pageLoaded { return }
        guard let url = URL(string: link.url) else { return }
        let https_url = url.httpsSchemaURL
        var request = URLRequest(url: https_url)
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.1.56 (KHTML, like Gecko) Version/9.0 Safari/601.1.56", forHTTPHeaderField: "User-Agent")
        let session: URLSession = URLSession(configuration: sessionConfiguration)
        let task = session.dataTask(with: request, completionHandler: { (data, _, error) -> Void in
            self.pageLoaded = true
            if let error = error {
                NotificationCenter.default.post(name: LinkContainerDidLoadImageName, object: nil, userInfo: ["error": error as NSError])
            }
            if let data = data, let decoded = String(data: data, encoding: .utf8) {
                if !decoded.is404OfImgurcom {
                    self.thumbnails = decoded.extractImgurImageURL(parentID: self.link.id)
                    DispatchQueue.main.async(execute: { () -> Void in
                        NotificationCenter.default.post(name: LinkContainerDidLoadImageName, object: nil, userInfo: [MediaLinkContainerPrefetchAtIndexPathKey: at, MediaLinkContainerPrefetchContentKey: self])
                    })
                }
            } else {
                NotificationCenter.default.post(name: LinkContainerDidLoadImageName, object: nil, userInfo: ["error": "can not decode html"])
            }
        })
        task.resume()
    }
}
