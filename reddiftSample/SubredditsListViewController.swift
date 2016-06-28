//
//  SubredditsListViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/16.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import reddift

class SubredditsListViewController: UITableViewController {
    var session: Session? = nil
    var subreddits: [Subreddit] = []
    var paginator = Paginator()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
		if self.subreddits.count == 0 {
            do {
                try session?.getUserRelatedSubreddit(.subscriber, paginator:paginator, completion: { (result) -> Void in
                    switch result {
                    case .failure:
                        print(result.error)
                    case .success(let listing):
                        self.subreddits += listing.children.flatMap({$0 as? Subreddit})
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
        return subreddits.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        if subreddits.indices ~= indexPath.row {
            let link = subreddits[indexPath.row]
            cell.textLabel?.text = link.title
        }

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToSubredditsViewController" {
            if let con = segue.destinationViewController as? LinkViewController {
                con.session = self.session
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    if subreddits.indices ~= indexPath.row {
                        con.subreddit = subreddits[indexPath.row]
                    }
                }
            }
        }
    }
}
