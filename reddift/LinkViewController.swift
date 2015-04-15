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
    var links:[Link] = []
    var paginator:Paginator? = nil
    var loading = false
    var task:NSURLSessionDataTask? = nil
    var segmentedControl:UISegmentedControl? = nil
    
    let types = [ListingSortType.Top, ListingSortType.New, ListingSortType.Hot, ListingSortType.Controversial];
    let titles = [ListingSortType.Top.path(), ListingSortType.New.path(), ListingSortType.Hot.path(), ListingSortType.Controversial.path()];

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func load() {
        if loading {
            return
        }
        self.loading = true
        if let seg = self.segmentedControl {
            self.task = session?.linkList(self.paginator, sortingType:types[seg.selectedSegmentIndex], completion: { (links, paginator, error) -> Void in
                self.task = nil
                if error == nil {
                    self.links += links
                    self.tableView.reloadData()
                    self.paginator = paginator
                    self.loading = false
                }
                else {
                    println(error)
                }
            })
        }
    }
    
    func segmentChanged(sender:AnyObject) {
        if let seg = sender as? UISegmentedControl {
            let title = titles[seg.selectedSegmentIndex]
            self.loading = true
            self.task = session?.linkList(self.paginator, sortingType:types[seg.selectedSegmentIndex], completion: { (links, paginator, error) -> Void in
                self.task = nil
                if error == nil {
                    self.links.removeAll(keepCapacity: true)
                    self.links += links
                    self.tableView.reloadData()
                    self.paginator = paginator
                    self.loading = false
                }
                else {
                    println(error)
                }
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.toolbarHidden = false
        let seg = UISegmentedControl(items:titles)
        seg.addTarget(self, action: "segmentChanged:", forControlEvents: UIControlEvents.ValueChanged)
        seg.frame = CGRect(x: 0, y: 0, width: 300, height: 28)
        seg.selectedSegmentIndex = 0
        let space = UIBarButtonItem(barButtonSystemItem:.FlexibleSpace, target: nil, action: nil)
        let item = UIBarButtonItem(customView: seg)
        self.toolbarItems = [space, item, space]
        self.segmentedControl = seg
        load()
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

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        if indices(links) ~= indexPath.row {
            let link = links[indexPath.row]
            cell.textLabel?.text = link.title
        }

        return cell
    }
}
