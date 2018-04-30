//
//  SubredditCellar.swift
//  reddift
//
//  Created by sonson on 2016/10/05.
//  Copyright © 2016年 sonson. All rights reserved.
//

import reddift
import Foundation

class SubredditCellar: LinkContainerCellar {
    /// Subreddit
    var subreddit = Subreddit(subreddit: "")
    
    /// Paginator object for paging.
    var paginator = Paginator()
    
    /// Loading flag
    var loading = false
    
    override func tryLoadingMessage() -> String {
        return "Try loading \(subreddit.displayName)"
    }
    
    override func loadingMessage() -> String {
        return "Loading \(subreddit.displayName)...."
    }
    
    /// Loading flag
    override var isLoading: Bool {
        get {
            return loading
        }
    }
    
    /**
     Initialize SubredditCellar.
     - parameter subredditName: To be written.
     - parameter delegate: To be written.
     - returns: To be written.
     */
    init(subreddit name: String, width newWidth: CGFloat, fontSize newFontSize: CGFloat) {
        super.init()
        subreddit = Subreddit(subreddit: name)
        width = newWidth
        fontSize = newFontSize
    }
    
    /**
     Initialize SubredditCellar.
     - parameter subredditName: To be written.
     - parameter delegate: To be written.
     - returns: To be written.
     */
    override init() {
    }
    
    deinit {
        print("SubredditContentsProvider - deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     Remove all objects from all mutable arraies of self.
     */
    func removeAllObjects() {
        self.containers.removeAll()
    }
    
    /**
     Append new obtained contents to self.
     - parameter listing: To be written.
     - parameter width: To be written.
     */
    func appendContentWithListing(listing: Listing, widthConstraint: CGFloat, atTheBeginning: Bool) {
        /// Create and layout Content objects.
        let newLinks: [Link] = listing.children.compactMap({ $0 as? Link })
        let newContainers: [LinkContainable] = newLinks.compactMap({
            LinkContainable.createContainer(with: $0, width: width)
        })
        
        let pre_count = containers.count
        let aft_count = containers.count + newContainers.count
        
        containers.append(contentsOf: newContainers)
        
        var indices: [IndexPath] = []
        for i in pre_count..<aft_count {
            let indexPath = IndexPath(row: i, section: 0)
            containers[i].prefetch(at: indexPath)
            indices.append(indexPath)
        }
        
        paginator = listing.paginator
        
        if atTheBeginning {
            postNotification(name: LinkContainerCellarDidLoadName, userInfo: [LinkContainerCellar.isAtTheBeginningKey: true, LinkContainerCellar.providerKey: self])
        } else {
            postNotification(name: LinkContainerCellarDidLoadName, userInfo: [LinkContainerCellar.insertIndicesKey: indices, LinkContainerCellar.providerKey: self])
        }
    }
    
    func postNotification(name: Notification.Name, userInfo: [String: Any]) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.loading = false
            NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
        })
    }
    
    /**
     Load Subreddit.
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
            try UIApplication.appDelegate()?.session?.getList(paginator, subreddit: subreddit, sort: .hot, timeFilterWithin: .month, completion: { (result) -> Void in
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
