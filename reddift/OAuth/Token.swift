//
//  Token.swift
//  reddift
//
//  Created by sonson on 2015/05/28.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
Protocol for OAuthToken.
*/
public protocol Token {
    /// token
    var accessToken: String {get}
    /// the type of token
    var tokenType: String {get}
    var expiresIn: Int {get}
    var expiresDate: NSTimeInterval {get}
    var scope: String {get}
    var refreshToken: String {get}
    
    /// user name to identifiy token.
    var name: String {get}
    
    /// base URL of API
    static var baseURL: String {get}
    
    /// vacant token
    init()
    
    /// deserials Token from JSON data
    init(_ json: JSONDictionary)
}

extension Token {
    /**
    Returns json object
    
    - returns: Dictinary object containing JSON data.
    */
    func JSONObject() -> JSONDictionary {
        let dict: JSONDictionary = [
            "name":self.name,
            "access_token":self.accessToken,
            "token_type":self.tokenType,
            "expires_in":self.expiresIn,
            "expires_date":self.expiresDate,
            "scope":self.scope,
            "refresh_token":self.refreshToken
        ]
        return dict
    }
}
