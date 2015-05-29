//
//  RDTOAuth2Token.swift
//  reddift
//
//  Created by sonson on 2015/04/11.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

let OAuth2TokenDidUpdate = "OAuth2TokenDidUpdate"

/**
OAuth2 token for access reddit.com API.
*/
public struct OAuth2Token : Token {
    public static var baseURL = "https://www.reddit.com/api/v1"
    public var accessToken = ""
    public var tokenType = ""
    public var _expiresIn = 0
    public var scope = ""
    public var refreshToken = ""
    public var name = ""
    public var expiresDate:NSTimeInterval = 0
    
    /**
    Time inteval the access token expires from being authorized.
    */
    public var expiresIn:Int {
        set (newValue) { _expiresIn = newValue; expiresDate = NSDate.timeIntervalSinceReferenceDate() + Double(_expiresIn) }
        get { return _expiresIn }
    }
    
    /**
    Initialize vacant OAuth2AppOnlyToken with JSON.
    */
    public init() {
        self.name = ""
        self.accessToken = ""
        self.tokenType = ""
        self.expiresIn = 0
        self.scope = ""
        self.refreshToken = ""
    }
    
    /**
    Initialize OAuth2AppOnlyToken with JSON.
    
    :param: json JSON as [String:AnyObject] should include "name", "access_token", "token_type", "expires_in", "scope" and "refresh_token".
    */
    public init(_ json:[String:AnyObject]) {
        self.name = json["name"] as? String ?? ""
        self.accessToken = json["access_token"] as? String ?? ""
        self.tokenType = json["token_type"] as? String ?? ""
        self.expiresIn = json["expires_in"] as? Int ?? 0
        self.scope = json["scope"] as? String ?? ""
        self.refreshToken = json["refresh_token"] as? String ?? ""
    }
    
    /**
    Create OAuth2Token object from JSON.
    
    :param: json JSON object as [String:AnyObject] must include "name", "access_token", "token_type", "expires_in", "scope" and "refresh_token". If it does not, returns Result<NSError>.
    :returns: OAuth2Token object includes a new access token.
    */
    static func tokenWithJSON(json:JSON) -> Result<OAuth2Token> {
        var token:OAuth2Token? = nil
        if let json = json as? JSONDictionary {
            if let temp1 = json["access_token"] as? String,
                temp2 = json["token_type"] as? String,
                temp3 = json["expires_in"] as? Int,
                temp4 = json["scope"] as? String,
                temp5 = json["refresh_token"] as? String {
                    return Result(value: OAuth2Token(json))
            }
        }
        return Result(error:ReddiftError.ParseAccessToken.error)
    }
    
    /**
    Create NSMutableURLRequest object to request getting an access token.
    
    :param: code The code which is obtained from OAuth2 redict URL at reddit.com.
    :returns: NSMutableURLRequest object to request your access token.
    */
    static func requestForOAuth(code:String) -> NSMutableURLRequest {
        var URL = NSURL(string: OAuth2Token.baseURL + "/access_token")!
        var request = NSMutableURLRequest(URL:URL)
        request.setRedditBasicAuthentication()
        var param = "grant_type=authorization_code&code=" + code + "&redirect_uri=" + Config.sharedInstance.redirectURI
        let data = param.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = data
        request.HTTPMethod = "POST"
        return request
    }
    
    /**
    Create request object for refreshing access token.
    
    :returns: NSMutableURLRequest object to request refreshing your access token.
    */
    func requestForRefreshing() -> NSMutableURLRequest {
        var URL = NSURL(string: OAuth2Token.baseURL + "/access_token")!
        var request = NSMutableURLRequest(URL:URL)
        request.setRedditBasicAuthentication()
        var param = "grant_type=refresh_token&refresh_token=" + refreshToken
        let data = param.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = data
        request.HTTPMethod = "POST"
        return request
    }
    
    /**
    Create request object for revoking access token.
    
    :returns: NSMutableURLRequest object to request revoking your access token.
    */
    func requestForRevoking() -> NSMutableURLRequest {
        var URL = NSURL(string: OAuth2Token.baseURL + "/revoke_token")!
        var request = NSMutableURLRequest(URL:URL)
        request.setRedditBasicAuthentication()
        var param = "token=" + accessToken + "&token_type_hint=access_token"
        let data = param.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = data
        request.HTTPMethod = "POST"
        return request
    }
    
    /**
    Request to refresh access token.
    
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func refresh(completion:(Result<OAuth2Token>)->Void) -> NSURLSessionDataTask {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(requestForRefreshing(), completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON
            switch result {
            case .Success:
                if var json = result.value as? [String:AnyObject] {
                    json["name"] = self.name
                    json["refresh_token"] = self.refreshToken
                    completion(OAuth2Token.tokenWithJSON(json))
                    return
                }
            case .Failure:
                if let error = result.error {
                    completion(Result(error: error))
                    return
                }
            }
            completion(Result(error: NSError.errorWithCode(0, "")))
        })
        task.resume()
        return task
    }
    
    /**
    Request to revoke access token.
    
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func revoke(completion:(Result<JSON>)->Void) -> NSURLSessionDataTask {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(requestForRevoking(), completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Request to get a new access token.
    
    :param: code Code to be confirmed your identity by reddit.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public static func getOAuth2Token(code:String, completion:(Result<OAuth2Token>)->Void) -> NSURLSessionDataTask {
        let session:NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(requestForOAuth(code), completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> OAuth2Token.tokenWithJSON
            switch result {
            case .Success:
                if let token = result.value {
                    token.getProfile({ (result) -> Void in
                        completion(result)
                    })
                }
            case .Failure:
                completion(result)
            }
        })
        task.resume()
        return task
    }
    
    /**
    Request to get user's own profile. Don't use this method after getting access token correctly.
    Use Session.getProfile instead of this.
    
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    func getProfile(completion:(Result<OAuth2Token>) -> Void) -> NSURLSessionDataTask? {
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/v1/me", method:"GET", token:self)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseDataInJSON_t2
            switch result {
            case .Success:
                if let profile = result.value as? Account {
                    var json:[String:AnyObject] = ["name":profile.name, "access_token":self.accessToken, "token_type":self.tokenType, "expires_in":self.expiresIn, "expires_date":self.expiresDate, "scope":self.scope, "refresh_token":self.refreshToken]
                    completion(OAuth2Token.tokenWithJSON(json))
                    return
                }
            case .Failure:
                if let error = result.error {
                    completion(Result(error: error))
                    return
                }
            }
            completion(Result(error: NSError.errorWithCode(0, "")))
        })
        task.resume()
        return task
    }
}
