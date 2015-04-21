//
//  Session+subreddits.swift
//  reddift
//
//  Created by sonson on 2015/04/16.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

enum SubredditsMineWhere {
    case Contributor
    case Moderator
    case Subscriber
    
    func path () -> String {
        switch self{
            case SubredditsMineWhere.Contributor:
                return "/subreddits/mine/contributor"
            case SubredditsMineWhere.Moderator:
                return "/subreddits/mine/moderator"
            case SubredditsMineWhere.Subscriber:
                return "/subreddits/mine/subscriber"
            default :
                return ""
        }
    }
}

extension Session {
	func downloadSubreddit(paginator:Paginator?, completion:(object:AnyObject?, error:NSError?)->Void) -> NSURLSessionDataTask {
		return downloadSubredditWithMineWhere(SubredditsMineWhere.Subscriber, paginator: paginator, completion: completion)
	}
	
	func downloadSubredditWithMineWhere(mineWhere:SubredditsMineWhere, paginator:Paginator?, completion:(object:AnyObject?, error:NSError?)->Void) -> NSURLSessionDataTask {
        var parameter:[String:String] = [:]
        if let paginator = paginator {
            parameter = paginator.parameters()
        }
        var URLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:mineWhere.path(), parameter:parameter, method:"GET", token:token)

        let task = URLSession.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(object:nil, error: error)
                })
            }
            else {
                if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
					var obj:AnyObject? = Parser.parseJSON(json, depth:0)
					if let obj:AnyObject = obj {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(object:obj, error:nil)
                        })
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(object:nil, error:NSError.errorWithCode(0, userinfo: ["error":"Can not get any contents expectedly."]))
                        })
                    }
                }
                else {
                }
            }
        })
        task.resume()
        return task
    }
}