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
    var heights:[CGFloat] = []
    var texts:[NSAttributedString] = []
	
	deinit{
		println("deinit")
	}
    
    func updateStrings() {
        texts.removeAll(keepCapacity: true)
        heights.removeAll(keepCapacity: true)
        
        for comment in comments {
            let attr = NSAttributedString(string: comment.body)
            let horizontalMargin = UZTextViewCell.margin().left + UZTextViewCell.margin().right
            let verticalMargin = UZTextViewCell.margin().top + UZTextViewCell.margin().bottom
            let size = UZTextView.sizeForAttributedString(attr, withBoundWidth:self.view.frame.size.width - horizontalMargin, margin: UIEdgeInsetsMake(0, 0, 0, 0))
            texts.append(attr)
            heights.append(size.height + verticalMargin)
        }
    }
	
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib:UINib = UINib(nibName: "UZTextViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
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
                    self.updateStrings()
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indices(heights) ~= indexPath.row {
            return heights[indexPath.row]
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        if let cell = cell as? UZTextViewCell {
            if indices(texts) ~= indexPath.row {
                cell.textView?.attributedString = texts[indexPath.row]
            }
        }
		
        return cell
    }
}
