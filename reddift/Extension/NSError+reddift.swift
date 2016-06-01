//
//  NSError+reddift.swift
//  reddift
//
//  Created by sonson on 2015/04/12.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension NSError {
    class func errorWithCode(code: Int, _ description: String) -> NSError {
        return NSError(domain:Config.sharedInstance.bundleIdentifier, code:code, userInfo:["description":description])
    }
}

public enum ReddiftError: Int {
    case Unknown                = 1000
    case ParseJSON              = 1100

    case ParseThing             = 1200
    case ParseListing           = 1201
    case ParseListingArticles   = 1202
    case ParseThingT2           = 1203
    case ParseCommentError      = 1204
    case ReturnedCommentError   = 1205
    case ParseMoreError         = 1206
    
    case GetCAPTCHA             = 1300
    case CheckNeedsCAPTHCA      = 1301
    case GetCAPTCHAIden         = 1302
    case GetCAPTCHAImage        = 1303
    
    case OAuth2                 = 1400
    case ParseAccessToken       = 1401
    case TokenNotfound          = 1402
    case SetClientIDForBasicAuthentication = 1403
    case SetUserInfoForBasicAuthentication = 1404
    case ChallengeOAuth2Session = 1405
    
    case Malformed              = 1500
    
    case OAuth2Error            = 1600
    
    case KeychainTargetNameIsEmpty          = 1700
    case KeychainDidFailToSerializeToken    = 1701
    
    case URLError               = 1800
    
    case MultiredditDidFailToCreateJSON = 1900
    
    
    var error: NSError {
        return NSError.errorWithCode(self.rawValue, self.description)
    }
    
    var description: String {
        switch self {
        case .ParseJSON:
            return "Failed to parse JSON object unexpectedly."
            
        case .ParseThing:
            return "Failed to parse Thing content unexpectedly."
        case .ParseListing:
            return "Failed to parse Listing contents unexpectedly."
        case .ParseListingArticles:
            return "Failed to parse artcles unexpectedly."
        case .ParseThingT2:
            return "Failed to parse t2 content unexpectedly."
        case .ParseCommentError:
            return "Returned error JSON object instead of Comment objects, and could not parse it."
        case .ReturnedCommentError:
            return "Returned error JSON object instead of Comment objects."
            
        case .GetCAPTCHA:
            return "Failed to dosomething for CAPTCHA unexpectedly."
        case .CheckNeedsCAPTHCA:
            return "Failed to check whether you have to handle CAPTCHA unexpectedly because response is unexepcted data or, it's neither true nor false."
        case .GetCAPTCHAIden:
            return "Failed to parse iden to get a CAPTCHA image unexpectedly."
        case .GetCAPTCHAImage:
            return "Failed to load a CAPTHCA image unexpectedly."
            
        case .SetClientIDForBasicAuthentication:
            return "Failed to set client ID for Basic Authentication."
        case .SetUserInfoForBasicAuthentication:
            return "Failed to set user name/password for Basic Authentication."
        case .ChallengeOAuth2Session:
            return "Failed to create NSURL when challenging to shake OAuth2 session."
            
        case .OAuth2:
            return "Failed to get an access token unexpectedly."
        case .ParseAccessToken:
            return "Failed to extract access token from response unexpectedly."
        case .TokenNotfound:
            return "Token which has the name you specified was not found."
        case .Malformed:
            return "Data is malformed."
        case .KeychainTargetNameIsEmpty:
            return "Target name is empty, reddift can not do anything."
        case .KeychainDidFailToSerializeToken:
            return "Failed to serialize token object in order to save into Keychain."
        case .URLError:
            return "Failed to parse URL and create a request object."
        case .MultiredditDidFailToCreateJSON:
            return "Failed to create JSON object to post a new multireddit."
        default:
            return "Unknown error."
        }
    }
}
