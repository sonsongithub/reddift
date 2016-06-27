//
//  NSError+reddift.swift
//  reddift
//
//  Created by sonson on 2015/04/12.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension NSError {
    class func error(with code: Int, description: String = "") -> NSError {
        return NSError(domain:Config.sharedInstance.bundleIdentifier, code:code, userInfo:["description":description])
    }
}

public enum ReddiftError: Int {
    case unknown                = 1000
    case parseJSON              = 1100

    case parseThing             = 1200
    case parseListing           = 1201
    case parseListingArticles   = 1202
    case parseThingT2           = 1203
    case parseCommentError      = 1204
    case returnedCommentError   = 1205
    case parseMoreError         = 1206
    
    case getCAPTCHA             = 1300
    case checkNeedsCAPTHCA      = 1301
    case getCAPTCHAIden         = 1302
    case getCAPTCHAImage        = 1303
    
    case oAuth2                 = 1400
    case parseAccessToken       = 1401
    case tokenNotfound          = 1402
    case setClientIDForBasicAuthentication = 1403
    case setUserInfoForBasicAuthentication = 1404
    case challengeOAuth2Session = 1405
    
    case malformed              = 1500
    
    case oAuth2Error            = 1600
    
    case keychainTargetNameIsEmpty          = 1700
    case keychainDidFailToSerializeToken    = 1701
    
    case urlError               = 1800
    
    case multiredditDidFailToCreateJSON = 1900
    
    
    var error: NSError {
        return NSError.error(with: self.rawValue, description: self.description)
    }
    
    var description: String {
        switch self {
        case .parseJSON:
            return "Failed to parse JSON object unexpectedly."
            
        case .parseThing:
            return "Failed to parse Thing content unexpectedly."
        case .parseListing:
            return "Failed to parse Listing contents unexpectedly."
        case .parseListingArticles:
            return "Failed to parse artcles unexpectedly."
        case .parseThingT2:
            return "Failed to parse t2 content unexpectedly."
        case .parseCommentError:
            return "Returned error JSON object instead of Comment objects, and could not parse it."
        case .returnedCommentError:
            return "Returned error JSON object instead of Comment objects."
            
        case .getCAPTCHA:
            return "Failed to dosomething for CAPTCHA unexpectedly."
        case .checkNeedsCAPTHCA:
            return "Failed to check whether you have to handle CAPTCHA unexpectedly because response is unexepcted data or, it's neither true nor false."
        case .getCAPTCHAIden:
            return "Failed to parse iden to get a CAPTCHA image unexpectedly."
        case .getCAPTCHAImage:
            return "Failed to load a CAPTHCA image unexpectedly."
            
        case .setClientIDForBasicAuthentication:
            return "Failed to set client ID for Basic Authentication."
        case .setUserInfoForBasicAuthentication:
            return "Failed to set user name/password for Basic Authentication."
        case .challengeOAuth2Session:
            return "Failed to create NSURL when challenging to shake OAuth2 session."
            
        case .oAuth2:
            return "Failed to get an access token unexpectedly."
        case .parseAccessToken:
            return "Failed to extract access token from response unexpectedly."
        case .tokenNotfound:
            return "Token which has the name you specified was not found."
        case .malformed:
            return "Data is malformed."
        case .keychainTargetNameIsEmpty:
            return "Target name is empty, reddift can not do anything."
        case .keychainDidFailToSerializeToken:
            return "Failed to serialize token object in order to save into Keychain."
        case .urlError:
            return "Failed to parse URL and create a request object."
        case .multiredditDidFailToCreateJSON:
            return "Failed to create JSON object to post a new multireddit."
        default:
            return "Unknown error."
        }
    }
}
