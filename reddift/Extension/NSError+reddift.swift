//
//  NSError+reddift.swift
//  reddift
//
//  Created by sonson on 2015/04/12.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension NSError {
    class func errorWithCode(code:Int, _ description:String) -> NSError {
        return NSError(domain:Config.sharedInstance.bundleIdentifier, code:code, userInfo:["description":description])
    }
}

public enum ReddiftError:Int {
    case Unknown                = 0
    case ParseJSON              = 100

    case ParseThing             = 200
    case ParseListing           = 201
    case ParseListingArticles   = 202
    case ParseThingT2           = 203
    case ParseCommentError      = 204
    case ReturnedCommentError   = 205
    
    case GetCAPTCHA             = 300
    case CheckNeedsCAPTHCA      = 301
    case GetCAPTCHAIden         = 302
    case GetCAPTCHAImage        = 303
    
    case OAuth2                 = 400
    case ParseAccessToken       = 401
    case TokenNotfound          = 402
    case SetClientIDForBasicAuthentication = 403
    case SetUserInfoForBasicAuthentication = 404
    case ChallengeOAuth2Session = 405
    
    case Malformed              = 500
    
    case OAuth2Error            = 600
    
    case KeychainTargetNameIsEmpty          = 700
    case KeychainDidFailToSerializeToken    = 701
    
    case URLError               = 800
    
    case MultiredditDidFailToCreateJSON = 900
    
    
    var error:NSError {
        return NSError.errorWithCode(self.rawValue, self.description)
    }
    
    var description:String {
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