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
    public static let baseURL = "https://www.reddit.com/api/v1"
    public let accessToken:String
    public let tokenType:String
    public let expiresIn:Int
    public let scope:String
    public let refreshToken:String
    public let name:String
    public let expiresDate:NSTimeInterval
    
    /**
    Time inteval the access token expires from being authorized.
    */
//    public var expiresIn:Int {
//        set (newValue) { _expiresIn = newValue; expiresDate = NSDate.timeIntervalSinceReferenceDate() + Double(_expiresIn) }
//        get { return _expiresIn }
//    }
    
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
        self.expiresDate = NSDate.timeIntervalSinceReferenceDate() + 0
    }
    
    /**
    Initialize OAuth2AppOnlyToken with JSON.
    
    - parameter json: JSON as [String:AnyObject] should include "name", "access_token", "token_type", "expires_in", "scope" and "refresh_token".
    */
    public init(_ json:[String:AnyObject]) {
        self.name = json["name"] as? String ?? ""
        self.accessToken = json["access_token"] as? String ?? ""
        self.tokenType = json["token_type"] as? String ?? ""
        let expiresIn = json["expires_in"] as? Int ?? 0
        self.expiresIn = expiresIn
        self.expiresDate = json["expires_date"] as? NSTimeInterval ?? NSDate.timeIntervalSinceReferenceDate() + Double(expiresIn)
        self.scope = json["scope"] as? String ?? ""
        self.refreshToken = json["refresh_token"] as? String ?? ""
    }
    
    /**
    Create NSMutableURLRequest object to request getting an access token.
    
    - parameter code: The code which is obtained from OAuth2 redict URL at reddit.com.
    - returns: NSMutableURLRequest object to request your access token.
    */
    public static func requestForOAuth2AppOnly(username username:String, password:String, clientID:String, secret:String) -> NSMutableURLRequest? {
        guard let URL = NSURL(string: "https://ssl.reddit.com/api/v1/access_token") else { return nil }
        let request = NSMutableURLRequest(URL:URL)
        request.setRedditBasicAuthentication(username:clientID, password:secret)
        let param = "grant_type=password&username=" + username + "&password=" + password
        let data = param.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = data
        request.HTTPMethod = "POST"
        return request
    }
    
    /**
    Request to get a new access token.
    
    - parameter code: Code to be confirmed your identity by reddit.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public static func getOAuth2AppOnlyToken(username username:String, password:String, clientID:String, secret:String, completion:(Result<Token>)->Void) throws -> NSURLSessionDataTask {
        let session:NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        guard let request = requestForOAuth2AppOnly(username:username, password:password, clientID:clientID, secret:secret)
            else { throw ReddiftError.URLError.error }
        let task = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap({(json:JSON) -> Result<[String:AnyObject]> in
                    if let json = json as? [String:AnyObject] {
                        return Result(value: json)
                    }
                    return Result(error: ReddiftError.Malformed.error)
                })
            var token:OAuth2AppOnlyToken? = nil
            switch result {
            case .Success(let json):
                var newJSON = json
                newJSON["name"] = username
                token = OAuth2AppOnlyToken(newJSON)
            default:
                break
            }
            completion(resultFromOptional(token, error:NSError.errorWithCode(0, "")))
        })
        task.resume()
        return task
    }
}