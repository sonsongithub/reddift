//
//  OAuth2Authorizer.swift
//  reddift
//
//  Created by sonson on 2015/04/12.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class OAuth2Authorizer {
    private var state:String = ""
    /**
    Singleton model.
    */
    class var sharedInstance: OAuth2Authorizer {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: OAuth2Authorizer? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = OAuth2Authorizer()
        }
        return Static.instance!
    }
    
    func challengeWithAllScopes() {
        self.challengeWithScopes(["identity", "edit", "flair", "history", "modconfig", "modflair", "modlog", "modposts", "modwiki", "mysubreddits", "privatemessages", "read", "report", "save", "submit", "subscribe", "vote", "wikiedit", "wikiread"])
    }
    
    func challengeWithScopes(scopes:[String]) {
        var scopeString:String = ""
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
            let authorizationURL:NSURL = NSURL(string:"https://www.reddit.com/api/v1/authorize.compact?client_id=" + Config.sharedInstance.clientID + "&response_type=code&state=" + self.state + "&redirect_uri=" + Config.sharedInstance.redirectURI + "&duration=permanent&scope=" + scopeString)!
            UIApplication.sharedApplication().openURL(authorizationURL)
        }
    }
    
    func receiveRedirect(url:NSURL, completion:(token:OAuth2Token?, error:NSError?)->Void) -> Bool{
        var code:String = ""
        var state:String = ""
        if (url.scheme == Config.sharedInstance.redirectURIScheme) {
            if let components:NSURLComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: true) {
                if let queryItems = components.queryItems as? [NSURLQueryItem] {
                    for queryItem in queryItems {
                        if (queryItem.name == "code") {
                            if let temp = queryItem.value {
                                code = temp
                            }
                        }
                        if (queryItem.name == "state") {
                            if let temp = queryItem.value {
                                state = temp
                            }
                        }
                    }
                }
            }
        }
        if (code != "" && state == self.state) {
            println(code)
            println(state)
            self.state = ""
            OAuth2Token.download(code, completion:completion)
            return true
        }
        return false
    }
}
