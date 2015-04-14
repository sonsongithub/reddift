//
//  AccountViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/13.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class AccountViewController: UITableViewController {
	var names:[String] = []
	
	@IBAction func addAccount(sender:AnyObject) {
		OAuth2Authorizer.sharedInstance.challengeWithAllScopes()
	}
    
    func reload() {
        names.removeAll(keepCapacity: false)
        names += OAuth2TokenRepository.savedNamesInKeychain()
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSaveToken:", name: OAuth2TokenRepositoryDidSaveToken, object: nil)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        if indices(names) ~= indexPath.row {
            let name:String = names[indexPath.row]
            cell.textLabel?.text = name
        }
        return cell
    }
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indices(names) ~= indexPath.row {
            let name:String = names[indexPath.row]
            if let token = OAuth2TokenRepository.restoreFromKeychainWithName(name) {
                println(token)
            }
        }
	}
    
    func didSaveToken(notification:NSNotification) {
        reload()
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if indices(names) ~= indexPath.row {
                let name:String = names[indexPath.row]
                OAuth2TokenRepository.removeFromKeychainTokenWithName(name)
                names.removeAtIndex(indexPath.row)
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                tableView.endUpdates()
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToUserViewController" {
            if let con = segue.destinationViewController as? UserViewController {
                if let selectedIndexPath = tableView.indexPathForSelectedRow() {
                    if indices(names) ~= selectedIndexPath.row {
                        let name:String = names[selectedIndexPath.row]
                        if let token = OAuth2TokenRepository.restoreFromKeychainWithName(name) {
                            con.session = Session(token: token)
                        }
                    }
                }
            }
        }
    }
}
