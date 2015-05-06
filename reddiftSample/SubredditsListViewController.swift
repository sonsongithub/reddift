//
//  SubredditsListViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/16.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import reddift

class SubredditsListViewController: UITableViewController {
    var session:Session? = nil
    var subreddits:[Subreddit] = []
    var paginator:Paginator? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
		if self.subreddits.count == 0 {
			session?.getSubscribingSubreddit(paginator, completion: { (result) -> Void in
                switch result {
                case let .Failure:
                    println(result.error)
                case let .Success:
                    if let listing = result.value as? Listing {
                        if let subreddits = listing.children as? [Subreddit] {
                            self.subreddits += subreddits
                        }
//                        self.paginator = listing.paginator()
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }
            })
		}
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
        if segue.identifier == "ToSubredditsViewController" {
            if let con = segue.destinationViewController as? LinkViewController {
                con.session = self.session
                if let indexPath = self.tableView.indexPathForSelectedRow() {
                    if indices(subreddits) ~= indexPath.row {
                        con.subreddit = subreddits[indexPath.row]
                    }
                }
            }
        }
    }
}
