//
//  AccountListViewController.swift
//  ired
//
//  Created by sonson on 2015/08/07.
//  Copyright © 2015年 sonson. All rights reserved.
//

import reddift
import UIKit

let OAuth2TokenRepositoryDidSaveTokenName = Notification.Name(rawValue: "OAuth2TokenRepositoryDidSaveTokenName")
let OAuth2TokenRepositoryDidUpdateTokenName = Notification.Name(rawValue: "OAuth2TokenRepositoryDidUpdateTokenName")

class AccountListViewController: UITableViewController {
    var names: [String] = []
    
    func reloadNames() {
        names.removeAll(keepingCapacity: false)
        names += OAuth2TokenRepository.savedNames
        
        // set default account when number of accounts is only one.
        if OAuth2TokenRepository.savedNames.count == 1 {
            UserDefaults.standard.set(names[0], forKey: "currentName")
            UserDefaults.standard.synchronize()
        }
        
        tableView.reloadData()
    }
    
    @IBAction func close(sender: AnyObject) {
        UIApplication.appDelegate()?.reloadSession()
        self.dismiss(animated: true) { () -> Void in
        }
    }
    
    @IBAction func logout(sender: AnyObject) {
        UserDefaults.standard.removeObject(forKey: "currentName")
        UserDefaults.standard.synchronize()
        tableView.reloadData()
    }
    
    @IBAction func add(sender: AnyObject) {
        do {
            try OAuth2Authorizer.sharedInstance.challengeWithAllScopes()
        } catch {
        }
    }
    
    @objc func didSaveToken(notification: NSNotification) {
        reloadNames()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(AccountListViewController.didSaveToken(notification:)), name: OAuth2TokenRepositoryDidSaveTokenName, object: nil)
        
        names.removeAll(keepingCapacity: false)
        names += OAuth2TokenRepository.savedNames
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath as IndexPath) as UITableViewCell
        cell.accessoryType = .none
        if names.indices ~= indexPath.row {
            let name: String = names[indexPath.row]
            cell.textLabel?.text = name
            
            if let currentName = UserDefaults.standard.object(forKey: "currentName") as? String {
                if name == currentName {
                    cell.accessoryType = .checkmark
                }
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if names.indices ~= indexPath.row {
            UserDefaults.standard.set(names[indexPath.row], forKey: "currentName")
            UserDefaults.standard.synchronize()
            updateCheckmark()
        }
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    func updateCheckmark() {
        if let currentName = UserDefaults.standard.object(forKey: "currentName") as? String {
            for cell in self.tableView.visibleCells {
                if cell.textLabel?.text == currentName {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if names.indices ~= indexPath.row {
                
                do {
                    let name: String = names[indexPath.row]
                    
                    try OAuth2TokenRepository.removeToken(of: name)
                    
                    if let currentName = UserDefaults.standard.object(forKey: "currentName") as? String {
                        if name == currentName {
                            // change current name
                            if OAuth2TokenRepository.savedNames.count > 0 {
                                let tempNames = OAuth2TokenRepository.savedNames
                                UserDefaults.standard.set(tempNames[0], forKey: "currentName")
                                UserDefaults.standard.synchronize()
                            } else {
                                UserDefaults.standard.removeObject(forKey: "currentName")
                                UserDefaults.standard.synchronize()
                            }
                        }
                    }
                    
                    names.remove(at: indexPath.row)
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
                    updateCheckmark()
                    tableView.endUpdates()
                } catch {
                }
            }
        }
    }

}
