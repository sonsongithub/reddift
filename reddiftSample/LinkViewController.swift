//
//  LinkViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/15.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit
import reddift

class LinkViewController: UITableViewController {
    var session:Session? = nil
    var subreddit:Subreddit? = nil
    var links:[Link] = []
    var paginator:Paginator? = Paginator()
    var loading = false
    var task:NSURLSessionDataTask? = nil
    var segmentedControl:UISegmentedControl? = nil
	var sortTitles:[String] = []
	var sortTypes:[LinkSort] = []
    var contents:[CellContent] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib:UINib = UINib(nibName: "UZTextViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
		
		self.title = self.subreddit?.title
		sortTypes += [.Controversial, .Hot, .New, .Random, .Top]
		for sortType in sortTypes {
			sortTitles.append(sortType.path)
		}
		
		segmentedControl = UISegmentedControl(items:sortTitles)
		segmentedControl?.addTarget(self, action: "segmentChanged:", forControlEvents: UIControlEvents.ValueChanged)
		segmentedControl?.frame = CGRect(x: 0, y: 0, width: 300, height: 28)
		segmentedControl?.selectedSegmentIndex = 0
		
		let space = UIBarButtonItem(barButtonSystemItem:.FlexibleSpace, target: nil, action: nil)
		let item = UIBarButtonItem(customView:self.segmentedControl!)
		self.toolbarItems = [space, item, space]
		if self.links.count == 0 {
			load()
		}
    }
	
    func updateStrings() {
        contents.removeAll(keepCapacity:true)
        contents = links.map{CellContent(string:$0.title, width:self.view.frame.size.width)}
    }
    
    func load() {
        if let seg = self.segmentedControl {
            session?.getList(paginator, sort:sortTypes[seg.selectedSegmentIndex], subreddit:subreddit, completion: { (result) in
                switch result {
                case let .Error(error):
                    println(error.code)
                case let .Value(box):
                    println(box.value)
                    if let listing = box.value as? Listing {
                        for obj in listing.children {
                            if let link = obj as? Link {
                                self.links.append(link)
                            }
                        }
                        self.paginator = listing.paginator
                    }
                    self.updateStrings()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                        self.loading = false
                    })
                }
            })
        }
    }
    
    func segmentChanged(sender:AnyObject) {
        if let seg = sender as? UISegmentedControl {
            self.links.removeAll(keepCapacity: true)
            self.tableView.reloadData()
            self.paginator = Paginator()
            load()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.toolbarHidden = false
        if let subreddit = subreddit {
            session?.getSticky(subreddit, completion: { (result) -> Void in
                switch result {
                case let .Error(error):
                    println("-------------")
                    println(error.code)
                case let .Value(box):
                    println("-------------")
                    println(box.value)
                }
            })
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == (contents.count - 1) {
            load()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ToCommentViewController", sender: nil)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToCommentViewController" {
            if let con = segue.destinationViewController as? CommentViewController {
                if let selectedIndexPath = tableView.indexPathForSelectedRow() {
                    if indices(links) ~= selectedIndexPath.row {
                        let link = links[selectedIndexPath.row]
                        con.session = session
                        con.subreddit = subreddit
                        con.link = link
                    }
                }
            }
        }
    }
}
