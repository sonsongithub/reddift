//
//  FrontViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/16.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class FrontViewController: LinkViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func load() {
        if let seg = self.segmentedControl {
            session?.getList(nil, sortingType: types[seg.selectedSegmentIndex], subreddit: nil, completion: { (result) in
                switch result {
                case let .Error(error):
                    println(error.code)
                case let .Value(box):
                    if let listing = box.value as? Listing {
                        if let links = listing.children as? [Link] {
                            self.links += links
                        }
                    }
                    self.updateStrings()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                        self.loading = false
                    })
                }
            })
        }
    }
    
    override func segmentChanged(sender:AnyObject) {
//        if let seg = sender as? UISegmentedControl {
//            let title = titles[seg.selectedSegmentIndex]
//            self.loading = true
//            self.task = session?.linkList(self.paginator, sortingType:types[seg.selectedSegmentIndex], subreddit:nil, completion: { (object, error) -> Void in
//                self.task = nil
//                if error == nil {
//                    self.links.removeAll(keepCapacity: true)
//					
//					if let listing = object as? Listing {
//						if let links = listing.children as? [Link] {
//							self.links += links
//						}
//                    }
//                    self.updateStrings()
//                    self.tableView.reloadData()
//                    self.loading = false
//                }
//                else {
//                    println(error)
//                }
//            })
//        }
    }
}
