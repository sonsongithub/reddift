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
    public static let baseURL = "https://www.reddit.com/api/v1"
    public let accessToken:String
    public let tokenType:String
    public let expiresIn:Int
    public let scope:String
    public let refreshToken:String
    public let name:String
    public let expiresDate:NSTimeInterval
    
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
    Create OAuth2Token object from JSON.
    
    - parameter json: JSON object as [String:AnyObject] must include "name", "access_token", "token_type", "expires_in", "scope" and "refresh_token". If it does not, returns Result<NSError>.
    - returns: OAuth2Token object includes a new access token.
    */
    static func tokenWithJSON(json:JSON) -> Result<OAuth2Token> {
        if let json = json as? JSONDictionary {
            if let _ = json["access_token"] as? String,
                _ = json["token_type"] as? String,
                _ = json["expires_in"] as? Int,
                _ = json["scope"] as? String,
                _ = json["refresh_token"] as? String {
                    return Result(value: OAuth2Token(json))
            }
        }
        return Result(error:ReddiftError.ParseAccessToken.error)
    }
    
    /**
    Create NSMutableURLRequest object to request getting an access token.
    
    - parameter code: The code which is obtained from OAuth2 redict URL at reddit.com.
    - returns: NSMutableURLRequest object to request your access token.
    */
    static func requestForOAuth(code:String) -> NSMutableURLRequest {
        let URL = NSURL(string: OAuth2Token.baseURL + "/access_token")!
        let request = NSMutableURLRequest(URL:URL)
        request.setRedditBasicAuthentication()
        let param = "grant_type=authorization_code&code=" + code + "&redirect_uri=" + Config.sharedInstance.redirectURI
        let data = param.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = data
        request.HTTPMethod = "POST"
        return request
    }
    
    /**
    Create request object for refreshing access token.
    
    - returns: NSMutableURLRequest object to request refreshing your access token.
    */
    func requestForRefreshing() -> NSMutableURLRequest {
        let URL = NSURL(string: OAuth2Token.baseURL + "/access_token")!
        let request = NSMutableURLRequest(URL:URL)
        request.setRedditBasicAuthentication()
        let param = "grant_type=refresh_token&refresh_token=" + refreshToken
        let data = param.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = data
        request.HTTPMethod = "POST"
        return request
    }
    
    /**
    Create request object for revoking access token.
    
    - returns: NSMutableURLRequest object to request revoking your access token.
    */
    func requestForRevoking() -> NSMutableURLRequest {
        let URL = NSURL(string: OAuth2Token.baseURL + "/revoke_token")!
        let request = NSMutableURLRequest(URL:URL)
        request.setRedditBasicAuthentication()
        let param = "token=" + accessToken + "&token_type_hint=access_token"
        let data = param.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = data
        request.HTTPMethod = "POST"
        return request
    }
    
    /**
    Request to refresh access token.
    
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func refresh(completion:(Result<OAuth2Token>)->Void) -> NSURLSessionDataTask? {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(requestForRefreshing(), completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap({(json:JSON) -> Result<[String:AnyObject]> in
                    if let json = json as? [String:AnyObject] {
                        return Result(value: json)
                    }
                    return Result(error: ReddiftError.Malformed.error)
                })
            switch result {
            case .Success(let json):
                var newJSON = json
                newJSON["name"] = self.name
                newJSON["refresh_token"] = self.refreshToken
                completion(OAuth2Token.tokenWithJSON(newJSON))
            case .Failure(let error):
                completion(Result(error: error))
            }
        })
        task.resume()
        return task
    }
    
    /**
    Request to revoke access token.
    
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func revoke(completion:(Result<JSON>)->Void) -> NSURLSessionDataTask? {
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(requestForRevoking(), completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Request to get a new access token.
    
    - parameter code: Code to be confirmed your identity by reddit.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public static func getOAuth2Token(code:String, completion:(Result<OAuth2Token>)->Void) -> NSURLSessionDataTask? {
        let session:NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(requestForOAuth(code), completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(OAuth2Token.tokenWithJSON)
            switch result {
            case .Success(let token):
                token.getProfile({ (result) -> Void in
                    completion(result)
                })
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
    
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    func getProfile(completion:(Result<OAuth2Token>) -> Void) -> NSURLSessionDataTask? {
        let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL("https://oauth.reddit.com", path:"/api/v1/me", method:"GET", token:self)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap({ (json:JSON) -> Result<Account> in
                    if let object = json as? JSONDictionary {
                        return resultFromOptional(Account(data:object), error: ReddiftError.ParseThingT2.error)
                    }
                    return Result(error: ReddiftError.Malformed.error)
                })
            switch result {
            case .Success(let profile):
                let json:[String:AnyObject] = ["name":profile.name, "access_token":self.accessToken, "token_type":self.tokenType, "expires_in":self.expiresIn, "expires_date":self.expiresDate, "scope":self.scope, "refresh_token":self.refreshToken]
                completion(OAuth2Token.tokenWithJSON(json))
            case .Failure(let error):
                completion(Result(error: error))
            }
        })
        task.resume()
        return task
    }
}
