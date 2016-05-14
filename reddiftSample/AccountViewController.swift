//
//  AccountViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/13.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import reddift

class AccountViewController: UITableViewController {
	var names: [String] = []
	
	@IBAction func addAccount(sender: AnyObject) {
		try! OAuth2Authorizer.sharedInstance.challengeWithAllScopes()
	}
    
    func reload() {
        names.removeAll(keepCapacity: false)
        names += OAuth2TokenRepository.savedNamesInKeychain()
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AccountViewController.didSaveToken(_:)), name: OAuth2TokenRepositoryDidSaveToken, object: nil)
        reload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return names.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        if names.indices ~= indexPath.row {
            let name: String = names[indexPath.row]
            cell.textLabel?.text = name
        }
        return cell
    }
	
    func didSaveToken(notification: NSNotification) {
        reload()
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if names.indices ~= indexPath.row {
                do {
                    let name: String = names[indexPath.row]
                    try OAuth2TokenRepository.removeFromKeychainTokenWithName(name)
                    names.removeAtIndex(indexPath.row)
                    tableView.beginUpdates()
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    tableView.endUpdates()
                } catch { print(error) }
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToUserViewController" {
            if let con = segue.destinationViewController as? UserViewController {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    if names.indices ~= selectedIndexPath.row {
                        let name: String = names[selectedIndexPath.row]
                        do {
                            let token: OAuth2Token = try OAuth2TokenRepository.restoreFromKeychainWithName(name)
                            con.session = Session(token: token)
//                            con.session?.setDummyExpiredToken()
                        } catch { print(error) }
                    }
                }
            }
        }
    }
}
