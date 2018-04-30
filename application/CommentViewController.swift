//
//  CommentViewController.swift
//  reddift
//
//  Created by sonson on 2015/09/22.
//  Copyright © 2015年 sonson. All rights reserved.
//

import reddift
import UIKit

class CommentViewController: UITableViewController, UIViewControllerPreviewingDelegate, UZTextViewDelegate, UIViewControllerTransitioningDelegate, ImageViewAnimator {
    var link: Link?
    var previewingView: UIView?
    
    var cellar: CommentContainerCellar = CommentContainerCellar(link: nil)
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageViewPageDismissAnimator()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ImageViewPageModalAnimator()
    }
    
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
    
    // MARK: - Notification
    
    @objc func didChangeThumbnailPage(notification: Notification) {
        if let userInfo = notification.userInfo, let thumbnail = userInfo["thumbnail"] as? Thumbnail {
            if let index = cellar.containers.index(where: { $0.thing.id == thumbnail.parentID }) {
                let rect = tableView.rectForRow(at: IndexPath(row: index, section: 0))
                tableView.scrollRectToVisible(rect, animated: false)
                if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ImageViewAnimator {
                    if let imageView = cell.targetImageView(thumbnail: thumbnail) {
                        let rect = tableView.convert(imageView.bounds, from: imageView)
                        tableView.contentOffset = CGPoint(x: 0, y: rect.origin.y - 64)
                    }
                }
            }
        }
    }
    
    @objc func didUpdateCommentContainer(notification: Notification) {
        if let userInfo = notification.userInfo, let commentContainer = userInfo["contents"] as? CommentContainer {
            if let index = self.cellar.containers.index(where: {commentContainer.thing.id == $0.thing.id}) {
                let indices = [IndexPath(row: index, section: 0)]
                self.tableView.beginUpdates()
                self.tableView.reloadRows(at: indices, with: .none)
                self.tableView.endUpdates()
            }
        }
    }
    
    @objc func didChangedDraggingThumbnail(notification: Notification) {
        if let userInfo = notification.userInfo, let thumbnail = userInfo["thumbnail"] as? Thumbnail {
            self.imageViews().forEach({$0.isHidden = false})
            self.targetImageView(thumbnail: thumbnail)?.isHidden = true
        }
    }
    
    @objc func didTapActionNotification(notification: Notification) {
        if let userInfo = notification.userInfo, let _ = userInfo["container"] as? CommentContainer, let comment = userInfo["comment"] as? Comment, let link = link, let url = URL(string: "\(link.url)/\(comment.id)") {
            let sharedURL = url
            let activityController = UIActivityViewController(activityItems: [sharedURL], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        }
    }
    
    @objc func didTapReplyNotification(notification: Notification) {
        if let userInfo = notification.userInfo, let comment = userInfo["comment"] as? Comment {
            print(comment.id)
            let nav = PostCommentViewController.controller(with: comment)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @objc func didLoadComments(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let reloadData = userInfo[CommentContainerCellar.initialLoadKey] as? Bool ?? false
            let insertIndices = userInfo[CommentContainerCellar.insertIndicesKey] as? [IndexPath] ?? []
            let reloadIndices = userInfo[CommentContainerCellar.reloadIndicesKey] as? [IndexPath] ?? []
            let deleteIndices = userInfo[CommentContainerCellar.deleteIndicesKey] as? [IndexPath] ?? []
            
            assert(Thread.isMainThread)
            if reloadData {
                self.tableView.reloadData()
            } else if insertIndices.count > 0 || reloadIndices.count > 0 || deleteIndices.count > 0 {
                self.tableView.beginUpdates()
                if insertIndices.count > 0 {
                    self.tableView.insertRows(at: insertIndices, with: .fade)
                }
                if reloadIndices.count > 0 {
                    self.tableView.reloadRows(at: reloadIndices, with: .fade)
                }
                if deleteIndices.count > 0 {
                    self.tableView.deleteRows(at: deleteIndices, with: .fade)
                }
                self.tableView.endUpdates()
            }
        }
    }
    
    @objc func didSendCommentNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let newComment = userInfo["newComment"] as? Comment {
                if let parentComment = userInfo["parent"] as? Comment {
                    if let indexPath = cellar.appendNewComment(newComment, to: parentComment, width: self.view.frame.size.width) {
                        self.tableView.beginUpdates()
                        self.tableView.insertRows(at: [indexPath], with: .fade)
                        self.tableView.endUpdates()
                    }
                }
                if let parentLink = userInfo["parent"] as? Link, let link = link {
                    if parentLink.id == link.id {
                        if let indexPath = cellar.appendNewComment(newComment, to: nil, width: self.view.frame.size.width) {
                            self.tableView.beginUpdates()
                            self.tableView.insertRows(at: [indexPath], with: .fade)
                            self.tableView.endUpdates()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Toggle comment cell.
    
    func didPushToggleButtonOnCell(_ cell: UITableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            cellar.toggleExpand(index: indexPath.row)
        }
    }
    
    func getCellAt(_ location: CGPoint) -> UITableViewCell? {
        if let view = previewingView {
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
    
    // MARK: - UIViewControllerPreviewingDelegate
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        if let controller = viewControllerToCommit as? ImageViewPageController {
            controller.setOffset()
            controller.modalPresentationStyle = .custom
            controller.transitioningDelegate = self
            self.present(controller, animated: true, completion: nil)
        } else if let controller = viewControllerToCommit as? WebViewController {
            let nav = UINavigationController(rootViewController: controller)
            self.present(nav, animated: true, completion: nil)
        } else {
            self.present(viewControllerToCommit, animated: true, completion: nil)
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let view = previewingView {
            if let cell = getCellAt(location) as? CommentCell {
                if let (url, sourceRect) = cell.urlAt(location, peekView: view) {
                    previewingContext.sourceRect = sourceRect
                    let controller = WebViewController(nibName: nil, bundle: nil)
                    controller.url = url
                    return controller
                }
                if let (thumbnail, sourceRect, _, _) = cell.thumbnailAt(location, peekView: view) {
                    previewingContext.sourceRect = sourceRect
                    let controller = createImageViewPageControllerWith(cellar.thumbnails, openThumbnail: thumbnail, isOpenedBy3DTouch: true)
                    controller.isNavigationBarHidden = true
                    return controller
                }
            }
        }
        return nil
    }
    
    // MARK: - UIViewController
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        print("viewWillTransition")
        self.cellar.layout(with: size.width, fontSize: 18)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let link = self.link {
            if self.cellar.containers.count == 0 {
                cellar = CommentContainerCellar(link: link)
                cellar.load(width: self.view.frame.size.width)
            }
            self.tableView.reloadData()
            if let bar = self.navigationController?.navigationBar {
                let label = UILabel(frame: bar.bounds)
                label.text = link.title + link.title
                label.numberOfLines = 3
                label.textAlignment = .center
                label.adjustsFontSizeToFitWidth = true
                label.backgroundColor = UIColor.cyan
                self.navigationItem.titleView = label
            }
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "compose"), style: .plain, target: nil, action: nil)
        }
        self.imageViews().forEach({$0.isHidden = false})
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.navigationController?.isToolbarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CloseCommentCell.self, forCellReuseIdentifier: "CloseCommentCell")
        tableView.register(InvisibleCell.self, forCellReuseIdentifier: "InvisibleCell")
        
        tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        tableView.register(UINib(nibName: "MoreCommentCell", bundle: nil), forCellReuseIdentifier: "MoreCell")
        tableView.register(UINib(nibName: "LoadingCommentCell", bundle: nil), forCellReuseIdentifier: "LoadingCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.didLoadComments(notification:)), name: CommentContainerCellarDidLoadCommentsName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.didTapThumbnail(notification:)), name: ThumbnailDidTap, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.didUpdateCommentContainer(notification:)), name: ThingContainableDidUpdate, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.didChangeThumbnailPage(notification:)), name: ImageViewPageControllerDidChangePageName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.didChangedDraggingThumbnail(notification:)), name: ImageViewPageControllerDidStartDraggingThumbnailName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.didTapActionNotification(notification:)), name: CommentCellActionNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.didTapReplyNotification(notification:)), name: CommentCellReplyNotificationName, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentViewController.didSendCommentNotification(notification:)), name: PostCommentViewControllerDidSendCommentName, object: nil)
        
        previewingView = self.view
        
        if let view = previewingView {
            registerForPreviewing(with: self, sourceView: view)
        }
    }
    
    func compose(sender: Any) {
        if let link = link {
            let nav = PostCommentViewController.controller(with: link)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @objc func didTapThumbnail(notification: Notification) {
        if let userInfo = notification.userInfo {
            if let thumbnail = userInfo["Thumbnail"] as? Thumbnail {
                let controller = createImageViewPageControllerWith(cellar.thumbnails, openThumbnail: thumbnail)
                controller.modalPresentationStyle = .custom
                controller.transitioningDelegate = self
                present(controller, animated: true, completion: nil)
            }
        }
    }
    
    func selectionDidBeginTextView(notification: Notification) {
        tableView.isScrollEnabled = false
    }
    
    func selectionDidEndTextView(notification: Notification) {
        tableView.isScrollEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view delegate & data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cellar.containers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = cellar.containers[indexPath.row]

        var cell = tableView.dequeueReusableCell(withIdentifier: content.cellIdentifier)
        
        if cell == nil {
            if let c = content as? CommentContainer {
                cell = CommentCell(numberOfThumbnails: c.numberOfThumbnails)
            }
        }
        
        switch (content, cell) {
        case (let c as CommentContainer, let cell as CommentCell):
            c.downloadImages()
            cell.commentContainer = c
            cell.parentCommentViewController = self
            cell.textView.delegate = self
            return cell
        case (let c as CommentContainer, let cell as CloseCommentCell):
            c.downloadImages()
            cell.commentContainer = c
            cell.parentCommentViewController = self
            return cell
        case (let c as MoreContainer, let cell as MoreCommentCell):
            cell.moreContainer = c
            return cell
        case (_, let cell as LoadingCommentCell):
            return cell
        case (_, let cell as InvisibleCell):
            return cell
        default:
            return UITableViewCell(style: .default, reuseIdentifier: "Normal")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellar.download(index: indexPath.row, width: self.view.frame.size.width)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellar.containers[indexPath.row].height
    }
}

extension CommentViewController {
    func textView(_ textView: UZTextView, didLongTapLinkAttribute value: Any?) {
        if let dict = value as? [String: Any], let url = dict[NSAttributedStringKey.link.rawValue] as? URL {
            print(url)
        }
    }
    
    func textView(_ textView: UZTextView, didClickLinkAttribute value: Any?) {
        if let dict = value as? [String: Any], let url = dict[NSAttributedStringKey.link.rawValue] as? URL {
            print(url)
        }
    }
    
    @objc(selectionDidBeginTextView:) func selectionDidBegin(_ textView: UZTextView) {
        tableView.isScrollEnabled = false
    }
    
    @objc(selectionDidEndTextView:) func selectionDidEnd(_ textView: UZTextView) {
        tableView.isScrollEnabled = true
    }
    
    func didTapTextDoesNotIncludeLinkTextView(_ textView: UZTextView) {
    }
}
