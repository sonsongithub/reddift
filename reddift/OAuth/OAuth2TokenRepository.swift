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
    public class func restoreFromKeychainWithName(name: String) throws -> OAuth2Token {
        let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
        do {
            if let data = try keychain.getData(name), let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? JSONDictionary {
                return OAuth2Token(json)
            }
            throw ReddiftError.TokenNotfound.error
        } catch {
            throw error
        }
    }

    /**
    Restores user name list from Keychain.

    - returns: List contains user names that was used to save tokens.
    */
    public class func savedNamesInKeychain() -> [String] {
        var keys: [String] = []
        let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
        keys += keychain.allKeys()
        return keys
    }

    /**
    Saves OAuth2 token object into Keychain.

    - parameter token: OAuth2Token object, that must have valid user name which is used to save it into Keychain.
    */
    public class func saveIntoKeychainToken(token: OAuth2Token) throws {
        if token.name.isEmpty {
            throw ReddiftError.KeychainTargetNameIsEmpty.error
        }
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(token.JSONObject(), options: NSJSONWritingOptions())
            let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
            try keychain.set(data, key:token.name)
        } catch {
            throw error
        }
    }

    /**
    Saves OAuth2 token object into Keychain.

    - parameter token: OAuth2Token object.
    - parameter name: Valid user name which is used to save it into Keychain.
    */
    public class func saveIntoKeychainToken(token: OAuth2Token, name: String) throws {
        if name.isEmpty {
            throw ReddiftError.KeychainTargetNameIsEmpty.error
        }
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(token.JSONObject(), options: NSJSONWritingOptions())
            let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
            try keychain.set(data, key:name)
        } catch {
            throw error
        }
    }

    /**
    Removes OAuth2 token whose user name is specified by the name parmeter from Keychain.

    - parameter name: Valid user name which is used to save it into Keychain.
    */
    public class func removeFromKeychainTokenWithName(name: String) throws {
        if name.isEmpty {
            throw ReddiftError.KeychainTargetNameIsEmpty.error
        }
        do {
            let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
            try keychain.remove(name)
        } catch {
            throw error
        }
    }
}
