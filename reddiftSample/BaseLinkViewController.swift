//
//  BaseLinkViewController.swift
//  reddift
//
//  Created by sonson on 2015/05/03.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import reddift

class BaseLinkViewController: UITableViewController, UISearchBarDelegate {
    var session: Session? = nil
    var subreddit: Subreddit? = nil
    var paginator: Paginator = Paginator()
    var loading = false
    var task: URLSessionDataTask? = nil
    var segmentedControl: UISegmentedControl? = nil
    
    var sortTitles: [String] = []
    var sortTypes: [LinkSortType] = []
    
    var links: [Link] = []
    var contents: [CellContent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib: UINib = UINib(nibName: "UZTextViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    func updateStrings() {
        contents.removeAll(keepingCapacity:true)
        contents = links.map {CellContent(string:$0.title, width:self.view.frame.size.width - 25)}
    }
}
