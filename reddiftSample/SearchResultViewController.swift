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
    var originalViewController: LinkViewController? = nil
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            searchWithQuery(text)
        }
    }
    
    func searchWithQuery(_ query: String) {
        if loading {
            return
        }
        loading = true
        if previousQuery != query {
            paginator = Paginator()
            links.removeAll(keepingCapacity: false)
            contents.removeAll(keepingCapacity: false)
            self.tableView.reloadData()
        }
        
        previousQuery = query
        do {
            try session?.getSearch(self.subreddit, query: query, paginator:paginator, sort:.relevance, completion: { (result) -> Void in
                self.loading = false
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let listing):
                    self.links.append(contentsOf: listing.children.flatMap({$0 as? Link}))
                    self.paginator = listing.paginator
                    self.updateStrings()
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.tableView.reloadData()
                    })
                }
            })
        } catch { print(error) }
    }
    
    func reload() {
        if !previousQuery.isEmpty && !paginator.isVacant {
            searchWithQuery(previousQuery)
        }
    }
}


// MARK:

extension SearchResultViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
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
