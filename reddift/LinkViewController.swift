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

    override func viewDidLoad() {
        types += [ListingSortType.Top, ListingSortType.New, ListingSortType.Hot, ListingSortType.Controversial]
        titles += [ListingSortType.Top.path(), ListingSortType.New.path(), ListingSortType.Hot.path(), ListingSortType.Controversial.path()]
        super.viewDidLoad()
        let seg = UISegmentedControl(items:titles)
        seg.addTarget(self, action: "segmentChanged:", forControlEvents: UIControlEvents.ValueChanged)
        seg.frame = CGRect(x: 0, y: 0, width: 300, height: 28)
        seg.selectedSegmentIndex = 0
        self.segmentedControl = seg
    }
    
    func load() {
        if loading {
            return
        }
        self.loading = true
        if let seg = self.segmentedControl {
            self.task = session?.linkList(self.paginator, sortingType:types[seg.selectedSegmentIndex], subreddit:subreddit, completion: { (links, paginator, error) -> Void in
                self.task = nil
                if error == nil {
                    self.links += links
                    self.tableView.reloadData()
                    self.paginator = paginator
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
        if indices(links) ~= indexPath.row {
            let link = links[indexPath.row]
            println(link)
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        if indices(links) ~= indexPath.row {
            let link = links[indexPath.row]
            cell.textLabel?.text = link.title
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
