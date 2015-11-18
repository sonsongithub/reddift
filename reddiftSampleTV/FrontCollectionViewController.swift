//
//  FrontCollectionViewController.swift
//  reddift
//
//  Created by sonson on 2015/11/18.
//  Copyright © 2015年 sonson. All rights reserved.
//

import UIKit
import reddift

private let reuseIdentifier = "Cell"

class FrontCollectionViewController: UICollectionViewController {
    let horizontalMargin:CGFloat = 400
    let textViewMargin:CGFloat = 10
    var link:[Link] = []
    var contents:[CellContent] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let anonymouseSession = Session()
        do {
            try anonymouseSession.getList(Paginator(), subreddit: nil, sort: .Controversial, timeFilterWithin: .Week) { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error)
                case .Success(let listing):
                    let incomming = listing.children.flatMap({$0 as? Link})
                    let incommingContents = incomming.map({
                        return CellContent(string:$0.title, width:self.view.frame.size.width - self.horizontalMargin - self.textViewMargin, fontSize: 32)
                    })
                    
                    self.link.appendContentsOf(incomming)
                    self.contents.appendContentsOf(incommingContents)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.collectionView?.reloadData()
                    })
                }
            }
        }
        catch { print(error) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.registerNib(UINib(nibName: "TVUZTextVIewCell", bundle: nil), forCellWithReuseIdentifier: "TVUZTextVIewCell")
        self.collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 100, 0)
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contents.count
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(self.view.frame.size.width - horizontalMargin, contents[indexPath.row].textHeight + textViewMargin)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TVUZTextVIewCell", forIndexPath: indexPath)
        if let cell = cell as? TVUZTextVIewCell {
            cell.textView?.attributedString = contents[indexPath.row].attributedString
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
