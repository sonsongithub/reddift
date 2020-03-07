//
//  ImageLinkThumbnailView.swift
//  reddift
//
//  Created by sonson on 2016/03/26.
//  Copyright © 2016年 sonson. All rights reserved.
//

import UIKit

class ImageLinkThumbnailView: UIView, ImageDownloadable {
    static let thumbnailHeight = CGFloat(160)
    static let verticalMargin = CGFloat(1)
    static let playButtonIconWidth = CGFloat(40)
    static let playButtonIconHeight = CGFloat(40)
    
    var imageViews: [UIImageView] = []
    var activityIndicators: [UIActivityIndicatorView] = []
    var playIconImageViews: [UIImageView] = []
    var viewTupleForURL: [String: (UIImageView, UIActivityIndicatorView)] = [:]
    
    let overCountLabel: UILabel = UILabel(frame: CGRect.zero)
    let numberOfThumbnails: Int
        
    var height: CGFloat {
        get {
            return ImageLinkThumbnailView.estimateHeight(numberOfThumbnails: numberOfThumbnails)
        }
    }
    
    var thumbnails: [Thumbnail] = [] {
        didSet {
            viewTupleForURL.removeAll()
            
            let count = thumbnails.count <= 5 ? thumbnails.count : 5
            
            if imageViews.count != count { return }
            
            imageViews.forEach({
                $0.image = nil
                $0.isHidden = true
            })
            
            activityIndicators.forEach({
                $0.isHidden = true
                $0.stopAnimating()
            })
            
            for i in 0 ..< count {
                imageViews[i].isHidden = false
                activityIndicators[i].isHidden = false
                activityIndicators[i].startAnimating()
                
                let md5 = thumbnails[i].thumbnailURL.absoluteString.md5
                
                viewTupleForURL[md5] = (imageViews[i], activityIndicators[i])
                
                switch thumbnails[i] {
                case .Image:
                    playIconImageViews[i].isHidden = true
                case .Movie:
                    playIconImageViews[i].isHidden = false
                }
            }
            
            thumbnails.forEach({
                let url = $0.thumbnailURL
                do {
                    try setImage(of: url)
                } catch {
                }
            })
        }
    }
    
    // MARK: - class method
    
    static func estimateHeight(numberOfThumbnails: Int) -> CGFloat {
        if numberOfThumbnails == 0 {
            return 0
        } else if numberOfThumbnails <= 3 {
            return ImageLinkThumbnailView.thumbnailHeight
        } else {
            return ImageLinkThumbnailView.thumbnailHeight * 2 + ImageLinkThumbnailView.verticalMargin
        }
    }
    
    static func identifier(numberOfThumbnails: Int) -> String {
        return numberOfThumbnails < 5 ? "MediaLinkCell_\(numberOfThumbnails)" : "MediaLinkCell_5"
    }
    
    func setImageCountLabel() {
        if numberOfThumbnails > 5 {
            overCountLabel.text = "\(numberOfThumbnails) images"
            overCountLabel.textAlignment = .center
            overCountLabel.textColor = UIColor.white
            overCountLabel.translatesAutoresizingMaskIntoConstraints = false
            overCountLabel.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
            self.addSubview(overCountLabel)
            
            let con1 = NSLayoutConstraint(item: imageViews[4], attribute: .top, relatedBy: .equal, toItem: overCountLabel, attribute: .top, multiplier: 1, constant: 0)
            self.addConstraint(con1)
            let con2 = NSLayoutConstraint(item: imageViews[4], attribute: .bottom, relatedBy: .equal, toItem: overCountLabel, attribute: .bottom, multiplier: 1, constant: 0)
            self.addConstraint(con2)
            let con3 = NSLayoutConstraint(item: imageViews[4], attribute: .left, relatedBy: .equal, toItem: overCountLabel, attribute: .left, multiplier: 1, constant: 0)
            self.addConstraint(con3)
            let con4 = NSLayoutConstraint(item: imageViews[4], attribute: .right, relatedBy: .equal, toItem: overCountLabel, attribute: .right, multiplier: 1, constant: 0)
            self.addConstraint(con4)
        } else {
            overCountLabel.isHidden = true
        }
    }
    
    func prepareSubviews() {
        let c = numberOfThumbnails < 5 ? numberOfThumbnails : 5
        for _ in 0 ..< c {
            let iv = UIImageView(frame: CGRect.zero)
            let ac = UIActivityIndicatorView(style: .gray)
            let icon = UIImageView(frame: CGRect.zero)
            
            iv.translatesAutoresizingMaskIntoConstraints = false
            ac.translatesAutoresizingMaskIntoConstraints = false
            icon.translatesAutoresizingMaskIntoConstraints = false
            
            imageViews.append(iv)
            activityIndicators.append(ac)
            playIconImageViews.append(icon)
            
            iv.clipsToBounds = true
            iv.image = UIImage(named: "sample")
            iv.contentMode = .scaleAspectFill
            icon.image = UIImage(named: "playButton")
            
            self.addSubview(iv)
            self.addSubview(ac)
            self.addSubview(icon)
            
            do {
                let centerx = NSLayoutConstraint(item: iv, attribute: .centerX, relatedBy: .equal, toItem: ac, attribute: .centerX, multiplier: 1, constant: 0)
                self.addConstraint(centerx)
                let centery = NSLayoutConstraint(item: iv, attribute: .centerY, relatedBy: .equal, toItem: ac, attribute: .centerY, multiplier: 1, constant: 0)
                self.addConstraint(centery)
                ac.startAnimating()
            }
            do {
                let widthConstraint = NSLayoutConstraint(item: icon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: ImageLinkThumbnailView.playButtonIconWidth)
                icon.addConstraint(widthConstraint)
                let heightConstraint = NSLayoutConstraint(item: icon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: ImageLinkThumbnailView.playButtonIconHeight)
                icon.addConstraint(heightConstraint)
                let centerx = NSLayoutConstraint(item: iv, attribute: .centerX, relatedBy: .equal, toItem: icon, attribute: .centerX, multiplier: 1, constant: 0)
                self.addConstraint(centerx)
                let centery = NSLayoutConstraint(item: iv, attribute: .centerY, relatedBy: .equal, toItem: icon, attribute: .centerY, multiplier: 1, constant: 0)
                self.addConstraint(centery)
            }
        }
        
        if numberOfThumbnails == 0 {
        } else if numberOfThumbnails == 1 {
            setAutolayoutWhenImageView_1()
        } else if numberOfThumbnails == 2 {
            setAutolayoutWhenImageView_2()
        } else if numberOfThumbnails == 3 {
            setAutolayoutWhenImageView_3()
        } else if numberOfThumbnails == 4 {
            setAutolayoutWhenImageView_4()
        } else {
            setAutolayoutWhenImageView_5()
        }
        setImageCountLabel()
    }
    
    // MARK: - Override
    
    init(numberOfThumbnails: Int) {
        self.numberOfThumbnails = numberOfThumbnails
        super.init(frame: CGRect.zero)
        prepareSubviews()
        NotificationCenter.default.addObserver(self, selector: #selector(ImageLinkThumbnailView.didFinishDownloading(notification:)), name: ImageDownloadableDidFinishDownloadingName, object: nil)
    }
    
    required init?(coder: NSCoder) {
        self.numberOfThumbnails = 1
        super.init(coder: coder)
        prepareSubviews()
        NotificationCenter.default.addObserver(self, selector: #selector(ImageLinkThumbnailView.didFinishDownloading(notification:)), name: ImageDownloadableDidFinishDownloadingName, object: nil)
    }

    // MARK: - ImageDownloadable

    func setImage(of url: URL) throws {
        if !existsCachedImage(of: url) { throw ReddiftAPPError.cachedImageFileIsNotFound }
        let urlString = url.absoluteString
        let urlStringMD5 = urlString.md5
        
        if let (imageView, activityIndicator) = self.viewTupleForURL[urlStringMD5] {
            do {
                let image = try self.cachedImageInCache(of: url)
                imageView.image = image
                activityIndicator.isHidden = true
                activityIndicator.stopAnimating()
            } catch {
                throw error
            }
        } else {
            throw ReddiftAPPError.canNotGetImageViewForSpecifiedImageURL
        }
    }
    
    func setErrorImage(of url: URL) throws {
        let urlString = url.absoluteString
        let urlStringMD5 = urlString.md5
        if let (imageView, activityIndicator) = self.viewTupleForURL[urlStringMD5] {
            let image = UIImage(named: "error")
            imageView.image = image
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        } else {
            throw ReddiftAPPError.canNotGetImageViewForSpecifiedImageURL
        }
    }
    
    @objc func didFinishDownloading(notification: NSNotification) {
        if let userInfo = notification.userInfo, let _ = userInfo[ImageDownloadableSenderKey] {
            if let _ = userInfo[ImageDownloadableErrorKey] as? NSError, let url = userInfo[ImageDownloadableUrlKey] as? URL {
                do {
                    try setErrorImage(of: url)
                } catch {
                    print(error)
                }
            } else if let url = userInfo[ImageDownloadableUrlKey] as? URL {
                do {
                    try setImage(of: url)
                } catch {
                    print(error)
                }
            }
        }
    }

    // MARK: - Autolayout

    func setAutolayoutWhenImageView_1() {
        let metrics = [
            "margin": ImageLinkThumbnailView.verticalMargin
        ]
        let views = [
            "v1": imageViews[0]
        ]
        self.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v1]-0-|",
                                           options: NSLayoutConstraint.FormatOptions(),
                                           metrics: metrics,
                                           views: views)
        )
        self.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[v1]-0-|",
                                           options: NSLayoutConstraint.FormatOptions(),
                                           metrics: metrics,
                                           views: views)
        )
        if MediaLinkCellSingleImageSize {
            imageViews[0].contentMode = .scaleAspectFit
        }
    }
    
    func setAutolayoutWhenImageView_2() {
        let metrics = [
            "margin": ImageLinkThumbnailView.verticalMargin
        ]
        let views = [
            "v1": imageViews[0],
            "v2": imageViews[1]
        ]
        
        for j in 1 ..< numberOfThumbnails {
            let con = NSLayoutConstraint(item: imageViews[j-1], attribute: .width, relatedBy: .equal, toItem: imageViews[j], attribute: .width, multiplier: 1, constant: 0)
            self.addConstraint(con)
        }
        self.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v1]-0-[v2]-0-|",
                                           options: NSLayoutConstraint.FormatOptions(),
                                           metrics: metrics,
                                           views: views)
        )
        for imageView in imageViews {
            let con1 = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
            self.addConstraint(con1)
            let con2 = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            self.addConstraint(con2)
        }
    }
    
    func setAutolayoutWhenImageView_3() {
        let metrics = [
            "margin": ImageLinkThumbnailView.verticalMargin
        ]
        let views = [
            "v1": imageViews[0],
            "v2": imageViews[1],
            "v3": imageViews[2]
        ]
        
        for j in 1 ..< numberOfThumbnails {
            let con = NSLayoutConstraint(item: imageViews[j-1], attribute: .width, relatedBy: .equal, toItem: imageViews[j], attribute: .width, multiplier: 1, constant: 0)
            self.addConstraint(con)
        }
        
        self.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v1]-margin-[v2]-margin-[v3]-0-|",
                                           options: NSLayoutConstraint.FormatOptions(),
                                           metrics: metrics,
                                           views: views)
        )
        for imageView in imageViews {
            let con1 = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
            self.addConstraint(con1)
            let con2 = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            self.addConstraint(con2)
        }
    }
    
    func setAutolayoutWhenImageView_4() {
        let metrics = [
            "margin": ImageLinkThumbnailView.verticalMargin
        ]
        let views = [
            "v1": imageViews[0],
            "v2": imageViews[1],
            "v3": imageViews[2],
            "v4": imageViews[3]
        ]
        
        for j in 1 ..< numberOfThumbnails {
            let con = NSLayoutConstraint(item: imageViews[j-1], attribute: .width, relatedBy: .equal, toItem: imageViews[j], attribute: .width, multiplier: 1, constant: 0)
            self.addConstraint(con)
        }
        
        self.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v1]-margin-[v2]-0-|",
                                           options: NSLayoutConstraint.FormatOptions(),
                                           metrics: metrics,
                                           views: views)
        )
        self.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v3]-margin-[v4]-0-|",
                                           options: NSLayoutConstraint.FormatOptions(),
                                           metrics: metrics,
                                           views: views)
        )
        
        [imageViews[0], imageViews[1]].forEach({
            let con = NSLayoutConstraint(item: $0, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
            self.addConstraint(con)
        })
        [imageViews[2], imageViews[3]].forEach({
            let con = NSLayoutConstraint(item: $0, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            self.addConstraint(con)
        })
        
        for imageView in imageViews {
            let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: ImageLinkThumbnailView.thumbnailHeight)
            imageView.addConstraint(heightConstraint)
        }
    }
    
    func setAutolayoutWhenImageView_5() {
        let metrics = [
            "margin": ImageLinkThumbnailView.verticalMargin
        ]
        let views = [
            "v1": imageViews[0],
            "v2": imageViews[1],
            "v3": imageViews[2],
            "v4": imageViews[3],
            "v5": imageViews[4]
        ]
        
        for j in 1 ..< 2 {
            let con = NSLayoutConstraint(item: imageViews[j-1], attribute: .width, relatedBy: .equal, toItem: imageViews[j], attribute: .width, multiplier: 1, constant: 0)
            self.addConstraint(con)
        }
        for j in 3 ..< 5 {
            let con = NSLayoutConstraint(item: imageViews[j-1], attribute: .width, relatedBy: .equal, toItem: imageViews[j], attribute: .width, multiplier: 1, constant: 0)
            self.addConstraint(con)
        }
        
        self.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v1]-margin-[v2]-0-|",
                                           options: NSLayoutConstraint.FormatOptions(),
                                           metrics: metrics,
                                           views: views)
        )
        self.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v3]-margin-[v4]-margin-[v5]-0-|",
                                           options: NSLayoutConstraint.FormatOptions(),
                                           metrics: metrics,
                                           views: views)
        )
        
        [imageViews[0], imageViews[1]].forEach({
            let con = NSLayoutConstraint(item: $0, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
            self.addConstraint(con)
        })
        [imageViews[2], imageViews[3], imageViews[4]].forEach({
            let con = NSLayoutConstraint(item: $0, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            self.addConstraint(con)
        })
        
        for imageView in imageViews {
            let heightConstraint = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: ImageLinkThumbnailView.thumbnailHeight)
            imageView.addConstraint(heightConstraint)
        }
    }
}
