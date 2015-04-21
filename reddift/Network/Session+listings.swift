//
//  Session+listings.swift
//  reddift
//
//  Created by sonson on 2015/04/15.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

extension Session {    
	func linkList(paginator:Paginator?, sortingType:ListingSortType, subreddit:Subreddit?, completion:(object:AnyObject?, error:NSError?)->Void) -> NSURLSessionDataTask {
        var parameter:[String:String] = [:]
        
        if let paginator = paginator {
            if paginator.sortingType == sortingType {
                parameter = paginator.parameters()
            }
        }
        
        var path = sortingType.path();
        
        if let subreddit = subreddit {
            path = "/r/\(subreddit.display_name)\(path)"
        }
        
        var URLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:path, parameter:parameter, method:"GET", token:token)
        
        let task = URLSession.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
					completion(object:nil, error: error)
                })
            }
            else {
                if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
					
					var object:AnyObject? = Parser.parseJSON(json, depth:0)
					
                    if object != nil {
						dispatch_async(dispatch_get_main_queue(), { () -> Void in
							completion(object:object, error: error)
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
                        completion(object:nil, error:NSError.errorWithCode(0, userinfo: ["error":"Can not parse response object."]))
                    })
                }
            }
        })
        task.resume()
        return task
    }
}
