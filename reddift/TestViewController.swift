//
//  TestViewController.swift
//  reddift
//
//  Created by sonson on 2015/04/12.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class TestViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let URL:NSURL = NSURL(string: "https://www.reddit.com/hot.json")!;
		var URLRequest:NSMutableURLRequest = NSMutableURLRequest(URL: URL);
		URLRequest.HTTPMethod = "GET";
		URLRequest.setUserAgentForReddit();
		let session:NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration());
		let task:NSURLSessionDataTask = session.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
			
			if let httpResponse:NSHTTPURLResponse = response as? NSHTTPURLResponse {
				println(httpResponse.allHeaderFields);
			}
			
			if let aData = data {
				var result:String = NSString(data: aData, encoding: NSUTF8StringEncoding) as! String;
				println(result);
			}
			else {
			}
		});
		task.resume();
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if (indexPath.row == 0) {
			RDFOAuth2Authorizer.sharedInstance.challengeWithAllScopes();
		}
	}

	@IBAction func login(sender:AnyObject) {
		
	}
}
