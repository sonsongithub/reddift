//
//  TabSelectViewController.swift
//  reddift
//
//  Created by sonson on 2015/10/28.
//  Copyright © 2015年 sonson. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

struct TabInfo {
    let subreddit: String
    let linkID: String
    
    init(subreddit: String, linkID: String) {
        self.subreddit = subreddit
        self.linkID = linkID
    }
}

class TabManager {
    var currentIndex = 0
    var list: [TabInfo] = []
    
    /**
     Singleton model.
     */
    static let sharedInstance = TabManager()

    init() {
        let blank = TabInfo(subreddit: "", linkID: "")
        list.append(blank)
    }
    
    func update(info: TabInfo) {
        list[currentIndex] = info
    }
    
    func screenshotImagePath(index: Int) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let cacheRootPath: NSString = paths[0] as NSString
        let cachePath = cacheRootPath.appendingPathComponent("screenshot")
        do {
            try FileManager.default.createDirectory(atPath: cachePath, withIntermediateDirectories: true, attributes: [:])
        } catch {
        }
        return (cachePath as NSString).appendingPathComponent("\(index)") as String
    }
    
    func setScreenshot(image: UIImage) {
        let path = screenshotImagePath(index: currentIndex)
        print(path)
        let data = image.jpegData(compressionQuality: 0.5) as NSData?
        data?.write(toFile: path, atomically: false)
    }
    
    func imageForIndex(index: Int) -> UIImage? {
        let path = screenshotImagePath(index: index)
        if let data = NSData(contentsOfFile: path) {
            return UIImage(data: data as Data)
        }
        return nil
    }
}

class TabSelectViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var cellSize: CGSize = CGSize.zero
    var createNewTabAnimation = false
    var animatingView: UIView?
    
    /**
     Singleton model.
     */
    static let sharedNavigationController = TabSelectViewController.tabSelectNavigationController()
    
    static func tabSelectNavigationController() -> UINavigationController {
        let instance = TabSelectViewController()
        return UINavigationController(rootViewController: instance)
    }
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.minimumLineSpacing = 0
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func close(sender: AnyObject) {
        dismiss()
    }
    
    func startAnimationWhenWillAppear(image: UIImage) {
        animatingView = UIImageView(image: image)
        if let animatingView = animatingView {
            animatingView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            self.navigationController?.view.addSubview(animatingView)
        }
    }
    
    func startAnimationWhenWillAppearWithSnapshotView(view: UIView) {
        animatingView = view
        if let animatingView = animatingView {
//            animatingView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            self.navigationController?.view.addSubview(animatingView)
        }
    }

    func startAnimationWhenDidAppear() {
        if let cell = self.collectionView?.cellForItem(at: IndexPath(row: TabManager.sharedInstance.currentIndex, section: 0)) as? TabViewCell {
            let cellImageView = cell.screenImageView!
            let targetRect = animatingView!.superview!.convert(cellImageView.frame, from: cellImageView.superview)
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.animatingView!.frame = targetRect
                }, completion: { (_) -> Void in
                    UIView.animate(withDuration: 0.2, animations: { () -> Void in
                        self.animatingView!.alpha = 0
                    }, completion: { (_) -> Void in
                        self.animatingView!.removeFromSuperview()
                })
            })
        }
    }
    
    @IBAction func add(sender: AnyObject) {
        collectionView?.performBatchUpdates({ () -> Void in
            let blank = TabInfo(subreddit: "", linkID: "")
            let insertingIndexPath = IndexPath(row: TabManager.sharedInstance.list.count, section: 0)
            TabManager.sharedInstance.list.append(blank)
            self.collectionView?.insertItems(at: [insertingIndexPath])
            }, completion: { (success) -> Void in
                if success {
                    self.createNewTabAnimation = true
                    let insertedIndexPath = IndexPath(row: TabManager.sharedInstance.list.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: insertedIndexPath as IndexPath, at: .right, animated: true)
                }
        })
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if createNewTabAnimation {
            createNewTabAnimation = false
            
//            let info = TabManager.sharedInstance.list[TabManager.sharedInstance.list.count - 1]
//            TabManager.sharedInstance.currentIndex = TabManager.sharedInstance.list.count - 1
//            NotificationCenter.default.post(name: Notification.Name(rawValue: OpenSubreddit), object: nil, userInfo: ["subreddit":info.subreddit])
            dismiss()
        }
    }
    
    func dismiss() {
        if let cell = self.collectionView?.cellForItem(at: IndexPath(row: TabManager.sharedInstance.currentIndex, section: 0)) as? TabViewCell {
            let cellImageView = cell.screenImageView!
            let targetRect = self.navigationController!.view.convert(cellImageView.frame, from: cellImageView.superview)
            if let nav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                
                let v = nav.view.snapshotView(afterScreenUpdates: true) ?? UIView()
                v.frame = targetRect
                self.navigationController!.view.addSubview(v)
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    v.frame = self.navigationController!.view.frame
                    }, completion: { (_) -> Void in
                        self.dismiss(animated: false, completion: { () -> Void in
                            v.removeFromSuperview()
                        })
                })

            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(UINib(nibName: "TabViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.alwaysBounceHorizontal = true
        self.collectionView?.alwaysBounceVertical = false
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.showsVerticalScrollIndicator = false
        self.view.backgroundColor = UIColor.white
        self.collectionView?.backgroundColor = UIColor.white
        self.navigationController?.setToolbarHidden(false, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let tileRatio: CGFloat = 0.6
        let rect = self.view.frame
        cellSize = CGSize(width: ceil(rect.size.width * tileRatio), height: ceil(rect.size.height - 64))
        self.collectionView?.contentInset = UIEdgeInsets(top: 0, left: self.view.frame.size.width * (1 - tileRatio) * 0.5, bottom: 0, right: self.view.frame.size.width * (1 - tileRatio) * 0.5)
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let add = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(TabSelectViewController.add(sender:)))
        let close = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(TabSelectViewController.close(sender:)))
        self.toolbarItems = [space, add, space, close]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TabManager.sharedInstance.list.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
    
        if let cell = cell as? TabViewCell {
            let info = TabManager.sharedInstance.list[indexPath.row]
            let image = TabManager.sharedInstance.imageForIndex(index: indexPath.row)
            cell.screenImageView?.image = image
            cell.numberLabel?.text = info.subreddit
        }
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let info = TabManager.sharedInstance.list[indexPath.row]
//        TabManager.sharedInstance.currentIndex = indexPath.row
//        NotificationCenter.default.post(name: Notification.Name(rawValue: OpenSubreddit), object: nil, userInfo: ["subreddit":info.subreddit])
        dismiss()
    }
}

extension TabSelectViewController {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSize
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}
