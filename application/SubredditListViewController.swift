//
//  SubredditListCategoryViewController.swift
//  reddift
//
//  Created by sonson on 2015/10/26.
//  Copyright © 2015年 sonson. All rights reserved.
//

import UIKit

/**
 View controller to show subreddits that are obtained from redditlist.com or api.reddift.com.
 This controller is used newsokur and hierarchical list of redditlist.com.
 */
class SubredditListViewController: UITableViewController {
    var list: [SubredditListItem] = []
    
    @IBAction func close(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SubredditListViewSubtitleCell.self, forCellReuseIdentifier: "Cell")
        let barbutton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SubredditListViewController.close(sender:)))
        self.navigationItem.rightBarButtonItem = barbutton
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = list[indexPath.row]
        NotificationCenter.default.post(name: SubredditSelectTabBarControllerDidOpenSubredditName, object: nil, userInfo: ["subreddit": item.subreddit])
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        let item = list[indexPath.row]
        if let cell = cell as? SubredditListViewSubtitleCell {
            cell.textLabel?.text = item.subreddit
            cell.detailTextLabel?.text = item.title
            cell.detailTextLabel?.textColor = UIColor.gray
        }

        return cell
    }
}
