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
	
	@IBAction func addAccount(_ sender: AnyObject) {
		try! OAuth2Authorizer.sharedInstance.challengeWithAllScopes()
	}
    
    func reload() {
        names.removeAll(keepingCapacity: false)
        names += OAuth2TokenRepository.savedNames
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(AccountViewController.didSaveToken(_:)), name: OAuth2TokenRepositoryDidSaveTokenName, object: nil)
        reload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        if names.indices ~= (indexPath as NSIndexPath).row {
            let name = names[(indexPath as NSIndexPath).row]
            cell.textLabel?.text = name
        }
        return cell
    }
	
    func didSaveToken(_ notification: Notification) {
        reload()
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if names.indices ~= (indexPath as NSIndexPath).row {
                do {
                    let name = names[(indexPath as NSIndexPath).row]
                    try OAuth2TokenRepository.removeToken(of: name)
                    names.remove(at: (indexPath as NSIndexPath).row)
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.endUpdates()
                } catch { print(error) }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToUserViewController" {
            if let con = segue.destination as? UserViewController {
                if let selectedIndexPath = tableView.indexPathForSelectedRow {
                    if names.indices ~= (selectedIndexPath as NSIndexPath).row {
                        let name = names[(selectedIndexPath as NSIndexPath).row]
                        do {
                            let token = try OAuth2TokenRepository.token(of: name)
                            con.session = Session(token: token)
//                            con.session?.setDummyExpiredToken()
                            UserDefaults.standard.set(name, forKey: "name")
                            UserDefaults.standard.synchronize()
                        } catch { print(error) }
                    }
                }
            }
        }
    }
}
