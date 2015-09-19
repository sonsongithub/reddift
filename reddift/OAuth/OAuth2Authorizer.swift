//
//  OAuth2Authorizer.swift
//  reddift
//
//  Created by sonson on 2015/04/12.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

/**
Class for opening OAuth2 authorizing page and handling redirect URL.
This class is used by singleton model.
You must access this class's instance by only OAuth2Authorizer.sharedInstance.
*/
public class OAuth2Authorizer {
    private var state = ""
    /**
    Singleton model.
    */
    public static let sharedInstance = OAuth2Authorizer()
    
    /**
    Open OAuth2 page to try to authorize with all scopes in Safari.app.
    */
    public func challengeWithAllScopes() {
        self.challengeWithScopes(["identity", "edit", "flair", "history", "modconfig", "modflair", "modlog", "modposts", "modwiki", "mysubreddits", "privatemessages", "read", "report", "save", "submit", "subscribe", "vote", "wikiedit", "wikiread"])
    }
    
    /**
    Open OAuth2 page to try to authorize with user specified scopes in Safari.app.
    
    - parameter scopes: Scope you want to get authorizing. You can check all scopes at https://www.reddit.com/dev/api/oauth.
    */
    public func challengeWithScopes(scopes:[String]) {
        let commaSeparatedScopeString = commaSeparatedStringFromList(scopes)
        
        let length = 64
        let mutableData = NSMutableData(length: Int(length))
        if let data = mutableData {
            let _ = SecRandomCopyBytes(kSecRandomDefault, length, UnsafeMutablePointer<UInt8>(data.mutableBytes))
            self.state = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
            let authorizationURL = NSURL(string:"https://www.reddit.com/api/v1/authorize.compact?client_id=" + Config.sharedInstance.clientID + "&response_type=code&state=" + self.state + "&redirect_uri=" + Config.sharedInstance.redirectURI + "&duration=permanent&scope=" + commaSeparatedScopeString)!
#if os(iOS)
                UIApplication.sharedApplication().openURL(authorizationURL)
#elseif os(OSX)
                NSWorkspace.sharedWorkspace().openURL(authorizationURL)
#endif
        }
    }
    
    /**
    Handle URL object which is returned by OAuth2 page at reddit.com
    
    - parameter url: The URL from passed by reddit.com
    - parameter completion: Callback block is execeuted when the access token has been acquired using URL.
    - returns: Returns if the URL object is parsed correctly.
    */
    public func receiveRedirect(url:NSURL, completion:(Result<OAuth2Token>)->Void) -> Bool{
        var parameters:[String:String] = [:]
        let currentState = self.state
        self.state = ""
        if (url.scheme == Config.sharedInstance.redirectURIScheme) {
            if let temp = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)?.dictionary() {
                parameters = temp
            }
        }
        if let code = parameters["code"], state = parameters["state"] {
            if code.characters.count > 0 && state == currentState {
                do {
                    try OAuth2Token.getOAuth2Token(code, completion:completion)
                    return true
                }
                catch {
                    print(error)
                    return false
                }
            }
        }
        return false
    }
}
