//
//  OAuth2TokenRepository.swift
//  reddift
//
//  Created by sonson on 2015/04/14.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

@available(*, deprecated) public let OAuth2TokenRepositoryDidSaveToken = "OAuth2TokenRepositoryDidSaveToken"

/**
Repository to contain OAuth2 tokens for reddit.com based on "KeychanAccess".
You can manage mulitple accounts using this class.
OAuth2TokenRepository, is utility class, has only class method.
*/
public class OAuth2TokenRepository {
    @available(*, deprecated) public class func restoreFromKeychainWithName(name:String) -> Result<OAuth2Token> {
        let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
        if let data = try! keychain.getData(name) {
            var json:JSON? = nil
            do {
                json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
            } catch let error as NSError {
                removeFromKeychainTokenWithName(name)
                NSNotificationCenter.defaultCenter().postNotificationName(OAuth2TokenRepositoryDidSaveToken, object: nil)
                return Result(error:error)
            }
            if let json = json as? [String:AnyObject] {
                return Result(value:OAuth2Token(json))
            }
            removeFromKeychainTokenWithName(name)
            NSNotificationCenter.defaultCenter().postNotificationName(OAuth2TokenRepositoryDidSaveToken, object: nil)
        }
        return Result(error:ReddiftError.TokenNotfound.error)
    }
    
    public class func restoreFromKeychainWithName(name:String) throws -> OAuth2Token {
        let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
        if let data = try! keychain.getData(name) {
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String:AnyObject] {
                    return OAuth2Token(json)
                }
            } catch let error as NSError {
                removeFromKeychainTokenWithName(name)
                throw error
            }
            removeFromKeychainTokenWithName(name)
        }
        throw ReddiftError.TokenNotfound.error
    }
    
    public class func savedNamesInKeychain() -> [String] {
        var keys:[String] = []
        let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
        keys += keychain.allKeys()
        return keys
    }
    
    public class func saveIntoKeychainToken(token:OAuth2Token) {
        if token.name.characters.count > 0 {
            // save
            if let data = jsonForSerializeToken(token) {
                let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
                try! keychain.set(data, key:token.name)
                NSNotificationCenter.defaultCenter().postNotificationName(OAuth2TokenRepositoryDidSaveToken, object: nil)
            }
        }
        else {
            print("Error:name property is empty.")
        }
    }
    
    public class func saveIntoKeychainToken(token:OAuth2Token, name:String) {
        if name.characters.count > 0 {
            // save
            if let data = jsonForSerializeToken(token) {
                let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
                do {
                    try keychain.set(data, key:name)
                    NSNotificationCenter.defaultCenter().postNotificationName(OAuth2TokenRepositoryDidSaveToken, object: nil);
                }
                catch {
                    print("Can't save a token with \(name)")
                }
            }
        }
        else {
            print("Error:name property is empty.")
        }
    }
    
    public class func removeFromKeychainTokenWithName(name:String) {
        if name.characters.count > 0 {
            let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
            do {
                try keychain.remove(name);
            }
            catch {
                print("Can't remove a token with \(name)")
            }
        }
        else {
            print("Error:name property is empty.")
        }
    }
}
