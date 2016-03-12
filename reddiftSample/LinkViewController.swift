//
//  LinkViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/15.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import reddift

class LinkViewController: BaseLinkViewController, UISearchResultsUpdating, UISearchControllerDelegate, UIViewControllerPreviewingDelegate {
    var searchController: UISearchController? = nil
    var searchResultViewController: SearchResultViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = self.subreddit?.title
        
		sortTypes += [.Controversial, .Top]
		for sortType in sortTypes {
			sortTitles.append(sortType.path)
		}
        
        searchResultViewController = SearchResultViewController()
        searchResultViewController?.tableView.delegate = self
        searchResultViewController?.session = session
        searchResultViewController?.subreddit = subreddit
        searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController?.searchBar
        
        if let subreddit = self.subreddit {
            searchController?.searchBar.placeholder = subreddit.title
        } else {
            searchController?.searchBar.placeholder = "Search from all"
        }
        
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
		if self.links.count == 0 {
			load()
		}
        
        // support 3d touch
        if #available(iOS 9, *) {
            if traitCollection.forceTouchCapability == .Available {
                registerForPreviewingWithDelegate(self, sourceView: self.tableView)
            }
        }
    }
    
    @available(iOS, introduced=9.0)
    func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation: CGPoint) -> UIViewController? {
        let point = previewingContext.sourceView.convertPoint(viewControllerForLocation, toView: self.tableView)
        if let indexPath = tableView.indexPathForRowAtPoint(point) {
            if contents.indices ~= indexPath.row {
                let link = self.links[indexPath.row]
                if let con = self.storyboard?.instantiateViewControllerWithIdentifier("CommentViewController") as? CommentViewController {
                    con.session = session
                    con.subreddit = subreddit
                    con.link = link
                    return con
                }
            }
        }
        return nil
    }
    
    @available(iOS, introduced=9.0)
    func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController: UIViewController) {
        showViewController(commitViewController, sender: self)
    }
    
    func load() {
        if let seg = self.segmentedControl {
            if loading {
                return
            }
            loading = true
            do {
                try session?.getList(paginator, subreddit:subreddit, sort:sortTypes[seg.selectedSegmentIndex], timeFilterWithin:.All, completion: { (result) in
                    switch result {
                    case .Failure:
                        print(result.error)
                    case .Success(let listing):
                        self.links += listing.children.flatMap({$0 as? Link})
                        self.paginator = listing.paginator
                        self.updateStrings()
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.tableView.reloadData()
                            self.loading = false
                        })
                    }
                })
            } catch { print(error) }
        }
    }
    
    func segmentChanged(sender: AnyObject) {
        if let _ = sender as? UISegmentedControl {
            self.links.removeAll(keepCapacity: true)
            self.tableView.reloadData()
            self.paginator = Paginator()
            load()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.toolbarHidden = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToCommentViewController" {
            if let con = segue.destinationViewController as? CommentViewController {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    if links.indices ~= selectedIndexPath.row {
                        let link = links[selectedIndexPath.row]
                        con.session = session
                        con.subreddit = subreddit
                        con.link = link
                    }
                }
            }
        }
        if segue.identifier == "ToSubmitViewController" {
            if let nav = segue.destinationViewController as? UINavigationController {
                if let con = nav.visibleViewController as? SubmitViewController {
                    con.session = session
                    con.subreddit = subreddit
                }
            }
        }
    }
}

// MARK:

extension LinkViewController {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    }
}

// MARK:

extension LinkViewController {
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

extension LinkViewController {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
    }
}

// MARK:

extension LinkViewController {
    
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

// MARK:

extension LinkViewController {
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == self.tableView {
            if indexPath.row == (contents.count - 1) {
                if !paginator.isVacant {
                    load()
                }
            }
        }
        if let searchResultViewController = searchResultViewController {
            if tableView == searchResultViewController.tableView {
                if indexPath.row == (searchResultViewController.contents.count - 1) {
                    searchResultViewController.reload()
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var link: Link? = nil
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if tableView == self.tableView {
            if contents.indices ~= indexPath.row {
                link = self.links[indexPath.row]
            }
        }
        if let searchResultViewController = searchResultViewController {
            if tableView == searchResultViewController.tableView {
                if searchResultViewController.contents.indices ~= indexPath.row {
                    link = searchResultViewController.links[indexPath.row]
                }
            }
        }
        if let link = link {
            if let con = self.storyboard?.instantiateViewControllerWithIdentifier("CommentViewController") as? CommentViewController {
                con.session = session
                con.subreddit = subreddit
                con.link = link
                self.navigationController?.pushViewController(con, animated: true)
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == self.tableView {
            if contents.indices ~= indexPath.row {
                return contents[indexPath.row].textHeight
            }
        }
        if let searchResultViewController = searchResultViewController {
            if tableView == searchResultViewController.tableView {
                if searchResultViewController.contents.indices ~= indexPath.row {
                    return searchResultViewController.contents[indexPath.row].textHeight
                }
            }
        }
        return 0
    }
    
}
