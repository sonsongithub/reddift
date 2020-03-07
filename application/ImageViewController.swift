//
//  ImageViewController.swift
//  UZImageCollectionView
//
//  Created by sonson on 2015/06/05.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit
import FLAnimatedImage

let ImageViewControllerDidChangeCurrentImageName = Notification.Name(rawValue: "ImageViewControllerDidChangeCurrentImage")

class ImageViewController: UIViewController, Page, ImageDownloadable, ImageViewDestination {
    var thumbnails: [Thumbnail] = []
    let index: Int
    let scrollView = UIScrollView(frame: CGRect.zero)
    let mainImageView = FLAnimatedImageView(frame: CGRect.zero)
    var indicator = UIActivityIndicatorView(style: .gray)
    
    var maximumZoomScale: CGFloat = 0
    var minimumZoomScale: CGFloat = 0
    var imageURL = URL(string: "https://api.sonson.jp")!
    var task: URLSessionDataTask?
    var isOpenedBy3DTouch = false
    
    private var _alphaWithoutMainContent: CGFloat = 1
    
    var initialiContentOffsetY = CGFloat(0)
    
    var alphaWithoutMainContent: CGFloat {
        get {
            return _alphaWithoutMainContent
        }
        set {
            _alphaWithoutMainContent = newValue
            scrollView.backgroundColor = scrollView.backgroundColor?.withAlphaComponent(_alphaWithoutMainContent)
            view.backgroundColor = view.backgroundColor?.withAlphaComponent(_alphaWithoutMainContent)
        }
    }
    
    func thumbnailImageView() -> UIImageView {
        return mainImageView
    }
    
    deinit {
        print("deinit ImageViewController")
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.index = 0
//        self.imageCollectionViewController = ImageCollectionViewController(collection: ImageCollection(newList: []))
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        view.backgroundColor = UIColor.white
        scrollView.backgroundColor = UIColor.white
        scrollView.alwaysBounceVertical = true
        let rec = UITapGestureRecognizer(target: self, action: #selector(ImageViewController.didTapGesture(recognizer:)))
        self.scrollView.addGestureRecognizer(rec)
    }
    
    @objc func didTapGesture(recognizer: UITapGestureRecognizer) {
        if let imageViewPageController = self.parentImageViewPageController {
            imageViewPageController.navigationBar.isHidden = !imageViewPageController.navigationBar.isHidden
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear")
        super.viewDidDisappear(animated)
    }
    
    func toggleDarkMode(isDark: Bool) {
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.scrollView.backgroundColor = isDark ? UIColor.black : UIColor.white
            }, completion: { (_) -> Void in
        })
    }

    init(index: Int, thumbnails: [Thumbnail], isOpenedBy3DTouch: Bool = false) {
        self.index = index
        scrollView.addSubview(mainImageView)
        super.init(nibName: nil, bundle: nil)
        self.thumbnails = thumbnails
        self.imageURL = thumbnails[index].thumbnailURL
        self.isOpenedBy3DTouch = isOpenedBy3DTouch
        NotificationCenter.default.addObserver(self, selector: #selector(ImageViewController.didFinishDownloading(notification:)), name: ImageDownloadableDidFinishDownloadingName, object: nil)
        download(imageURLs: [self.imageURL], sender: self)
    }
    
    class func controllerWithIndex(index: Int, isDark: Bool, thumbnails: [Thumbnail]) -> ImageViewController {
        let con = ImageViewController(index: index, thumbnails: thumbnails)
        return con
    }
}

extension ImageViewController {
    func setupScrollViewScale(imageSize: CGSize) {
        scrollView.frame = self.view.bounds
        
        let boundsSize = self.view.bounds
        
        // calculate min/max zoomscale
        let xScale = boundsSize.width  / imageSize.width;    // the scale needed to perfectly fit the image width-wise
        let yScale = boundsSize.height / imageSize.height;   // the scale needed to perfectly fit the image height-wise
        
        // fill width if the image and phone are both portrait or both landscape; otherwise take smaller scale
        let imagePortrait = imageSize.height > imageSize.width
        let phonePortrait = boundsSize.height > imageSize.width
        var minScale = imagePortrait == phonePortrait ? xScale : (xScale < yScale ? xScale : yScale)
        
        // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
        // maximum zoom scale to 0.5.
        let maxScale = 10.0 / UIScreen.main.scale
        
        // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
        if minScale > maxScale {
            minScale = maxScale
        }
        
        scrollView.maximumZoomScale = maxScale
        scrollView.minimumZoomScale = minScale
        
        scrollView.contentSize = mainImageView.image!.size
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
    
    func updateImageCenter() {
        let boundsSize = self.view.bounds
        var frameToCenter = mainImageView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        mainImageView.frame = frameToCenter
    }
    
    func setIndicator() {
        self.view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0))
    }
    
    func setScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bouncesZoom = true
        scrollView.decelerationRate = UIScrollView.DecelerationRate.fast
        scrollView.delegate = self
        scrollView.isMultipleTouchEnabled = true
        
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[scrollView]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: [:], views: ["scrollView": scrollView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[scrollView]-1-|", options: NSLayoutConstraint.FormatOptions(), metrics: [:], views: ["scrollView": scrollView]))
    }
    
    func setupSubviews() {
        self.view.isMultipleTouchEnabled = true
        self.navigationController?.view.isMultipleTouchEnabled = true
        setScrollView()
        setIndicator()
        indicator.startAnimating()
        indicator.isHidden = false
        setImage(of: self.imageURL)
    }
    
    func close() {
        if let imageViewPageController = parentImageViewPageController {
            imageViewPageController.close(sender: self)
        }
    }
    
    var parentImageViewPageController: ImageViewPageController? {
        if let vc1 = self.parent as? ImageViewPageController {
            return vc1
        }
        return nil
    }
}

// MARK: UIScrollViewDelegate

extension ImageViewController: UIScrollViewDelegate {
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("scrollViewDidZoom")
        let ratio = scrollView.zoomScale / scrollView.minimumZoomScale
        
        let threshold = CGFloat(0.6)
        var alpha = CGFloat(1)
        print(ratio)
        if ratio > 1 {
            alpha = 1
        } else if ratio > threshold {
//            alpha = (ratio - threshold / 2) * (ratio - threshold / 2) + 1 - (1 - threshold / 2) * (1 - threshold / 2)
            alpha = (ratio - 1) * (ratio - 1) * (-1) / ((threshold - 1) * (threshold - 1)) + 1
        } else {
            alpha = 0
        }
        print(alpha)
        parentImageViewPageController?.alphaWithoutMainContent = alpha
        
        self.updateImageCenter()
        if ratio < threshold {
            close()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll")
        if scrollView.contentOffset.y < initialiContentOffsetY {
            let threshold = CGFloat(-150)
            let s = CGFloat(-50)
            let x = scrollView.contentOffset.y - initialiContentOffsetY
            if x < s {
                let param = (x - s) * (x - s) * (-1) / ((threshold - s) * (threshold - s)) + 1
                parentImageViewPageController?.alphaWithoutMainContent = param
            } else {
                parentImageViewPageController?.alphaWithoutMainContent = 1
            }
            if x < threshold {
                close()
            }
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDecelerating")
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("scrollViewDidEndScrollingAnimation")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("scrollViewDidEndZooming")
        self.updateImageCenter()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        let userInfo: [String: Any] = ["index": self.index, "thumbnail": self.thumbnails[self.index]]
        NotificationCenter.default.post(name: ImageViewPageControllerDidChangePageName, object: nil, userInfo: userInfo)
        NotificationCenter.default.post(name: ImageViewPageControllerDidStartDraggingThumbnailName, object: nil, userInfo: ["thumbnail": thumbnails[index]])
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        print("scrollViewWillBeginZooming")
        let userInfo: [String: Any] = ["index": self.index, "thumbnail": self.thumbnails[self.index]]
        NotificationCenter.default.post(name: ImageViewPageControllerDidChangePageName, object: nil, userInfo: userInfo)
        NotificationCenter.default.post(name: ImageViewPageControllerDidStartDraggingThumbnailName, object: nil, userInfo: ["thumbnail": thumbnails[index]])
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("viewForZooming")
        return mainImageView
    }
}

// MARK: ImageDownloadable

extension ImageViewController {

    func setImage(of url: URL) {
        do {
            let data = try cachedDataInCache(of: url)
            guard let animatedImage: FLAnimatedImage = FLAnimatedImage(animatedGIFData: data) else {
                if let image = UIImage(data: data as Data) {
                    mainImageView.isHidden = false
                    mainImageView.image = image
                    mainImageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: image.size)
                    setupScrollViewScale(imageSize: image.size)
                    updateImageCenter()
                    initialiContentOffsetY = scrollView.contentOffset.y
                    indicator.stopAnimating()
                    indicator.isHidden = true
                } else {
                    indicator.startAnimating()
                    indicator.isHidden = false
                }
                return
            }
            
            mainImageView.animatedImage = animatedImage
            mainImageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: animatedImage.size)
            setupScrollViewScale(imageSize: animatedImage.size)
            updateImageCenter()
            initialiContentOffsetY = scrollView.contentOffset.y
            indicator.stopAnimating()
            indicator.isHidden = true
        } catch {
            print(error)
        }
    }
    
    @objc func didFinishDownloading(notification: NSNotification) {
        if let userInfo = notification.userInfo, let obj = userInfo[ImageDownloadableSenderKey] as? ImageViewController, let url = userInfo[ImageDownloadableUrlKey] as? URL {
            if obj == self {
                if let _  = userInfo[ImageDownloadableErrorKey] as? NSError {
                    mainImageView.isHidden = false
                    mainImageView.image = UIImage(named: "error")
                    mainImageView.frame = self.view.bounds
                    updateImageCenter()
                    mainImageView.contentMode = .center
                    mainImageView.isUserInteractionEnabled = false
                    indicator.stopAnimating()
                    indicator.isHidden = true
                } else {
                    setImage(of: url)
                }
            }
        }
    }
}
