//
//  SubredditsViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/16.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class SubredditsViewController: LinkViewController {

    override func viewDidLoad() {
        self.title = self.subreddit?.title
        types.removeAll(keepCapacity: true)
        titles.removeAll(keepCapacity: true)
        types += [ListingSortType.New, ListingSortType.Hot];
        titles += [ListingSortType.New.path(), ListingSortType.Hot.path()];
        super.viewDidLoad()
    }
    
    override func load() {
        if loading {
            return
        }
        self.loading = true
        if let seg = self.segmentedControl, subreddit = self.subreddit {
            self.task = session?.linkList(self.paginator, sortingType:types[seg.selectedSegmentIndex], subreddit:subreddit, completion: { (object, error) -> Void in
                self.task = nil
                if error == nil {
					if let listing = object as? Listing {
						if let links = listing.children as? [Link] {
							self.links += links
						}
                    }
                    self.updateStrings()
                    self.tableView.reloadData()
                    self.loading = false
                }
                else {
                    println(error)
                }
            })
        }
    }
}
