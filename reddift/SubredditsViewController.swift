//
//  SubredditsViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/16.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class SubredditsViewController: UITableViewController {
    var session:Session? = nil
    var subreddits:[Subreddit] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        session?.subredditsMine(nil, subredditsMineWhere: SubredditsMineWhere.Subscriber, completion: { (subreddits, paginator, error) -> Void in
            if error == nil {
                self.subreddits += subreddits
                self.tableView.reloadData()
            }
            else {
                println(error)
            }
        })
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subreddits.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        if indices(subreddits) ~= indexPath.row {
            let link = subreddits[indexPath.row]
            cell.textLabel?.text = link.title
        }

        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
}
