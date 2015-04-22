//
//  SubredditsListViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/16.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class SubredditsListViewController: UITableViewController {
    var session:Session? = nil
    var subreddits:[Subreddit] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
		if self.subreddits.count == 0 {
			session?.downloadSubreddit(nil, completion: { (obj, error) -> Void in
				if error == nil {
					if let listing = obj as? Listing {
						if let subreddits = listing.children as? [Subreddit] {
							self.subreddits += subreddits
						}
					}
					self.tableView.reloadData()
				}
				else {
					println(error)
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
            if let con = segue.destinationViewController as? SubredditsViewController {
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
