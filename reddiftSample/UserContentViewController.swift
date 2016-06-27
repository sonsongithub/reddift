//
//  UserContentViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/27.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import reddift

class UserContentViewController: UITableViewController {
    var session: Session?
    var userContent: UserContent = .comments
    var source: [Thing] = []
    var contents: [CellContent] = []
    
    func updateStrings() {
        contents.removeAll(keepingCapacity:true)
        contents = source.map {(obj) -> CellContent in
            if let comment = obj as? Comment {
                let html = comment.bodyHtml.preprocessedHTMLStringBeforeNSAttributedStringParsing
                do {
                    let attr = try AttributedString(data: html.data(using: String.Encoding.unicode)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
                    let attr2 = attr.reconstruct(with: UIFont.systemFont(ofSize: 12), color: UIColor.black(), linkColor: UIColor.blue())
                    return CellContent(string:attr2, width:self.view.frame.size.width - 25, hasRelies:false)
                } catch {
                    return CellContent(string:AttributedString(string: ""), width:self.view.frame.size.width - 25, hasRelies:false)
                }
            } else if let link = obj as? Link {
                return CellContent(string:link.title, width:self.view.frame.size.width)
            } else {
                return CellContent(string:"Other?", width:self.view.frame.size.width)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib: UINib = UINib(nibName: "UZTextViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        if let name: String = (session.flatMap { (session) -> Token? in
            return session.token
        }
        .flatMap { (token) -> String? in
            return token.name
        }) as String? {
            do {
                try session?.getUserContent(name, content:userContent, sort:.new, timeFilterWithin:.all, paginator:Paginator(), completion: { (result) -> Void in
                    switch result {
                    case .failure:
                        print(result.error)
                    case .success(let listing):
                        self.source += listing.children
                        self.updateStrings()
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
        return contents.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == (contents.count - 1) {
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if source.indices ~= indexPath.row {
            let obj = source[indexPath.row]
            if let comment = obj as? Comment {
                do {
                    try session?.getInfo([comment.linkId], completion: { (result) -> Void in
                        switch result {
                        case .failure:
                            print(result.error)
                        case .success(let listing):
                            if listing.children.count == 1 {
                                if let link = listing.children[0] as? Link {
                                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController {
                                        vc.session = self.session
                                        vc.link = link
                                        DispatchQueue.main.async(execute: { () -> Void in
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        })
                                    }
                                }
                            }
                        }
                    })
                } catch { print(error) }
            } else if let link = obj as? Link {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController {
                    vc.session = session
                    vc.link = link
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if contents.indices ~= (indexPath as NSIndexPath).row {
            return contents[(indexPath as NSIndexPath).row].textHeight
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        if let cell = cell as? UZTextViewCell {
            if contents.indices ~= (indexPath as NSIndexPath).row {
                cell.textView?.attributedString = contents[(indexPath as NSIndexPath).row].attributedString
            }
        }
        return cell
    }
}
