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
        super.viewDidLoad()
        self.title = self.subreddit?.title
        types.removeAll(keepCapacity: true)
        titles.removeAll(keepCapacity: true)
        types += [ListingSortType.New, ListingSortType.Hot];
        titles += [ListingSortType.New.path(), ListingSortType.Hot.path()];
    }
    
    override func load() {
        if loading {
            return
        }
        self.loading = true
        if let seg = self.segmentedControl, subreddit = self.subreddit {
            self.task = session?.linkList(self.paginator, sortingType:types[seg.selectedSegmentIndex], subreddit:subreddit, completion: { (links, paginator, error) -> Void in
                self.task = nil
                if error == nil {
                    self.links += links
                    self.tableView.reloadData()
                    self.paginator = paginator
                    self.loading = false
                }
                else {
                    println(error)
                }
            })
        }
    }
}
