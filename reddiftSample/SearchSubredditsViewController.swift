//
//  SearchSubredditsViewController.swift
//  reddift
//
//  Created by sonson on 2015/05/04.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import reddift

class SearchSubredditsViewController: BaseSubredditsViewController {
    var previousQuery = ""
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let text = searchBar.text {
            searchWithQuery(text)
        }
    }
    
    func searchWithQuery(query:String) {
        if loading {
            return
        }
        loading = true
        if previousQuery != query {
            paginator = nil
            subreddits.removeAll(keepCapacity: false)
            self.tableView.reloadData()
        }
        
        previousQuery = query
        session?.getSubredditSearch(query, paginator: paginator, completion: { (result) -> Void in
            self.loading = false
            switch result {
            case let .Failure:
                print(result.error)
            case let .Success:
                print(result.value)
                if let listing = result.value as? Listing {
                    for obj in listing.children {
                        if let subreddit = obj as? Subreddit {
                            self.subreddits.append(subreddit)
                        }
                    }
                    self.paginator = listing.paginator
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    func reload() {
        if !previousQuery.isEmpty && paginator != nil {
            searchWithQuery(previousQuery)
        }
    }
}


// MARK:

extension SearchSubredditsViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subreddits.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        if subreddits.indices ~= indexPath.row {
            cell.textLabel?.text = subreddits[indexPath.row].title
        }
        return cell
    }
    
}

