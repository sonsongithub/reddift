//
//  LinkViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/15.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class LinkViewController: UITableViewController {
    var session:Session? = nil
    var subreddit:Subreddit? = nil
    var links:[Link] = []
    var paginator:Paginator? = nil
    var loading = false
    var task:NSURLSessionDataTask? = nil
    var segmentedControl:UISegmentedControl? = nil
    
    var types:[ListingSortType] = []
    var titles:[String] = []
    
    var heights:[CGFloat] = []
    var texts:[NSAttributedString] = []

    override func viewDidLoad() {
        types += [ListingSortType.Top, ListingSortType.New, ListingSortType.Hot, ListingSortType.Controversial]
        titles += [ListingSortType.Top.path(), ListingSortType.New.path(), ListingSortType.Hot.path(), ListingSortType.Controversial.path()]
        super.viewDidLoad()
        let nib:UINib = UINib(nibName: "UZTextViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        let seg = UISegmentedControl(items:titles)
        seg.addTarget(self, action: "segmentChanged:", forControlEvents: UIControlEvents.ValueChanged)
        seg.frame = CGRect(x: 0, y: 0, width: 300, height: 28)
        seg.selectedSegmentIndex = 0
        self.segmentedControl = seg
    }
    
    func updateStrings() {
        texts.removeAll(keepCapacity: true)
        heights.removeAll(keepCapacity: true)
        
        for link in links {
            let attr = NSAttributedString(string: link.title)
            let horizontalMargin = UZTextViewCell.margin().left + UZTextViewCell.margin().right
            let verticalMargin = UZTextViewCell.margin().top + UZTextViewCell.margin().bottom
            let size = UZTextView.sizeForAttributedString(attr, withBoundWidth:self.view.frame.size.width - horizontalMargin, margin: UIEdgeInsetsMake(0, 0, 0, 0))
            texts.append(attr)
            heights.append(size.height + verticalMargin)
        }
    }
    
    func load() {
        if loading {
            return
        }
        self.loading = true
        if let seg = self.segmentedControl {
            self.task = session?.linkList(self.paginator, sortingType:types[seg.selectedSegmentIndex], subreddit:subreddit, completion: { (object, error) -> Void in
                self.task = nil
                if error == nil {
					
					if let listing = object as? Listing {
						if let links = listing.children as? [Link] {
							self.links += links
						}
					}
                    self.updateStrings()
                    self.tableView.reloadData()
                }
                else {
                    println(error)
                }
                self.loading = false
            })
        }
    }
    
    func segmentChanged(sender:AnyObject) {
        if let seg = sender as? UISegmentedControl {
            self.links.removeAll(keepCapacity: true)
            self.tableView.reloadData()
            load()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.toolbarHidden = false
        let space = UIBarButtonItem(barButtonSystemItem:.FlexibleSpace, target: nil, action: nil)
        let item = UIBarButtonItem(customView:self.segmentedControl!)
        self.toolbarItems = [space, item, space]
        if self.links.count == 0 {
            load()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == (links.count - 1) {
            load()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ToCommentViewController", sender: nil)
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
