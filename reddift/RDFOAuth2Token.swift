//
//  RDTOAuth2Token.swift
//  reddift
//
//  Created by sonson on 2015/04/11.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class RDFOAuth2Token : NSObject,NSCoding {
    var name = ""
    var accessToken:String = ""
    var tokenType:String = ""
    var _expiresIn:Int = 0
    var expiresDate:NSTimeInterval = 0
    var scope:String = ""
    var refreshToken = ""
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.accessToken, forKey: "accessToken")
        aCoder.encodeObject(self.tokenType, forKey: "tokenType")
        aCoder.encodeObject(self._expiresIn, forKey: "_expiresIn")
        aCoder.encodeObject(self.expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(self.scope, forKey: "scope")
        aCoder.encodeObject(self.refreshToken, forKey: "refreshToken")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.accessToken = aDecoder.decodeObjectForKey("accessToken") as! String
        self.tokenType = aDecoder.decodeObjectForKey("tokenType") as! String
        self._expiresIn = aDecoder.decodeObjectForKey("_expiresIn") as! Int
        self.expiresDate = aDecoder.decodeObjectForKey("expiresDate") as! NSTimeInterval
        self.scope = aDecoder.decodeObjectForKey("scope") as! String
        self.refreshToken = aDecoder.decodeObjectForKey("refreshToken") as! String
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
            self._expiresIn = newValue
            self.expiresDate = NSDate.timeIntervalSinceReferenceDate() + Double(self._expiresIn)
        }
        get {
            return self._expiresIn
        }
    }
    
    class func tokenWithJSON(json:[String:AnyObject]) -> RDFOAuth2Token? {
        if let temp1 = json["access_token"] as? String {
            if let temp2 = json["token_type"] as? String {
                if let temp3 = json["expires_in"] as? Int {
                    if let temp4 = json["scope"] as? String {
                        if let temp5 = json["refresh_token"] as? String {
                            return RDFOAuth2Token(accessToken:temp1, tokenType:temp2, expiresIn:temp3, scope:temp4, refreshToken:temp5)
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
                        self.accessToken = temp1
                        self.tokenType = temp2
                        self.expiresIn = temp3
                        self.scope = temp4
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func refresh(completion:(error:NSError?)->Void) -> NSURLSessionDataTask {
        var URL:NSURL = NSURL(string: "https://www.reddit.com/api/v1/access_token")!
        var URLRequest:NSMutableURLRequest = NSMutableURLRequest.redditBasicAuthenticationURLRequest(URL)
        
        var param:String = "grant_type=refresh_token&refresh_token=" + self.refreshToken
        let data = param.dataUsingEncoding(NSUTF8StringEncoding)
        URLRequest.HTTPBody = data
        URLRequest.HTTPMethod = "POST"
        
        let session:NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let task:NSURLSessionDataTask = session.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            if (error != nil) {
                completion(error:error)
            }
            else if (error == nil) {
                var result:String = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
                println(result)
                if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
                    if self.updateWithJSON(json) {
                        completion(error:error)
                    }
                    else {
                        if let errorMessage:String = json["error"] as? String {
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
    
    func revoke(completion:(success:Bool, token:RDFOAuth2Token?, error:NSError?)->Void) {
        
    }
    
    class func restoreFromKeychainWithName(name:String) -> RDFOAuth2Token? {
        let keychain = Keychain(service:RDFConfig.sharedInstance.bundleIdentifier)
        if let data:NSData = keychain.getData(name) as NSData? {
            if let token:RDFOAuth2Token = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? RDFOAuth2Token {
                return token
            }
        }
        return nil
    }
    
    class func savedNamesInKeychain() -> [String] {
        var keys:[String] = []
        let keychain = Keychain(service:RDFConfig.sharedInstance.bundleIdentifier)
        keys += keychain.allKeys()
        return keys
    }
    
    func saveIntoKeychain() {
        self.saveIntoKeychainWithName(self.name)
    }
    
    func saveIntoKeychainWithName(name:String) {
        if (count(name) > 0) {
            // save
            let data:NSData = NSKeyedArchiver.archivedDataWithRootObject(self)
            let keychain = Keychain(service:RDFConfig.sharedInstance.bundleIdentifier)
            keychain.set(data, key:name)
        }
        else {
            println("Error:name property is empty.")
        }
    }
    
    func profile(completion:(profile:RDFUserProfile?, error:NSError?)->Void) -> NSURLSessionDataTask {
        let URL:NSURL = NSURL(string: "https://oauth.reddit.com/api/v1/me")!
        var URLRequest:NSMutableURLRequest = NSMutableURLRequest(URL: URL)
        URLRequest.setValue("bearer " + self.accessToken, forHTTPHeaderField:"Authorization")
        URLRequest.HTTPMethod = "GET"
        URLRequest.setUserAgentForReddit()
        let session:NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task:NSURLSessionDataTask = session.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            
            if let httpResponse:NSHTTPURLResponse = response as? NSHTTPURLResponse {
                println(httpResponse.allHeaderFields)
            }
            
            if let aData = data {
                var result:String = NSString(data: aData, encoding: NSUTF8StringEncoding) as! String
                println(result)
                if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
                    var profile:RDFUserProfile = RDFUserProfile(json:json)
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
    
    class func download(code:String, completion:(token:RDFOAuth2Token?, error:NSError?)->Void) -> NSURLSessionDataTask {
        
        var URL:NSURL = NSURL(string: "https://www.reddit.com/api/v1/access_token")!
        var URLRequest:NSMutableURLRequest = NSMutableURLRequest.redditBasicAuthenticationURLRequest(URL)
        
        var param:String = "grant_type=authorization_code&code=" + code + "&redirect_uri=" + RDFConfig.sharedInstance.redirectURI
        let data = param.dataUsingEncoding(NSUTF8StringEncoding)
        URLRequest.HTTPBody = data
        URLRequest.HTTPMethod = "POST"
        
        let session:NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let task:NSURLSessionDataTask = session.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            if (error != nil) {
                completion(token:nil, error:error)
            }
            else if (error == nil) {
                var result:String = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
                println(result)
                if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
                    if let token:RDFOAuth2Token = RDFOAuth2Token.tokenWithJSON(json) as RDFOAuth2Token? {
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
