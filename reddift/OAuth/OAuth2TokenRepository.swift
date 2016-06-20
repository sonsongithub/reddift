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
    public class func restoreFromKeychainWithName(name:String) throws -> OAuth2Token {
        let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
        if let data = try! keychain.getData(key: name) {
            do {
				if let json = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions()) as? [String:AnyObject] {
                    return OAuth2Token(json)
                }
            } catch let error as NSError {
                try! removeFromKeychainTokenWithName(name: name)
                throw error
            }
            try! removeFromKeychainTokenWithName(name: name)
        }
        throw ReddiftError.TokenNotfound.error
    }

    /**
    Restores user name list from Keychain.

    - returns: List contains user names that was used to save tokens.
    */
    public class func savedNamesInKeychain() -> [String] {
        var keys:[String] = []
        let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
        keys += keychain.allKeys()
        return keys
    }

    /**
    Saves OAuth2 token object into Keychain.

    - parameter token: OAuth2Token object, that must have valid user name which is used to save it into Keychain.
    */
    public class func saveIntoKeychainToken(token:OAuth2Token) throws {
        if token.name.isEmpty {
            throw ReddiftError.KeychainTargetNameIsEmpty.error
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: token.JSONObject(), options: JSONSerialization.WritingOptions())
            let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
			try keychain.set(value: data, key:token.name)
        }
        catch {
            throw error
        }
    }

    /**
    Saves OAuth2 token object into Keychain.

    - parameter token: OAuth2Token object.
    - parameter name: Valid user name which is used to save it into Keychain.
    */
    public class func saveIntoKeychainToken(token:OAuth2Token, name:String) throws {
        if name.isEmpty {
            throw ReddiftError.KeychainTargetNameIsEmpty.error
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: token.JSONObject(), options: JSONSerialization.WritingOptions())
            let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
			try keychain.set(value: data, key:name)
        }
        catch {
            throw error
        }
    }

    /**
    Removes OAuth2 token whose user name is specified by the name parmeter from Keychain.

    - parameter name: Valid user name which is used to save it into Keychain.
    */
    public class func removeFromKeychainTokenWithName(name:String) throws {
        if name.isEmpty {
            throw ReddiftError.KeychainTargetNameIsEmpty.error
        }
        do {
            let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
            try keychain.remove(key: name);
        }
        catch {
            throw error
        }
    }
}
