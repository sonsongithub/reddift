//
//  CommentViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/17.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import reddift

class CommentViewController: UITableViewController, UZTextViewCellDelegate {
    var session:Session? = nil
    var subreddit:Subreddit? = nil
    var link:Link? = nil
	var comments:[Thing] = []
    var paginator:Paginator? = Paginator()
    var contents:[CellContent] = []
	
	deinit{
		println("deinit")
	}
    
    func updateStrings(newComments:[Thing]) -> [CellContent] {
        return newComments.map { (thing:Thing) -> CellContent in
            if let comment = thing as? Comment {
                return CellContent(string:comment.body, width:self.view.frame.size.width, hasRelies:false)
            }
            else {
                return CellContent(string:"more", width:self.view.frame.size.width, hasRelies:false)
            }
        }
    }
    
    func vote(direction:VoteDirection) {
        if let link = self.link {
            session?.setVote(direction, name: link.name, completion: { (result) -> Void in
                switch result {
                case let .Failure:
                    println(result.error)
                case let .Success:
                    println(result.value)
                }
            })
        }
    }
    
    func save(save:Bool) {
        if let link = self.link {
            session?.setSave(save, name: link.name, completion: { (result) -> Void in
                switch result {
                case let .Failure:
                    println(result.error)
                case let .Success:
                    println(result.value)
                }
            })
        }
    }
    
    func hide(hide:Bool) {
        if let link = self.link {
            session?.setHide(hide, name: link.name, completion: { (result) -> Void in
                switch result {
                case let .Failure:
                    println(result.error)
                case let .Success:
                    println(result.value)
                }
            })
        }
    }
    
    func downVote(sender:AnyObject?) {
        vote(.Down)
    }
    
    func upVote(sender:AnyObject?) {
        vote(.Up)
    }
    
    func cancelVote(sender:AnyObject?) {
        vote(.No)
    }
    
    func doSave(sender:AnyObject?) {
        save(true)
    }
    
    func doUnsave(sender:AnyObject?) {
        save(false)
    }
    
    func doHide(sender:AnyObject?) {
        hide(true)
    }
    
    func doUnhide(sender:AnyObject?) {
        hide(false)
    }
    
    func updateToolbar() {
        var items:[UIBarButtonItem] = []
        let space = UIBarButtonItem(barButtonSystemItem:.FlexibleSpace, target: nil, action: nil)
        if let link = self.link {
            items.append(space)
            // voting status
            if let likes = link.likes {
                if likes {
                    items.append(UIBarButtonItem(image: UIImage(named: "thumbDown"), style:.Plain, target: self, action: "downVote:"))
                    items.append(space)
                    items.append(UIBarButtonItem(image: UIImage(named: "thumbUpFill"), style:.Plain, target: self, action: "cancelVote:"))
                }
                else {
                    items.append(UIBarButtonItem(image: UIImage(named: "thumbDownFill"), style:.Plain, target: self, action: "cancelVote:"))
                    items.append(space)
                    items.append(UIBarButtonItem(image: UIImage(named: "thumbUp"), style:.Plain, target: self, action: "upVote:"))
                }
            }
            else {
                items.append(UIBarButtonItem(image: UIImage(named: "thumbDown"), style:.Plain, target: self, action: "downVote:"))
                items.append(space)
                items.append(UIBarButtonItem(image: UIImage(named: "thumbUp"), style:.Plain, target: self, action: "upVote:"))
            }
            items.append(space)
            
            // save
            if link.saved {
                items.append(UIBarButtonItem(image: UIImage(named: "favoriteFill"), style:.Plain, target: self, action:"doUnsave:"))
            }
            else {
                items.append(UIBarButtonItem(image: UIImage(named: "favorite"), style:.Plain, target: self, action:"doSave:"))
            }
            items.append(space)
            
            // hide
            if link.hidden {
                items.append(UIBarButtonItem(image: UIImage(named: "eyeFill"), style:.Plain, target: self, action: "doUnhide:"))
            }
            else {
                items.append(UIBarButtonItem(image: UIImage(named: "eye"), style:.Plain, target: self, action: "doHide:"))
            }
            items.append(space)
            
            // comment button
            items.append(UIBarButtonItem(image: UIImage(named: "comment"), style:.Plain, target: nil, action: nil))
            items.append(space)
        }
        self.toolbarItems = items
    }
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "UZTextViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView.registerNib(UINib(nibName: "UZTextViewWithMoreButtonCell", bundle: nil), forCellReuseIdentifier: "MoreCell")
        
        updateToolbar()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.toolbarHidden = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let link = self.link {
            session?.getArticles(link, sort:CommentSort.New, comments:nil, completion: { (result) -> Void in
                switch result {
                case let .Failure:
                    println(result.error)
                case let .Success:
                    println(result.value)
//                    if let listing = result.value {
//                        var newComments:[Thing] = []
//                        for obj in listing.children {
//                            if let comment = obj as? Comment {
//                                newComments += extendAllReplies(comment)
//                            }
//                        }
//                        self.comments += newComments
//                        self.contents += self.updateStrings(newComments)
//                        self.paginator = listing.paginator
//                    }
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
        return self.contents.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indices(contents) ~= indexPath.row {
            return contents[indexPath.row].textHeight
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell! = nil
        if indices(contents) ~= indexPath.row {
            cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
            if let cell = cell as? UZTextViewCell {
                cell.delegate = self
                cell.textView?.attributedString = contents[indexPath.row].attributedString
                cell.content = comments[indexPath.row]
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indices(comments) ~= indexPath.row {
            if let more = comments[indexPath.row] as? More, link = self.link {
                println(more)
                session?.getMoreChildren(more.children, link:link, sort:CommentSort.New, completion:{ (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error)
                    case let .Success:
                        println(result.value)
                    }
                });
            }
        }
    }
    
    func pushedMoreButton(cell:UZTextViewCell) {
    }
}
