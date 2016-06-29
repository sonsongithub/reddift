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
    var session: Session? = nil
    var subreddit: Subreddit? = nil
    var link: Link? = nil
	var comments: [Thing] = []
    var paginator: Paginator? = Paginator()
    var contents: [CellContent] = []
	
	deinit {
		print("deinit")
	}
    
    func updateStrings(_ newComments: [Thing]) -> [CellContent] {
        let width = self.view.frame.size.width
        print(width)
        return newComments.map { (thing: Thing) -> CellContent in
            if let comment = thing as? Comment {
                let html = comment.bodyHtml.preprocessedHTMLStringBeforeNSAttributedStringParsing
                do {
                    let attr = try NSMutableAttributedString(data: html.data(using: .unicode)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
                    let font = UIFont(name: ".SFUIText-Light", size: 12) ?? UIFont.systemFont(ofSize: 12)
                    let attr2 = attr.reconstruct(with: font, color: UIColor.black(), linkColor: UIColor.blue())
                    return CellContent(string:attr2, width:width - 25, hasRelies:false)
                } catch {
                    return CellContent(string:AttributedString(string: ""), width:width - 25, hasRelies:false)
                }
            } else {
                return CellContent(string:"more", width:width - 25, hasRelies:false)
            }
        }
    }
    
    func vote(_ direction: VoteDirection) {
        if let link = self.link {
            do {
                try session?.setVote(direction, name: link.name, completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let check):
                        print(check)
                    }
                })
            } catch { print(error) }
        }
    }
    
    func save(_ save: Bool) {
        if let link = self.link {
            do {
                try session?.setSave(save, name: link.name, completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let check):
                        print(check)
                    }
                })
            } catch { print(error) }
        }
    }
    
    func hide(_ hide: Bool) {
        if let link = self.link {
            do {
                try session?.setHide(hide, name: link.name, completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let check):
                        print(check)
                    }
                })
            } catch { print(error) }
        }
    }
    
    func downVote(_ sender: AnyObject?) {
        vote(.down)
    }
    
    func upVote(_ sender: AnyObject?) {
        vote(.up)
    }
    
    func cancelVote(_ sender: AnyObject?) {
        vote(.none)
    }
    
    func doSave(_ sender: AnyObject?) {
        save(true)
    }
    
    func doUnsave(_ sender: AnyObject?) {
        save(false)
    }
    
    func doHide(_ sender: AnyObject?) {
        hide(true)
    }
    
    func doUnhide(_ sender: AnyObject?) {
        hide(false)
    }
    
    func updateToolbar() {
        var items: [UIBarButtonItem] = []
        let space = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target: nil, action: nil)
        if let link = self.link {
            items.append(space)
            // voting status
            switch(link.likes) {
            case .up:
                items.append(UIBarButtonItem(image: UIImage(named: "thumbDown"), style:.plain, target: self, action: #selector(CommentViewController.downVote(_:))))
                items.append(space)
                items.append(UIBarButtonItem(image: UIImage(named: "thumbUpFill"), style:.plain, target: self, action: #selector(CommentViewController.cancelVote(_:))))
            case .down:
                items.append(UIBarButtonItem(image: UIImage(named: "thumbDownFill"), style:.plain, target: self, action: #selector(CommentViewController.cancelVote(_:))))
                items.append(space)
                items.append(UIBarButtonItem(image: UIImage(named: "thumbUp"), style:.plain, target: self, action: #selector(CommentViewController.upVote(_:))))
            case .none:
                items.append(UIBarButtonItem(image: UIImage(named: "thumbDown"), style:.plain, target: self, action: #selector(CommentViewController.downVote(_:))))
                items.append(space)
                items.append(UIBarButtonItem(image: UIImage(named: "thumbUp"), style:.plain, target: self, action: #selector(CommentViewController.upVote(_:))))
            }
            items.append(space)
            
            // save
            if link.saved {
                items.append(UIBarButtonItem(image: UIImage(named: "favoriteFill"), style:.plain, target: self, action:#selector(CommentViewController.doUnsave(_:))))
            } else {
                items.append(UIBarButtonItem(image: UIImage(named: "favorite"), style:.plain, target: self, action:#selector(CommentViewController.doSave(_:))))
            }
            items.append(space)
            
            // hide
            if link.hidden {
                items.append(UIBarButtonItem(image: UIImage(named: "eyeFill"), style:.plain, target: self, action: #selector(CommentViewController.doUnhide(_:))))
            } else {
                items.append(UIBarButtonItem(image: UIImage(named: "eye"), style:.plain, target: self, action: #selector(CommentViewController.doHide(_:))))
            }
            items.append(space)
            
            // comment button
            items.append(UIBarButtonItem(image: UIImage(named: "comment"), style:.plain, target: nil, action: nil))
            items.append(space)
        }
        self.toolbarItems = items
    }
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "UZTextViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.tableView.register(UINib(nibName: "UZTextViewWithMoreButtonCell", bundle: nil), forCellReuseIdentifier: "MoreCell")
        
        updateToolbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isToolbarHidden = false
        print(UIApplication.shared().keyWindow?.frame)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let link = self.link {
            do {
                try session?.getArticles(link, sort:.top, comments:nil, completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let tuple):
                        let startDepth = 1
                        let listing = tuple.1
                        let incomming = listing.children
                            .flatMap({ $0 as? Comment })
                            .reduce([], combine: {
                                return $0 + extendAllReplies(in: $1, current: startDepth)
                            })
                            .map({$0.0})
                        
                        self.comments += incomming
                        
                        var time = timeval(tv_sec: 0, tv_usec: 0)
                        gettimeofday(&time, nil)
                        self.contents += self.updateStrings(incomming)
                        var time2 = timeval(tv_sec: 0, tv_usec: 0)
                        gettimeofday(&time2, nil)
                        let r = Double(time2.tv_sec) + Double(time2.tv_usec) / 1000000.0 - Double(time.tv_sec) - Double(time.tv_usec) / 1000000.0
                        print("\(Int(r*1000))[msec]")
                        
                        self.paginator = listing.paginator

                        DispatchQueue.main.async(execute: { () -> Void in
                            self.tableView.reloadData()
                        })
                    }
                })
            } catch { print(error) }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contents.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if contents.indices ~= (indexPath as NSIndexPath).row {
            return contents[(indexPath as NSIndexPath).row].textHeight
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = nil
        if contents.indices ~= (indexPath as NSIndexPath).row {
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
            if let cell = cell as? UZTextViewCell {
                cell.delegate = self
                cell.textView?.attributedString = contents[(indexPath as NSIndexPath).row].attributedString
                cell.content = comments[indexPath.row]
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if comments.indices ~= indexPath.row {
            if let more = comments[indexPath.row] as? More, link = self.link {
                print(more)
                do {
                    try session?.getMoreChildren(more.children, link:link, sort:.new, completion: { (result) -> Void in
                        switch result {
                        case .failure(let error):
                            print(error)
                        case .success(let list):
                            print(list)
                            
                            DispatchQueue.main.async(execute: { () -> Void in
                                let startDepth = 1
                                let incomming = list
                                    .flatMap({ $0 as? Comment })
                                    .reduce([], combine: {
                                        return $0 + extendAllReplies(in: $1, current: startDepth)
                                    })
                                    .map({$0.0})
                                
                                self.comments.remove(at: indexPath.row)
                                self.contents.remove(at: indexPath.row)
                                
                                self.comments.insert(contentsOf: incomming, at: indexPath.row)
                                self.contents.insert(contentsOf: self.updateStrings(incomming), at: indexPath.row)
                                self.tableView.reloadData()
                            })
                            
                        }
                    })
                } catch { print(error) }
            }
        }
    }
    
    func pushedMoreButton(_ cell: UZTextViewCell) {
    }
}
