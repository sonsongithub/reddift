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
    public var name = ""
    public var expiresDate:NSTimeInterval = 0
    
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
    
    public init(_ json:[String:AnyObject]) {
        self.name = json["name"] as? String ?? ""
        self.accessToken = json["access_token"] as? String ?? ""
        self.tokenType = json["token_type"] as? String ?? ""
        self.expiresIn = json["expires_in"] as? Int ?? 0
        self.scope = json["scope"] as? String ?? ""
        self.refreshToken = json["refresh_token"] as? String ?? ""
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
            let result = responseResult >>> parseResponse >>> decodeJSON
            var token:OAuth2AppOnlyToken? = nil
            switch result {
            case let .Success:
                if var json = result.value as? [String:AnyObject] {
                    json["name"] = username
                    token = OAuth2AppOnlyToken(json)
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