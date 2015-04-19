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
    func parseSubredditListJSON(json:[String:AnyObject]) -> ([Subreddit], Paginator?) {
        if let kind = json["kind"] as? String, data = json["data"] as? [String:AnyObject] {
            if kind == "Listing" {
                if let children = data["children"] as? [AnyObject] {
                    var subreddits:[Subreddit] = []
                    let paginator = Paginator()
                    for obj in children {
                        if let obj = obj as? [String:AnyObject] {
                            if let kind = obj["kind"] as? String, link = obj["data"] as? [String:AnyObject] {
                                if kind == "t5" {
                                    subreddits.append(Subreddit(json:link))
                                }
                            }
                        }
                    }
                    if let modhash = data["modhash"] as? String {
                        println("modhash=> \(modhash)")
                    }
                    if let after = data["after"] as? String {
                        paginator.after = after
                    }
                    if let before = data["before"] as? String {
                        paginator.before = before
                    }
                    return (subreddits, paginator)
                }
            }
        }
        return ([], nil)
    }
    
    func subredditsMine(paginator:Paginator?, subredditsMineWhere:SubredditsMineWhere, completion:(subreddits:[Subreddit], paginator:Paginator?, error:NSError?)->Void) -> NSURLSessionDataTask {
        var parameter:[String:String] = [:]
        if let paginator = paginator {
            parameter = paginator.parameters()
        }
        var URLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:subredditsMineWhere.path(), parameter:parameter, method:"GET", token:token)

        let task = URLSession.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(subreddits:[], paginator: nil, error: error)
                })
            }
            else {
                if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
                    //                    println(json)
                    data.writeToFile("/Users/sonson/Desktop/subreddit.json", atomically:false);
                    self.parseJSON(json, depth:0)
                    let (subreddits, paginator) = self.parseSubredditListJSON(json)
                    if subreddits.count > 0 && paginator != nil {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(subreddits:subreddits, paginator:paginator, error:nil)
                        })
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(subreddits:[], paginator:nil, error:NSError.errorWithCode(0, userinfo: ["error":"Can not get any contents expectedly."]))
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