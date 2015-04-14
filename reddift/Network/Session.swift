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
    
    init(token:OAuth2Token) {
        self.token = token
    }
    
    func profile(completion:(profile:Account?, error:NSError?)->Void) -> NSURLSessionDataTask {
        let URL = NSURL(string: "https://oauth.reddit.com/api/v1/me")!
        var URLRequest = NSMutableURLRequest(URL: URL)
        URLRequest.setOAuth2Token(token)
        URLRequest.HTTPMethod = "GET"
        URLRequest.setUserAgentForReddit()
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            
            if let httpResponse:NSHTTPURLResponse = response as? NSHTTPURLResponse {
                println(httpResponse.allHeaderFields)
            }
            
            if let aData = data {
                var result = NSString(data: aData, encoding: NSUTF8StringEncoding) as! String
                println(result)
                if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
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
//    func front(paginator:Paginator?, completion:(links:[Link], error:NSError?)->Void) -> NSURLSessionDataTask {
//        let URL = NSURL(string: "https://oauth.reddit.com/new")!
//        var URLRequest = NSMutableURLRequest(URL: URL)
//        URLRequest.setOAuth2Token(token)
//        URLRequest.HTTPMethod = "GET"
//        URLRequest.setUserAgentForReddit()
//        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
//        let task = session.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
//            if let httpResponse:NSHTTPURLResponse = response as? NSHTTPURLResponse {
//                println(httpResponse.allHeaderFields)
//            }
//            
//            if let aData = data {
//                var result = NSString(data: aData, encoding: NSUTF8StringEncoding) as! String
//                println(result)
//                if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
//                }
//            }
//        })
//        task.resume()
//        return task
//    }
}
