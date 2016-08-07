//
//  UserViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/14.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import reddift

class UserViewController: UITableViewController {
    var session: Session?
    @IBOutlet var expireCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateExpireCell(_ sender: AnyObject?) {
        print(Thread.isMainThread)
        if let token = session?.token {
            expireCell.detailTextLabel?.text = Date(timeIntervalSinceReferenceDate:token.expiresDate).description
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath as NSIndexPath).row == 2 && (indexPath as NSIndexPath).section == 0 {
            do {
                try self.session?.refreshToken({ (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let token):
                        print(token)
                        self.updateExpireCell(nil)
                    }
                })
            } catch { print(error) }
        }
        if (indexPath as NSIndexPath).row == 3 && (indexPath as NSIndexPath).section == 0 {
            do {
                try self.session?.revokeToken({ (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let token):
                        print(token)
                        let _ = self.navigationController?.popToRootViewController(animated: true)
                    }
                })
            } catch { print(error) }
        }
        
        if (indexPath as NSIndexPath).section == 3 {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserContentViewController") as? UserContentViewController {
                let content = [
                    UserContent.overview,
                    UserContent.submitted,
                    UserContent.comments,
                    UserContent.liked,
                    UserContent.disliked,
                    UserContent.hidden,
                    UserContent.saved,
                    UserContent.gilded
                ]
                vc.userContent = content[indexPath.row]
                vc.session = self.session
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateExpireCell(nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(session)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToProfileViewController" {
            if let con = segue.destination as? ProfileViewController {
                con.session = self.session
            }
        } else if segue.identifier == "ToFrontViewController" {
            if let con = segue.destination as? LinkViewController {
                con.session = self.session
            }
        } else if segue.identifier == "ToSubredditsListViewController" {
            if let con = segue.destination as? SubredditsListViewController {
                con.session = self.session
            }
        } else if segue.identifier == "ToSubredditsViewController" {
            if let con = segue.destination as? SubredditsViewController {
                con.session = self.session
            }
        } else if segue.identifier == "OpenInbox" {
			if let con = segue.destination as? MessageViewController {
				con.session = self.session
				con.messageWhere = .inbox
			}
		} else if segue.identifier == "OpenSent" {
			if let con = segue.destination as? MessageViewController {
				con.session = self.session
				con.messageWhere = .sent
			}
		} else if segue.identifier == "OpenUnread" {
			if let con = segue.destination as? MessageViewController {
				con.session = self.session
				con.messageWhere = .unread
			}
		}
    }
}
