//
//  ProfileViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/15.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    var session:Session?
    @IBOutlet var cell1:UITableViewCell?
    @IBOutlet var cell2:UITableViewCell?
    @IBOutlet var cell3:UITableViewCell?
    @IBOutlet var cell4:UITableViewCell?
    @IBOutlet var cell5:UITableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        session?.profile({ (profile:Account?, error) -> Void in
            println(profile)
            if let profile = profile as Account? {
                self.cell1?.detailTextLabel?.text = profile.name
                self.cell2?.detailTextLabel?.text = profile.id
                self.cell3?.detailTextLabel?.text = NSDate(timeIntervalSince1970: Double(profile.created)).description
                self.cell4?.detailTextLabel?.text = profile.comment_karma.description
                self.cell5?.detailTextLabel?.text = profile.link_karma.description
            }
        })
    }
}
