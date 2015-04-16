//
//  Session+comment.swift
//  reddift
//
//  Created by sonson on 2015/04/17.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

extension Session {
    func comment(link:Link, completion:(comments:[Comment], error:NSError?)->Void) -> NSURLSessionDataTask {
        var parameter:[String:String] = ["sort":"top"]
    
        var URLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"comments/" + link.id, parameter:parameter, method:"GET", token:token)
        
        let task = URLSession.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    completion(subreddits:[], paginator: nil, error: error)
                })
            }
            else {
                var jsonError:NSError? = nil
                var json22:AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error:&jsonError)
                println(json22)
                if let json = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error:&jsonError) as? [String:AnyObject] {
                    
                        println(json)
//                    let (subreddits, paginator) = self.parseSubredditListJSON(json)
//                    if subreddits.count > 0 && paginator != nil {
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            completion(subreddits:subreddits, paginator:paginator, error:nil)
//                        })
//                    }
//                    else {
//                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                            completion(subreddits:[], paginator:nil, error:NSError.errorWithCode(0, userinfo: ["error":"Can not get any contents expectedly."]))
//                        })
//                    }
                }
                else {
                }
            }
        })
        task.resume()
        return task
    }
}
