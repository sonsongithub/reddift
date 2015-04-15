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
}
