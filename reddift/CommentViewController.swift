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
    var paginator:Paginator? = Paginator()
    var contents:[CellContent] = []
	
	deinit{
		println("deinit")
	}
    
    func updateStrings() {
        contents.removeAll(keepCapacity:true)
        contents = comments.map{CellContent(string:$0.body, width:self.view.frame.size.width)}
    }
	
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib:UINib = UINib(nibName: "UZTextViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let link = self.link {
            session?.getArticles(self.paginator, link:link, sort:CommentSort.New, completion: { (result) -> Void in
                switch result {
                case let .Error(error):
                    println(error.code)
                case let .Value(box):
                    if let objects = box.value as? [AnyObject] {
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
                    self.paginator = nil
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
                }
            });
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indices(contents) ~= indexPath.row {
            return contents[indexPath.row].textHeight
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        if let cell = cell as? UZTextViewCell {
            if indices(contents) ~= indexPath.row {
                cell.textView?.attributedString = contents[indexPath.row].attributedString
            }
        }
		
        return cell
    }
}
