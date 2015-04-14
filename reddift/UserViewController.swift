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
                token.refresh({ (error) -> Void in
                    self.updateExpireCell(nil)
                    OAuth2TokenRepository.saveIntoKeychainToken(token)
                })
            }
        }
        if indexPath.row == 3 && indexPath.section == 0 {
            if let token = session?.token{
                token.revoke({ (error) -> Void in
                    if error == nil {
                        OAuth2TokenRepository.removeFromKeychainTokenWithName(token.name)
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                })
            }
        }
        if indexPath.row == 0 && indexPath.section == 1 {
            session?.front(nil, completion: { (links, error) -> Void in
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        updateExpireCell(nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        println(session)
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ToProfileViewController" {
            if let con = segue.destinationViewController as? ProfileViewController {
                con.session = self.session
            }
        }
    }
}
