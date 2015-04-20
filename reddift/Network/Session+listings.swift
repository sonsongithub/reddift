//
//  Session+listings.swift
//  reddift
//
//  Created by sonson on 2015/04/15.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

extension Session {
    
    func parseThing(json:[String:AnyObject], depth:Int) -> (AnyObject?, Paginator?) {
        if let data = json["data"] as? [String:AnyObject] {
//            println(data)
            println("----------------------------------------------------------------")
            for (key, value) in data {
//                println(key)
            }
            if let value = data["replies"] as? [String:AnyObject] {
                parseListing(value, depth:depth)
            }
//            if let keys = data.keys as? [String] {
//                for key in keys {
//                    println(key)
//                }
//            }
//            if let replies = data["replies"] as? [AnyObject] {
//                println(replies)
//            }
        }
        if let kind = json["kind"] as? String {
            // comment
            println("\(depth):\(kind)")
        }
        return (nil, nil)
    }
    
    func parseListing(json:[String:AnyObject], depth:Int) -> (AnyObject?, Paginator?) {
        if let data = json["data"] as? [String:AnyObject] {
            if let children = data["children"] as? [AnyObject] {
                for child in children {
                    if let child = child as? [String:AnyObject] {
                        parseJSON(child, depth: depth + 1)
                    }
                }
            }
        }
        return (nil, nil)
    }
    
    func parseJSON(json:AnyObject, depth:Int) -> (AnyObject?, Paginator?) {
        
        let kindDict = [
            "t1":"Comment",
            "t2":"Account",
            "t3":"Link",
            "t4":"Message",
            "t5":"Subreddit",
            "t6":"Award",
            "t8":"PromoCampaign"
        ]
        
        // array
        // json->[AnyObject]
        if let array = json as? [AnyObject] {
            for element in array {
                if let element = element as? [String:AnyObject] {
                    self.parseJSON(element, depth:depth)
                }
            }
        }
        // dictionary
        // json->[String:AnyObject]
        else if let json = json as? [String:AnyObject] {
            if let kind = json["kind"] as? String {
                if kind == "Listing" {
                    parseListing(json, depth:depth)
                }
                else {
                    parseThing(json, depth:depth)
                }
            }
        }
        
        return (nil, nil)
    }
    
    func parseLinkListJSON(json:[String:AnyObject]) -> ([Link], Paginator?) {
        if let kind = json["kind"] as? String, data = json["data"] as? [String:AnyObject] {
            if kind == "Listing" {
                if let children = data["children"] as? [AnyObject] {
                    var links:[Link] = []
                    let paginator = Paginator()
                    for obj in children {
                        if let obj = obj as? [String:AnyObject] {
                            if let kind = obj["kind"] as? String, link = obj["data"] as? [String:AnyObject] {
                                if kind == "t3" {
//                                    links.append(Link(json:link))
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
                    return (links, paginator)
                }
            }
        }
        return ([], nil)
    }
    
    func linkList(paginator:Paginator?, sortingType:ListingSortType, subreddit:Subreddit?, completion:(links:[Link], paginator:Paginator?, error:NSError?)->Void) -> NSURLSessionDataTask {
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
                    completion(links:[], paginator: nil, error: error)
                })
            }
            else {
                if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
                    //                    println(json)
                    data.writeToFile("/Users/sonson/Desktop/links.json", atomically:false);
                    self.parseJSON(json, depth:0)
                    let (links, paginator) = self.parseLinkListJSON(json)
                    if links.count > 0 && paginator != nil {
                        paginator?.sortingType = sortingType;
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(links:links, paginator:paginator, error:nil)
                        })
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(links:links, paginator:paginator, error:NSError.errorWithCode(0, userinfo: ["error":"Can not get any contents expectedly."]))
                        })
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(links:[], paginator: nil, error:NSError.errorWithCode(0, userinfo: ["error":"Can not parse response object."]))
                    })
                }
            }
        })
        task.resume()
        return task
    }
}
