//
//  OAuth2AppOnlyToken.swift
//  reddift
//
//  Created by sonson on 2015/05/05.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
OAuth2Token extension to authorize without a user context.
This class is private and for only unit testing because "Installed app" is prohibited from using "Application Only OAuth" scheme, that is without user context.
*/
public struct OAuth2AppOnlyToken : Token {
    
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
    
    public func json() -> NSData? {
        let dict:[String:AnyObject] = ["name":name, "access_token":accessToken, "token_type":tokenType, "expires_in":_expiresIn, "expires_date":expiresDate, "scope":scope, "refresh_token":refreshToken]
        return NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.allZeros, error: nil)
    }
    
    mutating func setName(name:String) {
        self.name = name
    }
    
    /**
    Create NSMutableURLRequest object to request getting an access token.
    
    :param: code The code which is obtained from OAuth2 redict URL at reddit.com.
    
    :returns: NSMutableURLRequest object to request your access token.
    */
    public static func requestForOAuth2AppOnly(#username:String, password:String, clientID:String, secret:String) -> NSMutableURLRequest {
        var URL = NSURL(string: "https://ssl.reddit.com/api/v1/access_token")!
        var request = NSMutableURLRequest(URL:URL)
        request.setRedditBasicAuthentication(username:clientID, password:secret)
        var param = "grant_type=password&username=" + username + "&password=" + password
        let data = param.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = data
        request.HTTPMethod = "POST"
        return request
    }
    
    /**
    Create OAuth2Token object from JSON.
    
    :param: json JSON object.
    
    :returns: Result object. If succeeded, it includes OAuth2AppOnlyToken with a new access token.
    */
    public static func tokenWithJSON(json:JSON) -> Result<OAuth2AppOnlyToken> {
        var token:OAuth2AppOnlyToken? = nil
        if let json = json as? JSONDictionary {
            if let temp1 = json["access_token"] as? String,
                temp2 = json["token_type"] as? String,
                temp3 = json["expires_in"] as? Int,
                temp4 = json["scope"] as? String {
                    token = OAuth2AppOnlyToken(json)
            }
        }
        return resultFromOptional(token, ReddiftError.ParseAccessToken.error)
    }
    
    /**
    Request to get a new access token.
    
    :param: code Code to be confirmed your identity by reddit.
    :param: completion The completion handler to call when the load request is complete.
    
    :returns: Data task which requests search to reddit.com.
    */
    public static func getOAuth2AppOnlyToken(#username:String, password:String, clientID:String, secret:String, completion:(Result<Token>)->Void) -> NSURLSessionDataTask {
        let session:NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let request = requestForOAuth2AppOnly(username:username, password:password, clientID:clientID, secret:secret)
        let task = session.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> self.tokenWithJSON
            var token:OAuth2AppOnlyToken? = nil
            switch result {
            case let .Success:
                if var value:OAuth2AppOnlyToken = result.value {
                    value.setName(username)
                    token = value
                }
            default:
                break
            }
            completion(resultFromOptional(token, NSError.errorWithCode(0, "")))
        })
        task.resume()
        return task
    }
}