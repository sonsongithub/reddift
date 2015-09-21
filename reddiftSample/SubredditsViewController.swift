//
//  SubredditsViewController.swift
//  reddift
//
//  Created by sonson on 2015/05/04.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import reddift

class SubredditsViewController: BaseSubredditsViewController, UISearchResultsUpdating, UISearchControllerDelegate {
    var searchController:UISearchController? = nil
    var searchResultViewController:SearchSubredditsViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sortTypes += [.Popular, .New, .Employee, .Gold]
        for sortType in sortTypes {
            sortTitles.append(sortType.title)
        }
        
        self.title = "Subreddits"
        
        searchResultViewController = SearchSubredditsViewController()
        searchResultViewController?.tableView.delegate = self
        searchResultViewController?.session = session
        searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController?.searchBar
        
        searchController?.delegate = self
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.delegate = searchResultViewController
        
        self.definesPresentationContext = true
        
        segmentedControl = UISegmentedControl(items:sortTitles)
        segmentedControl?.addTarget(self, action: "segmentChanged:", forControlEvents: UIControlEvents.ValueChanged)
        segmentedControl?.frame = CGRect(x: 0, y: 0, width: 300, height: 28)
        segmentedControl?.selectedSegmentIndex = 0
        
        let space = UIBarButtonItem(barButtonSystemItem:.FlexibleSpace, target: nil, action: nil)
        let item = UIBarButtonItem(customView:self.segmentedControl!)
        self.toolbarItems = [space, item, space]
        if self.subreddits.count == 0 {
            load()
        }
        self.navigationController?.toolbarHidden = false
    }
    
    func load() {
        if let seg = self.segmentedControl {
            if loading {
                return
            }
            loading = true
            do {
                try session?.getSubreddit(sortTypes[seg.selectedSegmentIndex], paginator:paginator, completion: { (result) in
                    switch result {
                    case .Failure:
                        print(result.error)
                    case .Success:
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
                            self.loading = false
                        })
                    }
                })
            }
            catch { print(error) }
        }
    }
    
    func segmentChanged(sender:AnyObject) {
        if let _ = sender as? UISegmentedControl {
            self.subreddits.removeAll(keepCapacity: true)
            self.tableView.reloadData()
            self.paginator = Paginator()
            load()
        }
    }
}


// MARK:

extension SubredditsViewController {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    }
}

// MARK:

extension SubredditsViewController {
    func presentSearchController(searchController: UISearchController) {
    }
    
    func willPresentSearchController(searchController: UISearchController) {
    }
    
    func didPresentSearchController(searchController: UISearchController) {
    }
    
    func willDismissSearchController(searchController: UISearchController) {
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        
    }
}

// MARK:

extension SubredditsViewController {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
    }
}

// MARK:

extension SubredditsViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subreddits.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        if subreddits.indices ~= indexPath.row {
            let subreddit = subreddits[indexPath.row]
            cell.textLabel?.text = subreddit.title
        }
        return cell
    }
    
}

// MARK:

extension SubredditsViewController {
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.tableView {
            if indexPath.row == (subreddits.count - 1) {
                if paginator != nil {
                    load()
                }
            }
        }
        if let searchResultViewController = searchResultViewController {
            if tableView == searchResultViewController.tableView {
                if indexPath.row == (searchResultViewController.subreddits.count - 1) {
                    searchResultViewController.reload()
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var subreddit:Subreddit? = nil
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView == self.tableView {
            if subreddits.indices ~= indexPath.row {
                subreddit = self.subreddits[indexPath.row]
            }
        }
        print(subreddit)
//        if let searchResultViewController = searchResultViewController {
//            if tableView == searchResultViewController.tableView {
//                if indices(searchResultViewController.contents) ~= indexPath.row {
//                    subreddit = searchResultViewController.links[indexPath.row]
//                }
//            }
//        }
//        if let link = link {
//            if let con = self.storyboard?.instantiateViewControllerWithIdentifier("CommentViewController") as? CommentViewController {
//                con.session = session
//                con.link = link
//                self.navigationController?.pushViewController(con, animated: true)
//            }
//        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
}