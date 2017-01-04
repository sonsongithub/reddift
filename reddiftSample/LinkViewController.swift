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
        
        // code to write a test data, t5.json.
//        if let subreddit = self.subreddit {
//            do {
//                try self.session?.about(subreddit.displayName, completion: { (result) in
//                    switch result {
//                    case .failure:
//                        print(result.error ?? "error?")
//                    case .success(let r):
//                        print(r)
//                    }
//                })
//            } catch { print(error) }
//        }
        
		sortTypes += [.controversial, .top]
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
		segmentedControl?.addTarget(self, action: #selector(LinkViewController.segmentChanged(_:)), for: UIControlEvents.valueChanged)
		segmentedControl?.frame = CGRect(x: 0, y: 0, width: 300, height: 28)
		segmentedControl?.selectedSegmentIndex = 0
		
		let space = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target: nil, action: nil)
		let item = UIBarButtonItem(customView:self.segmentedControl!)
		self.toolbarItems = [space, item, space]
		if self.links.count == 0 {
			load()
		}
        
        // support 3d touch
        if #available(iOS 9, *) {
            if traitCollection.forceTouchCapability == .available {
                registerForPreviewing(with: self, sourceView: self.tableView)
            }
        }
    }
    
    @available(iOS, introduced:9.0)
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation: CGPoint) -> UIViewController? {
        let point = previewingContext.sourceView.convert(viewControllerForLocation, to: self.tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            if contents.indices ~= (indexPath as NSIndexPath).row {
                let link = self.links[indexPath.row]
                if let con = self.storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController {
                    con.session = session
                    con.subreddit = subreddit
                    con.link = link
                    return con
                }
            }
        }
        return nil
    }
    
    @available(iOS, introduced:9.0)
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit commitViewController: UIViewController) {
        show(commitViewController, sender: self)
    }
    
    func load() {
        if let seg = self.segmentedControl {
            if loading {
                return
            }
            loading = true
            do {
                try session?.getList(paginator, subreddit:subreddit, sort:sortTypes[seg.selectedSegmentIndex], timeFilterWithin:.all, completion: { (result) in
                    switch result {
                    case .failure:
                        print(result.error ?? "error?")
                    case .success(let listing):
                        self.links += listing.children.flatMap({$0 as? Link})
                        self.paginator = listing.paginator
                        self.updateStrings()
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.tableView.reloadData()
                            self.loading = false
                        })
                    }
                })
            } catch { print(error) }
        }
    }
    
    func segmentChanged(_ sender: AnyObject) {
        if let _ = sender as? UISegmentedControl {
            self.links.removeAll(keepingCapacity: true)
            self.tableView.reloadData()
            self.paginator = Paginator()
            load()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isToolbarHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToCommentViewController" {
            if let con = segue.destination as? CommentViewController {
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
            if let nav = segue.destination as? UINavigationController {
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }
}

// MARK:

extension LinkViewController {
    func present(_ searchController: UISearchController) {
    }
    
    func willPresent(_ searchController: UISearchController) {
    }
    
    func didPresent(_ searchController: UISearchController) {
    }
    
    func willDismiss(_ searchController: UISearchController) {
    }
    
    func didDismiss(_ searchController: UISearchController) {
        
    }
}

// MARK:

extension LinkViewController {
    @objc(updateSearchResultsForSearchController:) func updateSearchResults(for searchController: UISearchController) {
    }
}

// MARK:

extension LinkViewController {
    
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

// MARK:

extension LinkViewController {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            if (indexPath as NSIndexPath).row == (contents.count - 1) {
                if !paginator.isVacant {
                    load()
                }
            }
        }
        if let searchResultViewController = searchResultViewController {
            if tableView == searchResultViewController.tableView {
                if (indexPath as NSIndexPath).row == (searchResultViewController.contents.count - 1) {
                    searchResultViewController.reload()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var link: Link? = nil
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == self.tableView {
            if contents.indices ~= (indexPath as NSIndexPath).row {
                link = self.links[indexPath.row]
            }
        }
        if let searchResultViewController = searchResultViewController {
            if tableView == searchResultViewController.tableView {
                if searchResultViewController.contents.indices ~= (indexPath as NSIndexPath).row {
                    link = searchResultViewController.links[indexPath.row]
                }
            }
        }
        if let link = link {
            if let con = self.storyboard?.instantiateViewController(withIdentifier: "CommentViewController") as? CommentViewController {
                con.session = session
                con.subreddit = subreddit
                con.link = link
                self.navigationController?.pushViewController(con, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            if contents.indices ~= (indexPath as NSIndexPath).row {
                return contents[(indexPath as NSIndexPath).row].textHeight
            }
        }
        if let searchResultViewController = searchResultViewController {
            if tableView == searchResultViewController.tableView {
                if searchResultViewController.contents.indices ~= (indexPath as NSIndexPath).row {
                    return searchResultViewController.contents[(indexPath as NSIndexPath).row].textHeight
                }
            }
        }
        return 0
    }
    
}
