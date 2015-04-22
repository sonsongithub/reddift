//
//  MessageViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/21.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class MessageViewController: UITableViewController {
	var session:Session? = nil
	var box = "inbox"
	var messages:[Thing] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.title = box
		
		session?.downloadMessageWhereBox(box, completion: { (object, error) -> Void in
			if error == nil {
				if let listing = object as? Listing {
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
				}
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
