//
//  FrontViewController.swift
//  reddift
//
//  Created by sonson on 2015/09/02.
//  Copyright © 2015年 sonson. All rights reserved.
//

import reddift
import UIKit

class FrontViewController: UITableViewController, UIViewControllerPreviewingDelegate, UITextFieldDelegate, UIViewControllerTransitioningDelegate, ImageViewAnimator {
    @IBOutlet var titleTextField: UITextField?
    var searchController = SearchController(style: .plain)
    var cellar: LinkContainerCellar = LinkContainerCellar()
    @IBOutlet var rightListButton: UIBarButtonItem?
    @IBOutlet var leftAccountButton: UIBarButtonItem?
    var refresh = UIRefreshControl()
    
    var searchControllerViewBottomSpaceConstraint: NSLayoutConstraint?
    
//    func hideThumbnail(thumbnail: Thumbnail?) {
//        let imageIncludingCells = self.tableView.visibleCells.flatMap({$0 as? ImageViewAnimator})
//        if let thumbnail = thumbnail {
//            for i in 0..<imageIncludingCells.count {
//                if let imageView = imageIncludingCells[i].targetImageView(thumbnail: thumbnail) {
//                    imageView.isHidden = true
//                } else {
//                    imageView.isHidden = false
//                }
//            }
//        } else {
//            for i in 0..<imageIncludingCells.count {
//                if let imageView = imageIncludingCells[i].targetImageView(thumbnail: thumbnail) {
//                    imageView.isHidden = true
//                } else {
//                    imageView.isHidden = false
//                }
//            }
//        }
//    }
    
    func targetImageView(thumbnail: Thumbnail) -> UIImageView? {
        let imageIncludingCells = self.tableView.visibleCells.compactMap({$0 as? ImageViewAnimator})
        for i in 0..<imageIncludingCells.count {
            if let imageView = imageIncludingCells[i].targetImageView(thumbnail: thumbnail) {
                return imageView
            }
        }
        return nil
    }
    
    func imageViews() -> [UIImageView] {
        return self.tableView.visibleCells
            .compactMap({$0 as? ImageViewAnimator})
            .flatMap({$0.imageViews()})
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageViewPageDismissAnimator()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageViewPageModalAnimator()
    }
    
    func showBars() {
        //        UIView.animateWithDuration(1,
        //            animations: { () -> Void in
        //                self.navigationController?.navigationBar.alpha = 1
        //                self.navigationController?.toolbar.alpha = 1
        //            }) { (success) -> Void in
        //        }
    }
    
    // MARK: - action
    
    @objc func didChangeThumbnailPage(notification: Notification) {
        if let userInfo = notification.userInfo, let thumbnail = userInfo["thumbnail"] as? Thumbnail {
            if let index = cellar.containers.index(where: { $0.link.id == thumbnail.parentID }) {
                let rect = tableView.rectForRow(at: IndexPath(row: index, section: 0))
                tableView.scrollRectToVisible(rect, animated: false)
                if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ImageViewAnimator {
                    if let imageView = cell.targetImageView(thumbnail: thumbnail) {
                        let rect = tableView.convert(imageView.bounds, from: imageView)
                        tableView.contentOffset = CGPoint(x: 0, y: rect.origin.y - 64)
                    }
                }
            }
            self.imageViews().forEach({$0.isHidden = false})
        }
    }
    
    @objc func didTapActionNotification(notification: Notification) {
        if let userInfo = notification.userInfo, let link = userInfo["link"] as? Link, let contents = userInfo["contents"] as? LinkContainable {
            let controller = UIAlertController(title: link.title, message: link.url, preferredStyle: .actionSheet)
            let shareAction = UIAlertAction(title: "Share", style: .default, handler: { (_) -> Void in
                let sharedURL = URL(string: link.url)!
                let activityController = UIActivityViewController(activityItems: [sharedURL], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            })
            controller.addAction(shareAction)
            let reportAction = UIAlertAction(title: "Report", style: .default, handler: { (_) -> Void in
                contents.report()
            })
            controller.addAction(reportAction)
            let hideAction = UIAlertAction(title: "Hide", style: .destructive, handler: { (_) -> Void in
                contents.hide()
            })
            controller.addAction(hideAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) -> Void in
            })
            controller.addAction(cancelAction)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func didTapCommentNotification(notification: Notification) {
        if let userInfo = notification.userInfo, let link = userInfo["link"] as? Link {
            let commentViewController = CommentViewController(nibName: nil, bundle: nil)
            commentViewController.link = link
            self.navigationController?.pushViewController(commentViewController, animated: true)
        }
    }
    
    @objc func didTapNameNotification(notification: Notification) {
        if let userInfo = notification.userInfo, let name = userInfo["name"] as? String {
            let controller = UserViewController.controller(name)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func didTapTitleNotification(notification: Notification) {
        if let userInfo = notification.userInfo, let link = userInfo["link"] as? Link, let url = URL(string: link.url) {
            let controller = WebViewController(nibName: nil, bundle: nil)
            controller.url = url
            let nav = UINavigationController(rootViewController: controller)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @objc func didTapThumbnailNotification(notification: Notification) {
        if let userInfo = notification.userInfo,
            let _ = userInfo["link"] as? Link,
            let thumbnail = userInfo["thumbnail"] as? Thumbnail,
            let _ = userInfo["view"] as? UIImageView {
            let controller = createImageViewPageControllerWith(cellar.thumbnails, openThumbnail: thumbnail)
            controller.modalPresentationStyle = .custom
            controller.transitioningDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func refreshDidChange(sender: AnyObject) {
        print("refreshDidChange")
        refresh.attributedTitle = NSAttributedString(string: cellar.loadingMessage())
        DispatchQueue.main.async {
            self.cellar.load(atTheBeginning: true)
        }
    }
    
    @objc func closeSearchController(sender: AnyObject) {
        titleTextField?.resignFirstResponder()
        self.navigationController?.isToolbarHidden = false
        self.navigationItem.leftBarButtonItem = self.leftAccountButton
        self.navigationItem.rightBarButtonItem = self.rightListButton
        if searchController.view.superview == self.navigationController?.view {
            searchController.close(sender: self)
            searchControllerViewBottomSpaceConstraint = nil
            searchController.removeFromParentViewController()
        }
    }
    
    @IBAction func compose(sender: AnyObject) {
//        cellar.containers
        if let c = cellar as? SubredditCellar {
            let nav = PostCommentViewController.controller(with: c.subreddit)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @IBAction func openTab(sender: AnyObject) {
//        let rect = self.view.frame
//        
//        self.navigationController?.navigationBar.alpha = 0
//        self.navigationController?.toolbar.alpha = 0
//        self.tableView.showsVerticalScrollIndicator = false
//        UIGraphicsBeginImageContextWithOptions(CGSize(width:rect.size.width, height:rect.size.height), false, 0.0)
//        let context = UIGraphicsGetCurrentContext()
//        context!.translate(x: 0.0, y: 0.0)
//        self.navigationController?.view.layer.render(in: context!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        TabManager.sharedInstance.setScreenshot(image: image!)
//        UIGraphicsEndImageContext()
//        
//        self.navigationController?.navigationBar.alpha = 1
//        self.navigationController?.toolbar.alpha = 1
//        self.tableView.showsVerticalScrollIndicator = true
//        
//        let nav = TabSelectViewController.sharedNavigationController
//        if let vc = nav.topViewController as? TabSelectViewController {
//            vc.startAnimationWhenWillAppearWithSnapshotView(view: self.navigationController!.view.snapshotView(afterScreenUpdates: true)!)
//        }
//        self.present(nav, animated: false, completion: { () -> Void in
//            if let vc = nav.topViewController as? TabSelectViewController {
//                vc.startAnimationWhenDidAppear()
//            }
//        })
    }
    
    // MARK: - Notification
    
    @objc func openSubreddit(notification: NSNotification) {
        if let userInfo = notification.userInfo, let subreddit = userInfo[SearchController.subredditKey] as? String {
            cellar = SubredditCellar(subreddit: subreddit, width: self.view.frame.size.width, fontSize: 18)
            self.tableView.reloadData()
            cellar.load(atTheBeginning: true)
        }
        refresh.attributedTitle = NSAttributedString(string: cellar.tryLoadingMessage())
        closeSearchController(sender: self)
    }
    
    @objc func searchSubreddit(notification: NSNotification) {
        if let userInfo = notification.userInfo, let query = userInfo[SearchController.queryKey] as? String {
            cellar = SearchLinkCellar(query: query, subreddit: nil, width: self.view.frame.size.width, fontSize: 18)  
            self.tableView.reloadData()
            cellar.load(atTheBeginning: true)
        }
        refresh.attributedTitle = NSAttributedString(string: cellar.tryLoadingMessage())
        closeSearchController(sender: self)
    }
    
    @objc func didUpdateSingleImageSize(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let obj = userInfo["obj"] as? MediaLinkContainer {
                print(obj)
                for i in 0..<cellar.containers.count {
                    let b = cellar.containers[i]
                    if b.link.id == obj.link.id {
                        print(i)
                        self.tableView.beginUpdates()
                        self.tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .fade)
                        self.tableView.endUpdates()
                        break
                    }
                }
            }
        }
    }
    
    @objc func didLoadImage(notification: NSNotification) {
        if let userInfo = notification.userInfo, let indexPath = userInfo[MediaLinkContainerPrefetchAtIndexPathKey] as? IndexPath, let container = userInfo[MediaLinkContainerPrefetchContentKey] as? LinkContainable {
            if 0..<self.cellar.containers.count ~= indexPath.row {
                if container === self.cellar.containers[indexPath.row] {
                    self.tableView.beginUpdates()
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                    self.tableView.endUpdates()
                }
            }
        }
    }
    
    @objc func didLoadLinkContainerCellar(notification: NSNotification) {
        if let userInfo = notification.userInfo, let atTheBeginning = userInfo[LinkContainerCellar.isAtTheBeginningKey] as? Bool {
            if atTheBeginning {
                self.tableView.reloadData()
                refresh.endRefreshing()
            }
            refresh.attributedTitle = NSAttributedString(string: cellar.tryLoadingMessage())
        } else if let userInfo = notification.userInfo, let indices = userInfo[LinkContainerCellar.insertIndicesKey] as? [IndexPath], let cellar = userInfo[LinkContainerCellar.providerKey] as? LinkContainerCellar {
            if self.cellar === cellar {
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: indices, with: .none)
                self.tableView.endUpdates()
                refresh.attributedTitle = NSAttributedString(string: cellar.tryLoadingMessage())
            }
        }
    }
    
    @objc func didChangedDraggingThumbnail(notification: Notification) {
        if let userInfo = notification.userInfo, let thumbnail = userInfo["thumbnail"] as? Thumbnail {
            self.imageViews().forEach({$0.isHidden = false})
            self.targetImageView(thumbnail: thumbnail)?.isHidden = true
        }
//        self.navigationController?.navigationBar.alpha = 0
//        self.navigationController?.toolbar.alpha = 0
    }
    
    @objc func didUpdateLinkContainable(notification: Notification) {
        if let userInfo = notification.userInfo, let contents = userInfo["contents"] as? LinkContainable {
            if let index = self.cellar.containers.index(where: {contents.link.id == $0.link.id}) {
                let indices = [IndexPath(row: index, section: 0)]
                self.tableView.beginUpdates()
                self.tableView.reloadRows(at: indices, with: .none)
                self.tableView.endUpdates()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("viewWillTransition")
        self.cellar.layout(with: size.width, fontSize: 18)
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let con = CommentViewController(nibName: nil, bundle: nil)
//        print(con.link)
//        con.link = Link(id: "2zbpqj")
//        self.navigationController?.pushViewController(con, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OpenComment" {
            if let indexPath = self.tableView.indexPathForSelectedRow, let viewController = segue.destination as? CommentViewController {
                let contents = cellar.containers[indexPath.row]
                viewController.link = contents.link
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(FrontViewController.openSubreddit(notification:)), name: SearchControllerDidOpenSubredditName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FrontViewController.searchSubreddit(notification:)), name: SearchControllerDidSearchSubredditName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FrontViewController.openSubreddit(notification:)), name: SubredditSelectTabBarControllerDidOpenSubredditName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FrontViewController.didUpdateSingleImageSize(notification:)), name: MediaLinkContainerSingleImageSizeDidUpdate, object: nil)
        if MediaLinkCellSingleImageSize {
            NotificationCenter.default.addObserver(self, selector: #selector(FrontViewController.didLoadImage(notification:)), name: LinkContainerDidLoadImageName, object: nil)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(FrontViewController.didLoadLinkContainerCellar(notification:)), name: LinkContainerCellarDidLoadName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(FrontViewController.didTapActionNotification(notification:)), name: LinkCellDidTapActionNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FrontViewController.didTapCommentNotification(notification:)), name: LinkCellDidTapCommentNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FrontViewController.didTapNameNotification(notification:)), name: LinkCellDidTapNameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FrontViewController.didTapTitleNotification(notification:)), name: LinkCellDidTapTitleNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FrontViewController.didTapThumbnailNotification(notification:)), name: LinkCellDidTapThumbnailNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FrontViewController.didUpdateLinkContainable(notification:)), name: ThingContainableDidUpdate, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(FrontViewController.didChangeThumbnailPage(notification:)), name: ImageViewPageControllerDidChangePageName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FrontViewController.didChangedDraggingThumbnail(notification:)), name: ImageViewPageControllerDidStartDraggingThumbnailName, object: nil)
        
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        
        tableView.register(LinkCell.self, forCellReuseIdentifier: "LinkCell")
        tableView.register(ThumbnailLinkCell.self, forCellReuseIdentifier: "ThumbnailLinkCell")
        tableView.register(InvisibleCell.self, forCellReuseIdentifier: "InvisibleCell")
        
        refresh.attributedTitle = NSAttributedString(string: "Loading...")
        refresh.addTarget(self, action: #selector(FrontViewController.refreshDidChange(sender:)), for: .valueChanged)
        tableView.addSubview(refresh)
        
//        cellar = SubredditCellar(subreddit: "movies", width: self.view.frame.size.width, fontSize: 18)
        cellar = SubredditCellar(subreddit: "test", width: self.view.frame.size.width, fontSize: 18)
        self.tableView.reloadData()
        cellar.load(atTheBeginning: true)
        
        registerForPreviewing(with: self, sourceView: self.view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(FrontViewController.keyboardWillChangeFrame(notification:)), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FrontViewController.keyboardWillChangeFrame(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - UIViewControllerPreviewingDelegate
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        if viewControllerToCommit is CommentViewController {
            self.navigationController?.pushViewController(viewControllerToCommit, animated: false)
        } else if let controller = viewControllerToCommit as? ImageViewPageController {
            controller.setOffset()
            controller.modalPresentationStyle = .custom
            controller.transitioningDelegate = self
            self.present(viewControllerToCommit, animated: false, completion: nil)
        } else if let controller = viewControllerToCommit as? WebViewController {
            let nav = UINavigationController(rootViewController: controller)
            self.present(nav, animated: false, completion: nil)
        } else {
            self.present(viewControllerToCommit, animated: false, completion: nil)
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let cell = getCellAt(location) as? LinkCell {
            if let (thumbnail, sourceRect, _, _) = cell.thumbnailAt(location, peekView: self.view) {
                previewingContext.sourceRect = sourceRect
                let controller = createImageViewPageControllerWith(cellar.thumbnails, openThumbnail: thumbnail, isOpenedBy3DTouch: true)
                controller.isNavigationBarHidden = true
                return controller
            } else if let (name, sourceRect) = cell.userAt(location, peekView: self.view) {
                previewingContext.sourceRect = sourceRect
                let nav = UserViewController.controller(name)
                return nav
            } else if let (sourceRect, contents) = cell.commentAt(location, peekView: self.view) {
                previewingContext.sourceRect = sourceRect
                let commentViewController = CommentViewController(nibName: nil, bundle: nil)
                commentViewController.link = contents.link
                return commentViewController
            } else if let (url, sourceRect) = cell.urlAt(location, peekView: self.view) {
                previewingContext.sourceRect = sourceRect
                let controller = WebViewController(nibName: nil, bundle: nil)
                controller.url = url
                return controller
            } else {
                if let container = cell.container, let url = URL(string: container.link.url) {
                    let sourceRect = cell.convert(cell.bounds, to: self.view)
                    previewingContext.sourceRect = sourceRect
                    let controller = WebViewController(nibName: nil, bundle: nil)
                    controller.url = url
                    return controller
                }
            }
        }
        return nil
    }
    
    func getCellAt(_ location: CGPoint) -> UITableViewCell? {
        if let view = self.view {
            for cell in tableView.visibleCells {
                if let parent = cell.superview {
                    let p = view.convert(location, to: parent)
                    let r = cell.frame
                    if r.contains(p) {
                        return cell
                    }
                }
            }
        }
        return nil
    }
    
    // MARK: - Table view delegate & data source
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellar.containers[indexPath.row].downloadImages()
        
        if tableView == self.tableView {
            if indexPath.row == (cellar.containers.count - 1) {
                cellar.load(atTheBeginning: false)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellar.containers[indexPath.row].height
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellar.containers.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let container = cellar.containers[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: container.cellIdentifier)
        
        switch (container, cell) {
        case (_, let cell as InvisibleCell):
            return cell
        case (let container as MediaLinkContainer, _):
            // aa
            let cell = MediaLinkCell(numberOfThumbnails: container.thumbnails.count)
            cell.container = container
            return cell
        case (let container, let cell as LinkCell):
            cell.container = container
            return cell
        default:
            return UITableViewCell(style: .default, reuseIdentifier: "Default")
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    @objc func keyboardWillChangeFrame(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let rect = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect {
                print(rect)
                if let searchControllerViewBottomSpaceConstraint = self.searchControllerViewBottomSpaceConstraint {
                    searchControllerViewBottomSpaceConstraint.constant = 667 - rect.origin.y
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        searchController = SearchController(style: .plain)
        
        if let navigationController = self.navigationController {
            
            navigationController.addChildViewController(searchController)
            
            navigationController.view.addSubview(searchController.view)
            
            searchController.view.translatesAutoresizingMaskIntoConstraints = false
            
            let views: [String: UIView] = [
                "v1": searchController.view,
                "v2": self.navigationController!.view
            ]
            
            navigationController.view.addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[v1]-0-|", options: NSLayoutFormatOptions(), metrics: [:], views: views)
            )
            
            navigationController.view.bringSubview(toFront: navigationController.navigationBar)
            let constraint1 = NSLayoutConstraint(item: navigationController.view, attribute: .top, relatedBy: .equal, toItem: searchController.view, attribute: .top, multiplier: 1, constant: -64)
            let constraint2 = NSLayoutConstraint(item: navigationController.view, attribute: .bottom, relatedBy: .equal, toItem: searchController.view, attribute: .bottom, multiplier: 1, constant: 100)
            
            navigationController.view.addConstraint(constraint1)
            navigationController.view.addConstraint(constraint2)
            
            searchControllerViewBottomSpaceConstraint = constraint2
            
            navigationController.isToolbarHidden = true
            
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(FrontViewController.closeSearchController(sender:)))
            
            searchController.view.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                self.searchController.view.alpha = 1
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(textField.text!)
        if let t = textField.text {
            let query = t + string
            searchController.didChangeQuery(text: query)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if let t = textField.text {
//        }
        return false
    }
    
    // MARK: - LinkContainerCellar

    func didLoadContents(controller: LinkContainerCellar, indexPaths: [NSIndexPath]) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: indexPaths.map { $0 as IndexPath}, with: .none)
            self.tableView.endUpdates()
        })
    }
    
    func didFailLoadContents(controller: LinkContainerCellar, error: NSError) {
        if error.code == 401 {
            DispatchQueue.main.async(execute: { () -> Void in
                // authentication expired?
                let alert = UIAlertController(title: "Error", message: "Authentication failed. Do you want to try again?", preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "Try", style: .default, handler: { (_) -> Void in
                    // reload
                })
                alert.addAction(actionOK)
                let actionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alert.addAction(actionCancel)
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
}
