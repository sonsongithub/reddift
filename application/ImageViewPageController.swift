//
//  ImageViewPageController.swift
//  UZImageCollection
//
//  Created by sonson on 2015/06/08.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

protocol Page {
    var index: Int { get }
    var isOpenedBy3DTouch: Bool { get set }
    var alphaWithoutMainContent: CGFloat { get set }
}

let ImageViewPageControllerDidChangePageName = Notification.Name(rawValue: "ImageViewPageControllerDidChangePageName")
let ImageViewPageControllerDidStartDraggingThumbnailName = Notification.Name(rawValue: "ImageViewPageControllerDidStartDraggingThumbnailName")

class ImageViewPageController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIGestureRecognizerDelegate {
    var thumbnails: [Thumbnail] = []
    var currentIndex = 0
    var imageViewController: ImageViewDestination?
    let navigationBar = UINavigationBar(frame: CGRect.zero)
    let item: UINavigationItem = UINavigationItem(title: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        view.backgroundColor = UIColor.white
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(navigationBar)
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[navigationBar]-0-|", options: NSLayoutFormatOptions(), metrics: [:], views: ["navigationBar": navigationBar]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[navigationBar(==64)]", options: NSLayoutFormatOptions(), metrics: [:], views: ["navigationBar": navigationBar]))
        navigationBar.pushItem(item, animated: false)
        navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ImageViewPageController.close(sender:)))
        isNavigationBarHidden = true
    }
    
    var _alphaWithoutMainContent: CGFloat = 1
    
    var alphaWithoutMainContent: CGFloat {
        get {
            return _alphaWithoutMainContent
        }
        set {
            navigationBar.alpha = newValue
            _alphaWithoutMainContent = newValue
            view.backgroundColor = view.backgroundColor?.withAlphaComponent(_alphaWithoutMainContent)
            guard var pages = self.viewControllers?.compactMap({ $0 as? Page}) else { return }
            for i in 0..<pages.count {
                pages[i].alphaWithoutMainContent = _alphaWithoutMainContent
            }
        }
    }
    
    func setOffset() {
        let offset = CGFloat(0)
        if let controllers = self.viewControllers {
            for item in controllers {
                if let controller = item as? ImageViewController {
                    controller.scrollView.contentInset = UIEdgeInsets(top: offset, left: 0, bottom: 0, right: 0)
                }
            }
        }
    }
    
    var isNavigationBarHidden: Bool = false {
        didSet {
            navigationBar.isHidden = isNavigationBarHidden
            let offset = isNavigationBarHidden ? CGFloat(-44) : CGFloat(0)
            if let controllers = self.viewControllers {
                for item in controllers {
                    if let controller = item as? ImageViewController {
                        controller.scrollView.contentInset = UIEdgeInsets(top: offset, left: 0, bottom: 0, right: 0)
                    }
                }
            }
        }
    }
    
    @objc func close(sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    init(thumbnails: [Thumbnail], index: Int) {
        self.thumbnails = thumbnails
        self.currentIndex = index
        super.init(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey: 12])
        self.dataSource = self
        self.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(ImageViewPageController.didMoveCurrentImage(notification:)), name: ImageViewControllerDidChangeCurrentImageName, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NotificationCenter.default.addObserver(self, selector: #selector(ImageViewPageController.didMoveCurrentImage(notification:)), name: ImageViewControllerDidChangeCurrentImageName, object: nil)
    }
    
    class func controller(thumbnails: [Thumbnail], index: Int, isOpenedBy3DTouch: Bool) -> ImageViewPageController {
        let vc = ImageViewPageController(thumbnails: thumbnails, index: index)
        
        var con: UIViewController? = nil
        
        switch thumbnails[index] {
        case .Image:
            con = ImageViewController(index: index, thumbnails: thumbnails, isOpenedBy3DTouch: isOpenedBy3DTouch)
        case .Movie:
            con = MoviePlayerController(index: index, thumbnails: thumbnails, isOpenedBy3DTouch: isOpenedBy3DTouch)
        }
        
        if let destination = con as? ImageViewDestination {
            vc.imageViewController = destination
        }
        
        vc.currentIndex = index
        
        vc.setTitle(string: thumbnails[index].url.absoluteString)
        
        if let con = con {
            vc.setViewControllers([con], direction: .forward, animated: false, completion: { (_) -> Void in })
        }
        return vc
    }

    func setTitle(string: String) {
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
        let label = UILabel(frame: rect)
        label.text = string
        label.numberOfLines = 3
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        item.titleView = label
    }
    
    @objc func didMoveCurrentImage(notification: NSNotification) {
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let controller = pageViewController.viewControllers?.last as? ImageViewDestination {
            self.imageViewController = controller
        }
        if let viewController = pageViewController.viewControllers?.last as? Page {
            let index = viewController.index
            currentIndex = index
            setTitle(string: thumbnails[index].url.absoluteString)
            let userInfo: [String: Any] = ["index": index, "thumbnail": thumbnails[index]]
            NotificationCenter.default.post(name: ImageViewPageControllerDidChangePageName, object: nil, userInfo: userInfo)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? Page {
            let index = viewController.index + 1
            if thumbnails.count <= index {
                return nil
            }
            
            switch self.thumbnails[index] {
            case .Image:
                return ImageViewController(index: index, thumbnails: self.thumbnails)
            case .Movie:
                return MoviePlayerController(index: index, thumbnails: self.thumbnails)
            }
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? Page {
            let index = viewController.index - 1
            if index < 0 {
                return nil
            }
            switch self.thumbnails[index] {
            case .Image:
                return ImageViewController(index: index, thumbnails: self.thumbnails)
            case .Movie:
                return MoviePlayerController(index: index, thumbnails: self.thumbnails)
            }
        }
        return nil
    }
}
