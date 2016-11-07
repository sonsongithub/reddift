//
//  ProfileViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/15.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import reddift

class ProfileViewController: UITableViewController {
    var session: Session?
    @IBOutlet var cell1: UITableViewCell?
    @IBOutlet var cell2: UITableViewCell?
    @IBOutlet var cell3: UITableViewCell?
    @IBOutlet var cell4: UITableViewCell?
    @IBOutlet var cell5: UITableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            try session?.getProfile({ (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error.description)
                case .success(let account):
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.cell1?.detailTextLabel?.text = account.name
                        self.cell2?.detailTextLabel?.text = account.id
                        self.cell3?.detailTextLabel?.text = NSDate(timeIntervalSince1970: Double(account.created)).description
                        self.cell4?.detailTextLabel?.text = account.commentKarma.description
                        self.cell5?.detailTextLabel?.text = account.linkKarma.description
                    })
                }
            })
        } catch { print(error) }
    }
}
