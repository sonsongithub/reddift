//
//  BaseSubredditsViewController.swift
//  reddift
//
//  Created by sonson on 2015/05/04.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit
import reddift

class BaseSubredditsViewController: UITableViewController, UISearchBarDelegate {
    var session:Session? = nil
    var paginator:Paginator? = Paginator()
    var loading = false
    var task:NSURLSessionDataTask? = nil
    var segmentedControl:UISegmentedControl? = nil
    
    var sortTitles:[String] = []
    var sortTypes:[SubredditsWhere] = []
    
    var subreddits:[Subreddit] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}
