//
//  NSMutableURLRequest+reddift.swift
//  reddift
//
//  Created by sonson on 2015/04/13.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

extension NSMutableURLRequest {
    class func redditBasicAuthenticationURLRequest(URL:NSURL) -> NSMutableURLRequest {
        var URLRequest:NSMutableURLRequest = NSMutableURLRequest(URL: URL)
        var basicAuthenticationChallenge:String = Config.sharedInstance.clientID + ":"
        let data:NSData = basicAuthenticationChallenge.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Str = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        URLRequest.setValue("Basic " + base64Str, forHTTPHeaderField:"Authorization")
        return URLRequest
    }
    
    func setUserAgentForReddit() {
        self.setValue(Config.sharedInstance.userAgent, forHTTPHeaderField: "User-Agent")
    }
}