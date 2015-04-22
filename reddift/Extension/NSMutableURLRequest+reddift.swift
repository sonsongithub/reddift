//
//  NSMutableURLRequest+reddift.swift
//  reddift
//
//  Created by sonson on 2015/04/13.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit


func parameterString(dictionary:[String:String])-> String {
    var buf = ""
    for (key, value) in dictionary {
        buf += "\(key)=\(value)&"
    }
    if count(buf) > 0 {
        var range = Range<String.Index>(start: advance(buf.endIndex, -1), end: buf.endIndex)
        buf.removeRange(range)
    }
    return buf
}

extension NSMutableURLRequest {
    func setRedditBasicAuthentication() {
        var basicAuthenticationChallenge = Config.sharedInstance.clientID + ":"
        let data = basicAuthenticationChallenge.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Str = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        setValue("Basic " + base64Str, forHTTPHeaderField:"Authorization")
    }
    
    func setOAuth2Token(token:OAuth2Token) {
        setValue("bearer " + token.accessToken, forHTTPHeaderField:"Authorization")
    }
    
    func setUserAgentForReddit() {
        self.setValue(Config.sharedInstance.userAgent, forHTTPHeaderField: "User-Agent")
    }
    
    class func mutableOAuthRequestWithBaseURL(baseURL:String, path:String, method:String, token:OAuth2Token) -> NSMutableURLRequest {
        let URL = NSURL(string:baseURL + path)!
        var URLRequest = NSMutableURLRequest(URL: URL)
        URLRequest.setOAuth2Token(token)
        URLRequest.HTTPMethod = method
        URLRequest.setUserAgentForReddit()
        return URLRequest
    }
    
    class func mutableOAuthRequestWithBaseURL(baseURL:String, path:String, parameter:[String:String], method:String, token:OAuth2Token) -> NSMutableURLRequest {
        if method == "POST" {
            return self.mutableOAuthPostRequestWithBaseURL(baseURL, path:path, parameter:parameter, method:method, token:token)
        }
        else {
            return self.mutableOAuthGetRequestWithBaseURL(baseURL, path:path, parameter:parameter, method:method, token:token)
        }
    }
    
    class func mutableOAuthGetRequestWithBaseURL(baseURL:String, path:String, parameter:[String:String], method:String, token:OAuth2Token) -> NSMutableURLRequest {
        let URL = NSURL(string:baseURL + path + "?" + parameterString(parameter))!
        var URLRequest = NSMutableURLRequest(URL: URL)
        URLRequest.setOAuth2Token(token)
        URLRequest.HTTPMethod = method
        URLRequest.setUserAgentForReddit()
        return URLRequest
    }
    
    class func mutableOAuthPostRequestWithBaseURL(baseURL:String, path:String, parameter:[String:String], method:String, token:OAuth2Token) -> NSMutableURLRequest {
        let URL = NSURL(string:baseURL + path)!
        var URLRequest = NSMutableURLRequest(URL: URL)
        URLRequest.setOAuth2Token(token)
        URLRequest.HTTPMethod = method
        let data = parameterString(parameter).dataUsingEncoding(NSUTF8StringEncoding)
        URLRequest.HTTPBody = data
        URLRequest.setUserAgentForReddit()
        return URLRequest
    }
}