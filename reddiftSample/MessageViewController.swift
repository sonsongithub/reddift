//
//  MessageViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/21.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import reddift

class MessageViewController: UITableViewController {
	var session: Session? = nil
    var messageWhere = MessageWhere.inbox
	var messages: [Thing] = []
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.title = messageWhere.description
        do {
            try session?.getMessage(messageWhere, completion: { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let listing):
                        self.messages += listing.children
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.tableView.reloadData()
                        })
                }
            })
        } catch { print(error) }
	}

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell

		if messages.indices ~= indexPath.row {
			let child = messages[indexPath.row]
			if let message = child as? Message {
				cell.textLabel?.text = message.subject
			} else if let link = child as? Link {
				cell.textLabel?.text = link.title
			} else if let comment = child as? Comment {
				cell.textLabel?.text = comment.body
			}
		}
		
        return cell
    }
}
