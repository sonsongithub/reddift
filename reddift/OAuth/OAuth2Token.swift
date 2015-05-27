//
//  RDTOAuth2Token.swift
//  reddift
//
//  Created by sonson on 2015/04/11.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

let OAuth2TokenDidUpdate = "OAuth2TokenDidUpdate"

public protocol Token {
    
    var accessToken: String {get}
    var tokenType: String {get}
    var _expiresIn: Int {get}
    var scope: String {get}
    var refreshToken: String {get}
    
    var name: String {get}
    var expiresDate: NSTimeInterval {get}
    
    static var baseURL: String {get}
    
    init(_ json:[String:AnyObject])
    func json() -> NSData?
}

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
    
    /// User name, which is used to save token into keychian.
    public var name = ""
    /// Date when the current access token expires.
    public var expiresDate:NSTimeInterval = 0
    
    public init(_ json:[String:AnyObject]) {
        self.name = json["name"] as? String ?? ""
        self.accessToken = json["access_token"] as? String ?? ""
        self.tokenType = json["token_type"] as? String ?? ""
        self._expiresIn = json["expires_in"] as? Int ?? 0
        self.expiresDate = json["expires_date"] as? NSTimeInterval ?? 0
        self.scope = json["scope"] as? String ?? ""
        self.refreshToken = json["refresh_token"] as? String ?? ""
    }
    
    public mutating func setName(name:String) {
        self.name = name
    }
    
    public func json() -> NSData? {
        let dict:[String:AnyObject] = ["name":name, "access_token":accessToken, "token_type":tokenType, "expires_in":_expiresIn, "expires_date":expiresDate, "scope":scope, "refresh_token":refreshToken]
        return NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.allZeros, error: nil)
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
    Create OAuth2Token object from JSON.
    
    :param: json JSON object.
    
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
    Update each property according to the new json object which is obtained from reddit.com.
    This method is used when your access token is refreshed by a refresh token.
    
    :param: json JSON object is parsed by NSJSONSerialization.JSONObjectWithData method.
    
    :returns: Result object. 
    */
    func updateWithJSON(json:JSON) -> Result<OAuth2Token> {
        if var json = json as? JSONDictionary {
            json["name"] = self.name
            if  let temp1 = json["access_token"] as? String,
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
    
    // MARK:
    
    /**
    Time inteval the access token expires from being authorized.
    */
    public var expiresIn:Int {
        set (newValue) {
            _expiresIn = newValue
            expiresDate = NSDate.timeIntervalSinceReferenceDate() + Double(_expiresIn)
        }
        get {
            return _expiresIn
        }
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
                if let json = result.value {
                    let r = self.updateWithJSON(json)
                    completion(r)
                }
            case .Failure:
                if let error = result.error {
                    completion(Result(error: error))
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
            completion(result)
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
    public func getProfile(completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/v1/me", method:"GET", token:self)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseDataInJSON_t2
            completion(result)
        })
        task.resume()
        return task
    }
}
