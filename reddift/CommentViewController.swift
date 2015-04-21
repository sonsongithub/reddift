//
//  CommentViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/17.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class CommentViewController: UITableViewController {
    var session:Session? = nil
    var subreddit:Subreddit? = nil
    var link:Link? = nil
	var comments:[Comment] = []
	
	deinit{
		println("deinit")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let link = self.link {
            session?.downloadComment(link, completion: { (object, error) -> Void in
				if error == nil {
					if let objects = object as? [AnyObject] {
						if let listing = objects[0] as? Listing {
							if let links = listing.children as? [Link] {
								for link:Link in links {
									println(link.selftext)
									println(link.selftext_html)
									println(link.permalink)
								}
							}
						}
						if let listing = objects[1] as? Listing {
							if let comments = listing.children as? [Comment] {
								self.comments += comments
							}
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
        return self.comments.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
		if indices(comments) ~= indexPath.row {
			let comment = comments[indexPath.row]
			cell.textLabel?.text = comment.body
		}
		
        return cell
    }
}
