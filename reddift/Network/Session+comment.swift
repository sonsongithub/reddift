//
//  Session+comment.swift
//  reddift
//
//  Created by sonson on 2015/04/17.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

extension Session {
	func downloadComment(link:Link, completion:(object:AnyObject?, error:NSError?)->Void) -> NSURLSessionDataTask {
        var parameter:[String:String] = ["sort":"hot", "depth":"2"]
    
        var URLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"comments/" + link.id, parameter:parameter, method:"GET", token:token)
        
        let task = URLSession.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            
			NSThread.sleepForTimeInterval(2)
			
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
					completion(object:nil, error: error)
                })
            }
            else {
                var jsonError:NSError? = nil
				if let json = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error:&jsonError) as? [AnyObject] {
					var object:AnyObject? = Parser.parseJSON(json, depth: 0)
					if let object:AnyObject = object {
						dispatch_async(dispatch_get_main_queue(), { () -> Void in
							completion(object:object, error:nil)
						})
					}
					else {
						dispatch_async(dispatch_get_main_queue(), { () -> Void in
							completion(object:nil, error:NSError.errorWithCode(0, userinfo: ["error":"Can not get any contents expectedly."]))
						})
					}
                }
				else {
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						completion(object:nil, error:NSError.errorWithCode(0, userinfo: ["error":"This is not JSON object."]))
					})
                }
            }
        })
        task.resume()
        return task
    }
}
