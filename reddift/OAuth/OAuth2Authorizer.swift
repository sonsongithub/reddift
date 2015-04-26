//
//  OAuth2Authorizer.swift
//  reddift
//
//  Created by sonson on 2015/04/12.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

extension NSURLComponents {
    func dictionary() -> [String:String] {
        var parameters:[String:String] = [:]
        for queryItem in self.queryItems as! [NSURLQueryItem] {
            parameters[queryItem.name] = queryItem.value
        }
        return parameters
    }
}

class OAuth2Authorizer {
    private var state = ""
    /**
    Singleton model.
    */
    static let sharedInstance = OAuth2Authorizer()
    
    func challengeWithAllScopes() {
        self.challengeWithScopes(["identity", "edit", "flair", "history", "modconfig", "modflair", "modlog", "modposts", "modwiki", "mysubreddits", "privatemessages", "read", "report", "save", "submit", "subscribe", "vote", "wikiedit", "wikiread"])
    }
    
    func challengeWithScopes(scopes:[String]) {
        var scopeString = ""
        for scope in scopes {
            scopeString = scopeString + scope + ","
        }
        var range = Range<String.Index>(start: advance(scopeString.endIndex, -1), end: scopeString.endIndex)
        scopeString.removeRange(range)
        
        let length = 64
        let mutableData = NSMutableData(length: Int(length))
        if let data = mutableData {
            let result = SecRandomCopyBytes(kSecRandomDefault, length, UnsafeMutablePointer<UInt8>(data.mutableBytes))
            self.state = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
            let authorizationURL = NSURL(string:"https://www.reddit.com/api/v1/authorize.compact?client_id=" + Config.sharedInstance.clientID + "&response_type=code&state=" + self.state + "&redirect_uri=" + Config.sharedInstance.redirectURI + "&duration=permanent&scope=" + scopeString)!
            UIApplication.sharedApplication().openURL(authorizationURL)
        }
    }
    
    func receiveRedirect(url:NSURL, completion:(Result<OAuth2Token>)->Void) -> Bool{
        var parameters:[String:String] = [:]
        var currentState = self.state
        self.state = ""
        if (url.scheme == Config.sharedInstance.redirectURIScheme) {
            if let temp = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)?.dictionary() {
                parameters = temp
            }
        }
        if let code = parameters["code"], state = parameters["state"] {
            if count(code) > 0 && state == currentState {
                OAuth2Token.getOAuth2Token(code, completion:completion)
                return true
            }
        }
        return false
    }
}
