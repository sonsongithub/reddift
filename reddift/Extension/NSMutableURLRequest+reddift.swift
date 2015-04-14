//
//  NSMutableURLRequest+reddift.swift
//  reddift
//
//  Created by sonson on 2015/04/13.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

extension NSMutableURLRequest {
    func setRedditBasicAuthentication() {
        var basicAuthenticationChallenge = Config.sharedInstance.clientID + ":"
        let data = basicAuthenticationChallenge.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Str = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        setValue("Basic " + base64Str, forHTTPHeaderField:"Authorization")
    }
    
    func setOAuth2Token(token:OAuth2Token) {
        setValue("bearer " + token.accessToken, forHTTPHeaderField:"Authorization")
    }
    
    func setUserAgentForReddit() {
        self.setValue(Config.sharedInstance.userAgent, forHTTPHeaderField: "User-Agent")
    }
}