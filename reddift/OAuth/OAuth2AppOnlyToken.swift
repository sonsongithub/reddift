//
//  OAuth2AppOnlyToken.swift
//  reddift
//
//  Created by sonson on 2015/05/05.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

/**
OAuth2Token extension to authorize without a user context.
This class is private and for only unit testing because "Installed app" is prohibited from using "Application Only OAuth" scheme, that is without user context.
*/
class OAuth2AppOnlyToken : OAuth2Token {
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override init(accessToken:String, tokenType:String, expiresIn:Int, scope:String, refreshToken:String) {
        super.init(accessToken: accessToken, tokenType: tokenType, expiresIn: expiresIn, scope: scope, refreshToken: refreshToken)
    }
    
    /**
    Create NSMutableURLRequest object to request getting an access token.
    
    :param: code The code which is obtained from OAuth2 redict URL at reddit.com.
    
    :returns: NSMutableURLRequest object to request your access token.
    */
    class func requestForOAuth2AppOnly(#username:String, password:String, clientID:String, secret:String) -> NSMutableURLRequest {
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
    class func tokenWithJSON(json:JSON) -> Result<OAuth2AppOnlyToken> {
        var token:OAuth2AppOnlyToken? = nil
        if let temp1 = json["access_token"] as? String,
            temp2 = json["token_type"] as? String,
            temp3 = json["expires_in"] as? Int,
            temp4 = json["scope"] as? String {
                token = OAuth2AppOnlyToken(accessToken:temp1, tokenType:temp2, expiresIn:temp3, scope:temp4, refreshToken:"")
        }
        return resultFromOptional(token, NSError(domain: "com.sonson.reddift", code: 1, userInfo: ["description":"Failed to parse t2 JSON in order to create OAuth2Token."]))
    }
    
    /**
    Request to get a new access token.
    
    :param: code Code to be confirmed your identity by reddit.
    :param: completion The completion handler to call when the load request is complete.
    
    :returns: Data task which requests search to reddit.com.
    */
    class func getOAuth2AppOnlyToken(#username:String, password:String, clientID:String, secret:String, completion:(Result<OAuth2AppOnlyToken>)->Void) -> NSURLSessionDataTask {
        let session:NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let request = requestForOAuth2AppOnly(username:username, password:password, clientID:clientID, secret:secret)
        let task = session.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> self.tokenWithJSON
            completion(result)
        })
        task.resume()
        return task
    }
}