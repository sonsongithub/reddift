//
//  RDTOAuth2Token.swift
//  reddift
//
//  Created by sonson on 2015/04/11.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class OAuth2Token : NSObject,NSCoding {
    var name = ""
    var accessToken = ""
    var tokenType = ""
    var _expiresIn = 0
    var expiresDate:NSTimeInterval = 0
    var scope = ""
    var refreshToken = ""
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(accessToken, forKey: "accessToken")
        aCoder.encodeObject(tokenType, forKey: "tokenType")
        aCoder.encodeObject(_expiresIn, forKey: "_expiresIn")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(scope, forKey: "scope")
        aCoder.encodeObject(refreshToken, forKey: "refreshToken")
    }
    
    required init(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        accessToken = aDecoder.decodeObjectForKey("accessToken") as! String
        tokenType = aDecoder.decodeObjectForKey("tokenType") as! String
        _expiresIn = aDecoder.decodeObjectForKey("_expiresIn") as! Int
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as! NSTimeInterval
        scope = aDecoder.decodeObjectForKey("scope") as! String
        refreshToken = aDecoder.decodeObjectForKey("refreshToken") as! String
    }
    
    init(accessToken:String, tokenType:String, expiresIn:Int, scope:String, refreshToken:String) {
        super.init()
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiresIn = expiresIn
        self.scope = scope
        self.refreshToken = refreshToken
    }
    
    var expiresIn:Int {
        set (newValue) {
            _expiresIn = newValue
            expiresDate = NSDate.timeIntervalSinceReferenceDate() + Double(_expiresIn)
        }
        get {
            return _expiresIn
        }
    }
    
    class func tokenWithJSON(json:[String:AnyObject]) -> OAuth2Token? {
        if let temp1 = json["access_token"] as? String {
            if let temp2 = json["token_type"] as? String {
                if let temp3 = json["expires_in"] as? Int {
                    if let temp4 = json["scope"] as? String {
                        if let temp5 = json["refresh_token"] as? String {
                            return OAuth2Token(accessToken:temp1, tokenType:temp2, expiresIn:temp3, scope:temp4, refreshToken:temp5)
                        }
                    }
                }
            }
        }
        return nil
    }
    
    func updateWithJSON(json:[String:AnyObject]) -> Bool {
        if let temp1 = json["access_token"] as? String {
            if let temp2 = json["token_type"] as? String {
                if let temp3 = json["expires_in"] as? Int {
                    if let temp4 = json["scope"] as? String {
                        accessToken = temp1
                        tokenType = temp2
                        expiresIn = temp3
                        scope = temp4
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func refresh(completion:(error:NSError?)->Void) -> NSURLSessionDataTask {
        var URL = NSURL(string: "https://www.reddit.com/api/v1/access_token")!
        var URLRequest = NSMutableURLRequest.redditBasicAuthenticationURLRequest(URL)
        
        var param = "grant_type=refresh_token&refresh_token=" + refreshToken
        let data = param.dataUsingEncoding(NSUTF8StringEncoding)
        URLRequest.HTTPBody = data
        URLRequest.HTTPMethod = "POST"
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let task = session.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            if (error != nil) {
                completion(error:error)
            }
            else if (error == nil) {
                var result = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
                println(result)
                if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
                    if self.updateWithJSON(json) {
                        completion(error:error)
                    }
                    else {
                        if let errorMessage = json["error"] as? String {
                            completion(error:NSError.errorWithCode(0, userinfo: ["error":errorMessage]))
                        }
                        else {
                            completion(error:NSError.errorWithCode(0, userinfo: ["error":"Can not parse response object."]))
                        }
                    }
                }
                else {
                    completion(error:error)
                }
            }
        })
        task.resume()
        return task
    }
    
    func revoke(completion:(success:Bool, token:OAuth2Token?, error:NSError?)->Void) {
        
    }
    
    class func restoreFromKeychainWithName(name:String) -> OAuth2Token? {
        let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
        if let data = keychain.getData(name) as NSData? {
            if let token = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? OAuth2Token {
                return token
            }
        }
        return nil
    }
    
    class func savedNamesInKeychain() -> [String] {
        var keys:[String] = []
        let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
        keys += keychain.allKeys()
        return keys
    }
    
    func saveIntoKeychain() {
        saveIntoKeychainWithName(name)
    }
    
    func saveIntoKeychainWithName(name:String) {
        if (count(name) > 0) {
            // save
            let data = NSKeyedArchiver.archivedDataWithRootObject(self)
            let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
            keychain.set(data, key:name)
        }
        else {
            println("Error:name property is empty.")
        }
    }
    
    func profile(completion:(profile:UserProfile?, error:NSError?)->Void) -> NSURLSessionDataTask {
        let URL = NSURL(string: "https://oauth.reddit.com/api/v1/me")!
        var URLRequest = NSMutableURLRequest(URL: URL)
        URLRequest.setValue("bearer " + accessToken, forHTTPHeaderField:"Authorization")
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
                    var profile = UserProfile(json:json)
                    completion(profile: profile, error: nil)
                }
                else {
                    completion(profile:nil, error:NSError.errorWithCode(0, userinfo: ["error":"Can not parse response object."]))
                }
            }
            else {
                completion(profile:nil, error:error)
            }
        })
        task.resume()
        return task
    }
    
    class func download(code:String, completion:(token:OAuth2Token?, error:NSError?)->Void) -> NSURLSessionDataTask {
        
        var URL = NSURL(string: "https://www.reddit.com/api/v1/access_token")!
        var URLRequest = NSMutableURLRequest.redditBasicAuthenticationURLRequest(URL)
        
        var param = "grant_type=authorization_code&code=" + code + "&redirect_uri=" + Config.sharedInstance.redirectURI
        let data = param.dataUsingEncoding(NSUTF8StringEncoding)
        URLRequest.HTTPBody = data
        URLRequest.HTTPMethod = "POST"
        
        let session:NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let task = session.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            if (error != nil) {
                completion(token:nil, error:error)
            }
            else if (error == nil) {
                var result = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
                println(result)
                if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
                    if let token = OAuth2Token.tokenWithJSON(json) as OAuth2Token? {
                        completion(token:token,  error:error)
                    }
                    else {
                        if let errorMessage:String = json["error"] as? String {
                            completion(token:nil, error:NSError.errorWithCode(0, userinfo: ["error":errorMessage]))
                        }
                        else {
                            completion(token:nil, error:NSError.errorWithCode(0, userinfo: ["error":"Can not parse response object."]))
                        }
                    }
                }
                else {
                    completion(token:nil, error:error)
                }
            }
        })
        task.resume()
        return task
    }
}
