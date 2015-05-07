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

public enum ReddiftError {
    case ParseJSON              // 100

    case ParseThing             // 200
    case ParseListing           // 201
    case ParseListingArticles   // 202
    case ParseThingT2           // 203
    
    case GetCAPTCHA             // 300
    case CheckNeedsCAPTHCA      // 301
    case GetCAPTCHAIden         // 302
    case GetCAPTCHAImage        // 303
    
    case OAuth2                 // 400
    case ParseAccessToken       // 401
    
    var error:NSError {
        get {
            return NSError.errorWithCode(self.code, self.description)
        }
    }
    
    var code:Int {
        get {
            switch self {
            case .ParseJSON:
                return 100
                
            case .ParseThing:
                return 200
            case .ParseListing:
                return 201
            case .ParseListingArticles:
                return 202
            case .ParseThingT2:
                return 203
                
            case .GetCAPTCHA:
                return 300
            case .CheckNeedsCAPTHCA:
                return 301
            case .GetCAPTCHAIden:
                return 302
            case .GetCAPTCHAImage:
                return 303
                
            case .OAuth2:
                return 400
            case .ParseAccessToken:
                return 401
            
            default:
                return 0
            }
        }
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
            
        case .GetCAPTCHA:
            return "Failed to dosomething for CAPTCHA unexpectedly."
        case .CheckNeedsCAPTHCA:
            return "Failed to check whether you have to handle CAPTCHA unexpectedly because response is unexepcted data or, it's neither true nor false."
        case .GetCAPTCHAIden:
            return "Failed to parse iden to get a CAPTCHA image unexpectedly."
        case .GetCAPTCHAImage:
            return "Failed to load a CAPTHCA image unexpectedly."
            
        case .OAuth2:
            return "Failed to get an access token unexpectedly."
        case .ParseAccessToken:
            return "Failed to extract access token from response unexpectedly."
        case .TokenNotfound:
            return "Token which has the name you specified was not found."
        
        default:
            return "Unknown error"
        }
    }
}