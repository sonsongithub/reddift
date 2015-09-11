//
//  NSMutableURLRequest+reddift.swift
//  reddift
//
//  Created by sonson on 2015/04/13.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

func parameterString(dictionary:[String:String])-> String {
    var buf = ""
    for (key, value) in dictionary {
        buf += "\(key)=\(value)&"
    }
    if buf.characters.count > 0 {
        let range = Range<String.Index>(start: buf.endIndex.advancedBy(-1), end: buf.endIndex)
        buf.removeRange(range)
    }
    return buf
}

extension NSMutableURLRequest {
    func setRedditBasicAuthentication() {
        let basicAuthenticationChallenge = Config.sharedInstance.clientID + ":"
        let data = basicAuthenticationChallenge.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Str = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        setValue("Basic " + base64Str, forHTTPHeaderField:"Authorization")
    }
    
    func setRedditBasicAuthentication(username username:String, password:String) {
        let basicAuthenticationChallenge = username + ":" + password
        let data = basicAuthenticationChallenge.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Str = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        setValue("Basic " + base64Str, forHTTPHeaderField:"Authorization")
    }
    
    func setOAuth2Token(token:Token?) {
        if let token = token {
            setValue("bearer " + token.accessToken, forHTTPHeaderField:"Authorization")
        }
    }
    
    func setUserAgentForReddit() {
        self.setValue(Config.sharedInstance.userAgent, forHTTPHeaderField: "User-Agent")
    }
    
    class func mutableOAuthRequestWithBaseURL(baseURL:String, path:String, method:String, token:Token?) -> NSMutableURLRequest {
        let URL = NSURL(string:baseURL + path)!
        let URLRequest = NSMutableURLRequest(URL: URL)
        URLRequest.setOAuth2Token(token)
        URLRequest.HTTPMethod = method
        URLRequest.setUserAgentForReddit()
        return URLRequest
    }
    
    class func mutableOAuthRequestWithBaseURL(baseURL:String, path:String, parameter:[String:String]?, method:String, token:Token?) -> NSMutableURLRequest {
		var params:[String:String] = [:]
		if let parameter = parameter {
			params = parameter
		}
        if method == "POST" {
            return mutableOAuthPostRequestWithBaseURL(baseURL, path:path, parameter:params, method:method, token:token)
        }
        else {
            return mutableOAuthGetRequestWithBaseURL(baseURL, path:path, parameter:params, method:method, token:token)
        }
    }
    
    class func mutableOAuthGetRequestWithBaseURL(baseURL:String, path:String, parameter:[String:String], method:String, token:Token?) -> NSMutableURLRequest {
        let param = parameterString(parameter)
        let URL = param.characters.isEmpty ? NSURL(string:baseURL + path)! : NSURL(string:baseURL + path + "?" + param)!
        let URLRequest = NSMutableURLRequest(URL: URL)
        URLRequest.setOAuth2Token(token)
        URLRequest.HTTPMethod = method
        URLRequest.setUserAgentForReddit()
        return URLRequest
    }
    
    class func mutableOAuthPostRequestWithBaseURL(baseURL:String, path:String, parameter:[String:String], method:String, token:Token?) -> NSMutableURLRequest {
        let URL = NSURL(string:baseURL + path)!
        let URLRequest = NSMutableURLRequest(URL: URL)
        URLRequest.setOAuth2Token(token)
        URLRequest.HTTPMethod = method
        let data = parameterString(parameter).dataUsingEncoding(NSUTF8StringEncoding)
        URLRequest.HTTPBody = data
        URLRequest.setUserAgentForReddit()
        return URLRequest
    }
}