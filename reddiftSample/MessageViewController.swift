//
//  MessageViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/21.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit
import reddift

class MessageViewController: UITableViewController {
	var session:Session? = nil
    var messageWhere = MessageWhere.Inbox
	var messages:[Thing] = []
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.title = messageWhere.description
		
		session?.getMessage(messageWhere, completion: { (result) -> Void in
            switch result {
            case let .Failure:
                println(result.error)
            case let .Success:
                if let listing = result.value as? Listing {
                    for child in listing.children {
						if let message = child as? Message {
							self.messages.append(message)
						}
						if let link = child as? Link {
							self.messages.append(link)
						}
						if let comment = child as? Comment {
							self.messages.append(comment)
						}
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }
            }
		})
	}

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

		if indices(messages) ~= indexPath.row {
			let child = messages[indexPath.row]
			if let message = child as? Message {
				cell.textLabel?.text = message.subject
			}
			else if let link = child as? Link {
				cell.textLabel?.text = link.title
			}
			else if let comment = child as? Comment {
				cell.textLabel?.text = comment.body
			}
		}
		
        return cell
    }
}
