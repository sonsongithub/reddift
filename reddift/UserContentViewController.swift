//
//  UserContentViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/27.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class UserContentViewController: UITableViewController {
    var session:Session?
    var userContent:UserContent = .Comments
    var source:[Thing] = []
    var contents:[CellContent] = []
    
    func updateStrings() {
        contents.removeAll(keepCapacity:true)
        contents = source.map{(var obj) -> CellContent in
            if let comment = obj as? Comment {
                return CellContent(string:comment.body, width:self.view.frame.size.width)
            }
            else if let link = obj as? Link {
                return CellContent(string:link.title, width:self.view.frame.size.width)
            }
            else {
                return CellContent(string:"Other?", width:self.view.frame.size.width)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib:UINib = UINib(nibName: "UZTextViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        
        if let name = session?.token.name {
            session?.getUser(name, content:userContent, paginator:nil, completion: { (result) -> Void in
                switch result {
                case let .Error(error):
                    println(error.code)
                case let .Value(box):
                    println(box.value)
                    if let listing = box.value as? Listing {
                        for obj in listing.children {
                            if let link = obj as? Link {
                                self.source.append(link)
                            }
                        }
                        println(listing.more)
//                        self.paginator = listing.paginator
                    }
                    self.updateStrings()
//                    if let listing = box.value as? Listing {
//                        if let array = listing.children {
//                            self.source += array
//                        }
//                    }
//                    self.updateStrings()
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData()
                    })
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
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indices(source) ~= indexPath.row {
            var obj = source[indexPath.row]
            if let comment = obj as? Comment {
                session?.getInfo(comment.link_id, completion: { (result) -> Void in
                    switch result {
                    case let .Error(error):
                        println(error.code)
                    case let .Value(box):
                        if let listing = box.value as? Listing {
                            if listing.children.count == 1 {
                                if let link = listing.children[0] as? Link {
                                    if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("CommentViewController") as? CommentViewController{
                                        vc.session = self.session
                                        vc.link = link
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        })
                                    }
                                }
                            }
                        }
                    }
                })
            }
            else if let link = obj as? Link {
                if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("CommentViewController") as? CommentViewController{
                    vc.session = session
                    vc.link = link
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
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
