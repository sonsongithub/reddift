//
//  Session.swift
//  reddift
//
//  Created by sonson on 2015/04/14.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class Session {
    let token:OAuth2Token
    let baseURL = "https://oauth.reddit.com/"
    let URLSession:NSURLSession
    
    var x_ratelimit_reset = 0
    var x_ratelimit_used = 0
    var x_ratelimit_remaining = 0
    
    init(token:OAuth2Token) {
        self.token = token
        self.URLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }
    
    func updateRateLimitWithURLResponse(response:NSURLResponse) {
        if let httpResponse:NSHTTPURLResponse = response as? NSHTTPURLResponse {
            if let temp = httpResponse.allHeaderFields["x-ratelimit-reset"] as? Int {
                x_ratelimit_reset = temp
            }
            if let temp = httpResponse.allHeaderFields["x-ratelimit-used"] as? Int {
                x_ratelimit_used = temp
            }
            if let temp = httpResponse.allHeaderFields["x-ratelimit-remaining"] as? Int {
                x_ratelimit_remaining = temp
            }
        }
    }
    
    func profile(completion:(profile:Account?, error:NSError?)->Void) -> NSURLSessionDataTask {
        var URLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/v1/me", method:"GET", token:token)
        
        let task = URLSession.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            if let aData = data {
                if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
                    println(json)
                    var profile = Account(json:json)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(profile: profile, error: nil)
                    })
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(profile:nil, error:NSError.errorWithCode(0, userinfo: ["error":"Can not parse response object."]))
                    })
                }
            }
            else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(profile:nil, error:error)
                })
            }
        })
        task.resume()
        return task
    }
    
    func parseFrontListJSON(json:[String:AnyObject]) -> ([Link], Paginator?) {
        if let kind = json["kind"] as? String, data = json["data"] as? [String:AnyObject] {
            if kind == "Listing" {
                if let children = data["children"] as? [AnyObject] {
                    var links:[Link] = []
                    let paginator = Paginator()
                    for obj in children {
                        if let obj = obj as? [String:AnyObject] {
                            if let kind = obj["kind"] as? String, link = obj["data"] as? [String:AnyObject] {
                                if kind == "t3" {
                                    links.append(Link(json:link))
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
    
    func front(paginator:Paginator?, completion:(links:[Link], paginator:Paginator?, error:NSError?)->Void) -> NSURLSessionDataTask {
        
        var parameter:[String:String] = [:]
        
        if let paginator = paginator {
            parameter = paginator.parameters()
        }
        
        var URLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/new", parameter:parameter, method:"GET", token:token)
        
        let task = URLSession.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(links:[], paginator: nil, error: error)
                })
            }
            else {
                if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
                    let (links, paginator) = self.parseFrontListJSON(json)
                    if links.count > 0 && paginator != nil {
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
