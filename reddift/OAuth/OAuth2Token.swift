//
//  RDTOAuth2Token.swift
//  reddift
//
//  Created by sonson on 2015/04/11.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

let OAuth2TokenDidUpdate = "OAuth2TokenDidUpdate"

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
        if let temp1 = json["access_token"] as? String,
               temp2 = json["token_type"] as? String,
               temp3 = json["expires_in"] as? Int,
               temp4 = json["scope"] as? String,
               temp5 = json["refresh_token"] as? String {
                return OAuth2Token(accessToken:temp1, tokenType:temp2, expiresIn:temp3, scope:temp4, refreshToken:temp5)
        }
        return nil
    }
    
    func updateWithJSON(json:[String:AnyObject]) -> Bool {
        if  let temp1 = json["access_token"] as? String,
                temp2 = json["token_type"] as? String,
                temp3 = json["expires_in"] as? Int,
                temp4 = json["scope"] as? String {
            accessToken = temp1
            tokenType = temp2
            expiresIn = temp3
            scope = temp4
            return true
        }
        return false
    }
    
    func refresh(completion:(error:NSError?)->Void) -> NSURLSessionDataTask {
        var URL = NSURL(string: "https://www.reddit.com/api/v1/access_token")!
        var URLRequest = NSMutableURLRequest(URL:URL)
        URLRequest.setRedditBasicAuthentication()
        
        var param = "grant_type=refresh_token&refresh_token=" + refreshToken
        let data = param.dataUsingEncoding(NSUTF8StringEncoding)
        URLRequest.HTTPBody = data
        URLRequest.HTTPMethod = "POST"
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let task = session.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(error:error)
                })
            }
            else if error == nil {
                var result = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
                if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
                    if self.updateWithJSON(json) {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            NSNotificationCenter.defaultCenter().postNotificationName(OAuth2TokenDidUpdate, object: nil)
                            completion(error:nil)
                        })
                    }
                    else {
                        if let errorMessage = json["error"] as? String {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(error:NSError.errorWithCode(0, userinfo: ["error":errorMessage]))
                            })
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(error:NSError.errorWithCode(0, userinfo: ["error":"Can not parse response object."]))
                            })
                        }
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(error:NSError.errorWithCode(0, userinfo: ["error":"Can not parse response object."]))
                    })
                }
            }
        })
        task.resume()
        return task
    }
    
    func revoke(completion:(error:NSError?)->Void) -> NSURLSessionDataTask {
        var URL = NSURL(string: "https://www.reddit.com/api/v1/revoke_token")!
        var URLRequest = NSMutableURLRequest(URL:URL)
        URLRequest.setRedditBasicAuthentication()
        var param = "token=" + accessToken + "&token_type_hint=access_token"
        let data = param.dataUsingEncoding(NSUTF8StringEncoding)
        URLRequest.HTTPBody = data
        URLRequest.HTTPMethod = "POST"
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let task = session.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            if let httpResponse:NSHTTPURLResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 204 {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(error:nil)
                    })
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(error:NSError.errorWithCode(0, userinfo: ["error":"Unknown error"]))
                    })
                }
            }
            else if error == nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(error:NSError.errorWithCode(0, userinfo: ["error":"Unknown error"]))
                })
            }
            else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(error:error)
                })
            }
        })
        task.resume()
        return task
    }
    
    func profile(completion:(profile:Account?, error:NSError?)->Void) -> NSURLSessionDataTask {
        let URL = NSURL(string: "https://oauth.reddit.com/api/v1/me")!
        var URLRequest = NSMutableURLRequest(URL: URL)
        URLRequest.setOAuth2Token(self)
        URLRequest.HTTPMethod = "GET"
        URLRequest.setUserAgentForReddit()
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            
            if let httpResponse:NSHTTPURLResponse = response as? NSHTTPURLResponse {
                println(httpResponse.allHeaderFields)
            }
            
            if let aData = data {
                var result = NSString(data: aData, encoding: NSUTF8StringEncoding) as! String
                if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
					var profile = Parser.parseDataInThing_t2(json)
					if let profile = profile as? Account {
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
    
    class func download(code:String, completion:(token:OAuth2Token?, error:NSError?)->Void) -> NSURLSessionDataTask {
        
        var URL = NSURL(string: "https://www.reddit.com/api/v1/access_token")!
        var URLRequest = NSMutableURLRequest(URL:URL)
        URLRequest.setRedditBasicAuthentication()
        
        var param = "grant_type=authorization_code&code=" + code + "&redirect_uri=" + Config.sharedInstance.redirectURI
        let data = param.dataUsingEncoding(NSUTF8StringEncoding)
        URLRequest.HTTPBody = data
        URLRequest.HTTPMethod = "POST"
        let session:NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let task = session.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(token:nil, error:error)
                })
            }
            else if (error == nil) {
                var result = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
                if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
                    if let token = OAuth2Token.tokenWithJSON(json) {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(token:token,  error:error)
                        })
                    }
                    else {
                        if let errorMessage:String = json["error"] as? String {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(token:nil, error:NSError.errorWithCode(0, userinfo: ["error":errorMessage]))
                            })
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(token:nil, error:NSError.errorWithCode(0, userinfo: ["error":"Can not parse response object."]))
                            })
                        }
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(token:nil, error:error)
                    })
                }
            }
        })
        task.resume()
        return task
    }
}
