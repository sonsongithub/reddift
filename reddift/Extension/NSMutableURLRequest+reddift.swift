//
//  NSMutableURLRequest+reddift.swift
//  reddift
//
//  Created by sonson on 2015/04/13.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension NSMutableURLRequest {
    
    func curl() -> String {
        var command = "curl"
        if let allHTTPHeaderFields = allHTTPHeaderFields {
            allHTTPHeaderFields.keys.forEach({
                let key = $0
                let value = allHTTPHeaderFields[$0]!.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
                command += " --header \"\(key): \(value)\""
            })
        }
        if let url = self.URL {
            command += " '\(url.absoluteString)'"
        }
        command += " -X \(self.HTTPMethod)"
        if let data = self.HTTPBody {
            if var str = String(data: data, encoding: NSUTF8StringEncoding) {
                str = str.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
                command += " -d \"\(str)\""
            }
            else {
                command += " -d <CANNOT PARSE AS STRING DATA>"
            }
        }
        return command
    }
    
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
    
    class func mutableOAuthRequestWithBaseURL(baseURL:String, path:String, method:String, token:Token?) -> NSMutableURLRequest? {
        guard let URL = NSURL(string:baseURL + path) else { return nil }
        let URLRequest = NSMutableURLRequest(URL: URL)
        URLRequest.setOAuth2Token(token)
        URLRequest.HTTPMethod = method
        URLRequest.setUserAgentForReddit()
#if _TEST
        print("curl command:\n\(URLRequest.curl())")
#endif
        return URLRequest
    }
    
    class func mutableOAuthRequestWithBaseURL(baseURL:String, path:String, data:NSData, method:String, token:Token?) -> NSMutableURLRequest? {
        if method == "POST" || method == "PATCH" || method == "PUT" {
            guard let URL = NSURL(string:baseURL + path) else { return nil }
            let URLRequest = NSMutableURLRequest(URL: URL)
            URLRequest.setOAuth2Token(token)
            URLRequest.HTTPMethod = method
            URLRequest.HTTPBody = data
            URLRequest.setUserAgentForReddit()
#if _TEST
            print("curl command:\n\(URLRequest.curl())")
#endif
            return URLRequest
        }
        else { return nil }
    }
    
    class func mutableOAuthRequestWithBaseURL(baseURL:String, path:String, parameter:[String:String]?, method:String, token:Token?) -> NSMutableURLRequest? {
        if method == "POST" {
            return mutableOAuthPostRequestWithBaseURL(baseURL, path:path, parameter:parameter ?? [:], method:method, token:token)
        }
        else {
            return mutableOAuthGetRequestWithBaseURL(baseURL, path:path, parameter:parameter ?? [:], method:method, token:token)
        }
    }
    
    class func mutableOAuthGetRequestWithBaseURL(baseURL:String, path:String, parameter:[String:String], method:String, token:Token?) -> NSMutableURLRequest? {
        let param = parameter.URLQueryString()
        guard let URL = param.characters.isEmpty ? NSURL(string:baseURL + path) : NSURL(string:baseURL + path + "?" + param) else { return nil }
        let URLRequest = NSMutableURLRequest(URL: URL)
        URLRequest.setOAuth2Token(token)
        URLRequest.HTTPMethod = method
        URLRequest.setUserAgentForReddit()
#if _TEST
        print("curl command:\n\(URLRequest.curl())")
#endif
        return URLRequest
    }
    
    class func mutableOAuthPostRequestWithBaseURL(baseURL:String, path:String, parameter:[String:String], method:String, token:Token?) -> NSMutableURLRequest? {
        guard let URL = NSURL(string:baseURL + path) else { return nil }
        let URLRequest = NSMutableURLRequest(URL: URL)
        URLRequest.setOAuth2Token(token)
        URLRequest.HTTPMethod = method
        let data = parameter.URLQueryString().dataUsingEncoding(NSUTF8StringEncoding)
        URLRequest.HTTPBody = data
        URLRequest.setUserAgentForReddit()
#if _TEST
        print(URLRequest.curl())
#endif
        return URLRequest
    }
}