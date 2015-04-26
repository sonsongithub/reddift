//
//  UserViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/14.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class UserViewController: UITableViewController {
    var session:Session?
    @IBOutlet var expireCell:UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateExpireCell(sender:AnyObject?) {
        println(NSThread.isMainThread())
        if let token = session?.token {
            expireCell.detailTextLabel?.text = NSDate(timeIntervalSinceReferenceDate:token.expiresDate).description
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        if indexPath.row == 2 && indexPath.section == 0 {
            if let token = session?.token{
                token.refresh({ (result) -> Void in
                    switch result {
                    case let .Error(error):
                        println(error.code)
                    case let .Value(box):
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.updateExpireCell(nil)
                            OAuth2TokenRepository.saveIntoKeychainToken(token)
                        })
                    }
                })
            }
        }
        if indexPath.row == 3 && indexPath.section == 0 {
            if let token = session?.token{
                token.revoke({ (result) -> Void in
                    switch result {
                    case let .Error(error):
                        println(error.code)
                    case let .Value(box):
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            OAuth2TokenRepository.removeFromKeychainTokenWithName(token.name)
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        })
                    }
                })
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        updateExpireCell(nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        println(session)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToProfileViewController" {
            if let con = segue.destinationViewController as? ProfileViewController {
                con.session = self.session
            }
        }
        else if segue.identifier == "ToFrontViewController" {
            if let con = segue.destinationViewController as? LinkViewController {
                con.session = self.session
            }
        }
        else if segue.identifier == "ToSubredditsListViewController" {
            if let con = segue.destinationViewController as? SubredditsListViewController {
                con.session = self.session
            }
        }
		else if segue.identifier == "OpenInbox" {
			if let con = segue.destinationViewController as? MessageViewController {
				con.session = self.session
				con.messageWhere = .Inbox
			}
		}
		else if segue.identifier == "OpenSent" {
			if let con = segue.destinationViewController as? MessageViewController {
				con.session = self.session
				con.messageWhere = .Sent
			}
		}
		else if segue.identifier == "OpenUnread" {
			if let con = segue.destinationViewController as? MessageViewController {
				con.session = self.session
				con.messageWhere = .Unread
			}
		}
    }
}
