//
//  SearchLinkCellar.swift
//  reddift
//
//  Created by sonson on 2016/10/07.
//  Copyright © 2016年 sonson. All rights reserved.
//

import reddift
import Foundation

class SearchLinkCellar: SubredditCellar {
    /// Query for Link search
    var query: String
    
    override func tryLoadingMessage() -> String {
        return "Try search with \(query)"
    }
    
    override func loadingMessage() -> String {
        return "Searching with \(query)...."
    }
    
    /**
     Initialize SearchLinkCellar.
     - parameter subredditName: To be written.
     - parameter delegate: To be written.
     - returns: To be written.
     */
    init(query aQuery: String, subreddit name: String?, width: CGFloat, fontSize: CGFloat) {
        query = aQuery
        super.init()
        self.width = width
        self.fontSize = fontSize
        if let name = name {
            subreddit = Subreddit(subreddit: name)
        }
    }
    
    /**
     Search contents.
     - parameter appending: To be written.
     - parameter width: To be written.
     */
    override func load(atTheBeginning: Bool) {
        /// Do nothing in case paginator is vacant and load subreddit to append contents.
        if self.paginator.isVacant && !atTheBeginning { return }
        /// Do nothing in case this controller is loading.
        if loading { return }
        do {
            loading = true
            try UIApplication.appDelegate()?.session?.getSearch(subreddit, query: query, paginator: paginator, sort: .new, completion: { (result) -> Void in
                switch result {
                case .failure(let error):
                    /// Callback
                    self.postNotification(name: LinkContainerCellarDidLoadName, userInfo: [LinkContainerCellar.errorKey: error, LinkContainerCellar.providerKey: self])
                case .success(let listing):
                    /// Clear all objects before load content from the beginning.
                    if atTheBeginning { self.removeAllObjects() }
                    
                    /// append new contents to self
                    self.appendContentWithListing(listing: listing, widthConstraint: self.width, atTheBeginning: atTheBeginning)
                }
            })
        } catch {
            let nserror = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "\(error)"])
            postNotification(name: LinkContainerCellarDidLoadName, userInfo: [LinkContainerCellar.errorKey: nserror, LinkContainerCellar.providerKey: self])
        }
    }
    
}
