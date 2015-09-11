//
//  SearchResultViewController.swift
//  reddift
//
//  Created by sonson on 2015/05/03.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import reddift

class SearchResultViewController: BaseLinkViewController {
    var previousQuery = ""
    var originalViewController:LinkViewController? = nil
    
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
            paginator = Paginator()
            links.removeAll(keepCapacity: false)
            contents.removeAll(keepCapacity: false)
            self.tableView.reloadData()
        }
        
        previousQuery = query
        session?.getSearch(self.subreddit, query: query, paginator:paginator, sort:SearchSortBy.Relevance, completion: { (result) -> Void in
            self.loading = false
            switch result {
            case .Failure:
                print(result.error)
            case .Success(let listing):
                for obj in listing.children {
                    if let link = obj as? Link {
                        self.links.append(link)
                    }
                }
                self.paginator = listing.paginator
                self.updateStrings()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    func reload() {
        if !previousQuery.isEmpty && !paginator.isVacant {
            searchWithQuery(previousQuery)
        }
    }
}


// MARK:

extension SearchResultViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        if let cell = cell as? UZTextViewCell {
            if contents.indices ~= indexPath.row {
                cell.textView?.attributedString = contents[indexPath.row].attributedString
            }
        }
        return cell
    }
    
}

