//
//  OAuth2TokenRepository.swift
//  reddift
//
//  Created by sonson on 2015/04/14.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

let DidSaveTokenIntoOAuth2TokenRepository = "DidSaveTokenIntoOAuth2TokenRepository"

class OAuth2TokenRepository {
    class func restoreFromKeychainWithName(name:String) -> OAuth2Token? {
        let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
        if let data = keychain.getData(name) as NSData? {
            if let token = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? OAuth2Token {
                return token
            }
        }
        return nil
    }
    
    class func savedNamesInKeychain() -> [String] {
        var keys:[String] = []
        let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
        keys += keychain.allKeys()
        return keys
    }
    
    class func saveIntoKeychainToken(token:OAuth2Token, name:String) {
        if (count(name) > 0) {
            // save
            let data = NSKeyedArchiver.archivedDataWithRootObject(token)
            let keychain = Keychain(service:Config.sharedInstance.bundleIdentifier)
            keychain.set(data, key:name)
            NSNotificationCenter.defaultCenter().postNotificationName(DidSaveTokenIntoOAuth2TokenRepository, object: nil);
        }
        else {
            println("Error:name property is empty.")
        }
    }
}
