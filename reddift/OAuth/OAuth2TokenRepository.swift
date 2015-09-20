//
//  OAuth2TokenRepository.swift
//  reddift
//
//  Created by sonson on 2015/04/14.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

public let OAuth2TokenRepositoryDidSaveToken = "OAuth2TokenRepositoryDidSaveToken"

/**
Repository to contain OAuth2 tokens for reddit.com based on "KeychanAccess".
You can manage mulitple accounts using this class.
OAuth2TokenRepository, is utility class, has only class method.
*/
public class OAuth2TokenRepository {
    public class func restoreFromKeychainWithName(name:String) -> Result<OAuth2Token> {
        let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
        do {
            if let data = try keychain.getData(name) {
                if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String:AnyObject] {
                    return Result(value:OAuth2Token(json))
                }
            }
            return Result(error: ReddiftError.Unknown.error)
        }
        catch {
            try! removeFromKeychainTokenWithName(name)
            NSNotificationCenter.defaultCenter().postNotificationName(OAuth2TokenRepositoryDidSaveToken, object: nil)
            return Result(error:error as NSError)
        }
    }
    
    public class func savedNamesInKeychain() -> [String] {
        var keys:[String] = []
        let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
        keys += keychain.allKeys()
        return keys
    }
    
    public class func saveIntoKeychainToken(token:OAuth2Token) throws {
        if token.name.isEmpty {
            throw ReddiftError.KeychainTargetNameIsEmpty.error
        }
        
        // save
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(token.JSONObject(), options: NSJSONWritingOptions())
            let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
            try keychain.set(data, key:token.name)
            NSNotificationCenter.defaultCenter().postNotificationName(OAuth2TokenRepositoryDidSaveToken, object: nil)
        }
        catch { throw error }
    }
    
    public class func saveIntoKeychainToken(token:OAuth2Token, name:String) throws {
        if name.isEmpty {
            throw ReddiftError.KeychainTargetNameIsEmpty.error
        }
        
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(token.JSONObject(), options: NSJSONWritingOptions())
            let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
            try keychain.set(data, key:name)
            NSNotificationCenter.defaultCenter().postNotificationName(OAuth2TokenRepositoryDidSaveToken, object: nil);
        }
        catch { throw error }
    }
    
    public class func removeFromKeychainTokenWithName(name:String) throws {
        if name.isEmpty {
            throw ReddiftError.KeychainTargetNameIsEmpty.error
        }
        do {
            let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
            try keychain.remove(name);
        }
        catch { throw error }
    }
}
