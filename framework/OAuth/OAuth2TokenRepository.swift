//
//  OAuth2TokenRepository.swift
//  reddift
//
//  Created by sonson on 2015/04/14.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
Repository to contain OAuth2 tokens for reddit.com based on "KeychanAccess".
You can manage mulitple accounts using this class.
OAuth2TokenRepository, is utility class, has only class method.
*/
public class OAuth2TokenRepository {
    /**
    Restores token for OAuth2 from Keychain.
    - parameter name: Specifies user name of token you want to restore from Keychain.
    - returns: OAuth2Token object.
    */
    public class func token(of name: String) throws -> OAuth2Token {
        let keychain = MiniKeychain(service:Config.sharedInstance.bundleIdentifier)
        do {
            let data = try keychain.data(of: name)
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary {
                return OAuth2Token(json)
            }
            throw ReddiftError.specifiedNameTokenNotFoundInKeychain as NSError
        } catch {
            throw error
        }
    }

    /**
    Restores user name list from Keychain.

    - returns: List contains user names that was used to save tokens.
    */
    public class var savedNames: [String] {
        let keychain = MiniKeychain(service: Config.sharedInstance.bundleIdentifier)
        do {
            return try keychain.keys()
        } catch {
            print(error)
            return []
        }
    }

    /**
    Saves OAuth2 token object into Keychain.

    - parameter token: OAuth2Token object, that must have valid user name which is used to save it into Keychain.
    */
    public class func save(token: OAuth2Token) throws {
        if token.name.isEmpty {
            throw ReddiftError.tokenNameIsInvalid as NSError
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: token.JSONObject, options: [])
            let keychain = MiniKeychain(service:Config.sharedInstance.bundleIdentifier)
            try keychain.save(key: token.name, data: data)
        } catch {
            throw error
        }
    }

    /**
    Saves OAuth2 token object into Keychain.

    - parameter token: OAuth2Token object.
    - parameter name: Valid user name which is used to save it into Keychain.
    */
    public class func save(token: OAuth2Token, of name: String) throws {
        if name.isEmpty {
            throw ReddiftError.tokenNameIsInvalid as NSError
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: token.JSONObject, options: [])
            let keychain = MiniKeychain(service:Config.sharedInstance.bundleIdentifier)
            try keychain.save(key: name, data: data)
        } catch {
            throw error
        }
    }

    /**
    Removes OAuth2 token whose user name is specified by the name parmeter from Keychain.

    - parameter name: Valid user name which is used to save it into Keychain.
    */
    public class func removeToken(of name: String) throws {
        if name.isEmpty {
            throw ReddiftError.tokenNameIsInvalid as NSError
        }
        let keychain = MiniKeychain(service:Config.sharedInstance.bundleIdentifier)
        keychain.delete(key: name)
    }
}
