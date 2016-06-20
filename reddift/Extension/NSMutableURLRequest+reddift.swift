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
                let value = allHTTPHeaderFields[$0]!.replacingOccurrences(of: "\"", with: "\\\"")
                command += " --header \"\(key): \(value)\""
            })
        }
        if let url = self.url {
            command += " '\(url.absoluteString)'"
        }
        command += " -X \(self.httpMethod)"
        if let data = self.httpBody {
            if var str = String(data: data, encoding: String.Encoding.utf8) {
                str = str.replacingOccurrences(of: "\"", with: "\\\"")
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
        let data = basicAuthenticationChallenge.data(using: String.Encoding.utf8)!
        let base64Str = data.base64EncodedString(NSData.Base64EncodingOptions.encoding64CharacterLineLength)
        setValue("Basic " + base64Str, forHTTPHeaderField:"Authorization")
    }
    
    func setRedditBasicAuthentication(username:String, password:String) {
        let basicAuthenticationChallenge = username + ":" + password
        let data = basicAuthenticationChallenge.data(using: String.Encoding.utf8)!
        let base64Str = data.base64EncodedString(NSData.Base64EncodingOptions.encoding64CharacterLineLength)
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
        guard let incomingURL = NSURL(string:baseURL + path) else { return nil }
        let URLRequest = NSMutableURLRequest(url: incomingURL as URL)
        URLRequest.setOAuth2Token(token: token)
        URLRequest.httpMethod = method
        URLRequest.setUserAgentForReddit()
#if _TEST
        print("curl command:\n\(URLRequest.curl())")
#endif
        return URLRequest
    }
    //Necessary paramater rename. WATCH OUT!
    class func mutableOAuthRequestWithBaseURL(baseURL:String, path:String, data:NSData, method:String, token:Token?) -> NSMutableURLRequest? {
        if method == "POST" || method == "PATCH" || method == "PUT" {
            guard let incomingURL = NSURL(string:baseURL + path) else { return nil }
            let URLRequest = NSMutableURLRequest(url: incomingURL as URL)
            URLRequest.setOAuth2Token(token: token)
            URLRequest.httpMethod = method
            URLRequest.httpBody = data as Data
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
            return mutableOAuthPostRequestWithBaseURL(baseURL: baseURL, path:path, parameter:parameter ?? [:], method:method, token:token)
        }
        else {
            return mutableOAuthGetRequestWithBaseURL(baseURL: baseURL, path:path, parameter:parameter ?? [:], method:method, token:token)
        }
    }
    
    class func mutableOAuthGetRequestWithBaseURL(baseURL:String, path:String, parameter:[String:String], method:String, token:Token?) -> NSMutableURLRequest? {
        let param = parameter.URLQueryString()
        guard let incomingURL = param.characters.isEmpty ? NSURL(string:baseURL + path) : NSURL(string:baseURL + path + "?" + param) else { return nil }
        let URLRequest = NSMutableURLRequest(url: incomingURL as URL)
        URLRequest.setOAuth2Token(token: token)
        URLRequest.httpMethod = method
        URLRequest.setUserAgentForReddit()
#if _TEST
        print("curl command:\n\(URLRequest.curl())")
#endif
        return URLRequest
    }
    
    class func mutableOAuthPostRequestWithBaseURL(baseURL:String, path:String, parameter:[String:String], method:String, token:Token?) -> NSMutableURLRequest? {
        guard let incomingURL = NSURL(string:baseURL + path) else { return nil }
        let URLRequest = NSMutableURLRequest(url: incomingURL as URL)
        URLRequest.setOAuth2Token(token: token)
        URLRequest.httpMethod = method
        let data = parameter.URLQueryString().data(using: String.Encoding.utf8)
        URLRequest.httpBody = data
        URLRequest.setUserAgentForReddit()
#if _TEST
        print(URLRequest.curl())
#endif
        return URLRequest
    }
}
