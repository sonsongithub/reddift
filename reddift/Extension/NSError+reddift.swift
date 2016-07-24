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

public enum ReddiftError: ErrorProtocol {
    case unknown
    case tokenIsNotAvailable
    case canNotCreateURLRequest
    
    case specifiedNameTokenNotFoundInKeychain
    case tokenNameIsInvalid
    
    case needsCAPTCHAResponseIsInvalid
    case imageOfCAPTCHAIsInvalid
    case identifierOfCAPTCHAIsMalformed
    
    case sr_nameOfRecommendedSubredditKeyNotFound
    case nameAsResultOfSearchSubredditKeyNotFound
    case submit_textxSubredditKeyNotFound
    case jsonObjectIsNotListingThing
    
    case accountJsonObjectIsMalformed
    case accountJsonObjectIsNotDictionary
    
    case tokenJsonObjectIsNotDictionary
    case canNotCreateURLRequestForOAuth2Page
    case canNotAllocateDataToCreateURLForOAuth2
    
    case moreCommentJsonObjectIsNotDictionary
    case canNotGetMoreCommentForAnyReason
    
    case multiredditJsonObjectIsNotDictionary
    case multiredditJsonObjectIsMalformed
    
    case canNotCreateDataObjectForClientIDForBasicAuthentication
    case canNotCreateDataObjectForUserInfoForBasicAuthentication
    
    case dataIsNotUTF8String
    
    case preferenceJsonObjectIsNotDictionary
    
    case failedToParseThingFromJsonObject
    case commentJsonObjectIsMalformed
    
    case failedToParseThingFromRedditAny
    case failedToParseMultiredditArrayFromRedditAny
    case failedToParseListingPairFromRedditAny
    
    case failedToCreateJSONForMultireadditPosting
}

//public enum ReddiftError: Int {
//    case unknown
//    case parseJSON
//
//    case parseThing
//    case parseListing
//    case parseListingArticles
//    case parseThingT2
//    case parseCommentError
//    case returnedCommentError
//    case parseMoreError
//    
//    case getCAPTCHA
//    case checkNeedsCAPTHCA
//    case getCAPTCHAIden
//    case getCAPTCHAImage
//    
//    case oAuth2
//    case parseAccessToken
//    case tokenNotfound
//    case setClientIDForBasicAuthentication
//    case setUserInfoForBasicAuthentication
//    case challengeOAuth2Session
//    
//    case malformed
//    case parsedJSONObjectIsMalformed
//    
//    case oAuth2Error
//    
//    case keychainTargetNameIsEmpty
//    case keychainDidFailToSerializeToken
//    
//    case urlError
//    
//    case multiredditDidFailToCreateJSON
//    
//    
//    var error: NSError {
//        return NSError.error(with: self.rawValue, description: self.description)
//    }
//    
//    var description: String {
//        switch self {
//        case .parseJSON:
//            return "Failed to parse JSON object unexpectedly."
//            
//        case .parseThing:
//            return "Failed to parse Thing content unexpectedly."
//        case .parseListing:
//            return "Failed to parse Listing contents unexpectedly."
//        case .parseListingArticles:
//            return "Failed to parse artcles unexpectedly."
//        case .parseThingT2:
//            return "Failed to parse t2 content unexpectedly."
//        case .parseCommentError:
//            return "Returned error JSON object instead of Comment objects, and could not parse it."
//        case .returnedCommentError:
//            return "Returned error JSON object instead of Comment objects."
//            
//        case .getCAPTCHA:
//            return "Failed to dosomething for CAPTCHA unexpectedly."
//        case .checkNeedsCAPTHCA:
//            return "Failed to check whether you have to handle CAPTCHA unexpectedly because response is unexepcted data or, it's neither true nor false."
//        case .getCAPTCHAIden:
//            return "Failed to parse iden to get a CAPTCHA image unexpectedly."
//        case .getCAPTCHAImage:
//            return "Failed to load a CAPTHCA image unexpectedly."
//            
//        case .setClientIDForBasicAuthentication:
//            return "Failed to set client ID for Basic Authentication."
//        case .setUserInfoForBasicAuthentication:
//            return "Failed to set user name/password for Basic Authentication."
//        case .challengeOAuth2Session:
//            return "Failed to create NSURL when challenging to shake OAuth2 session."
//            
//        case .oAuth2:
//            return "Failed to get an access token unexpectedly."
//        case .parseAccessToken:
//            return "Failed to extract access token from response unexpectedly."
//        case .tokenNotfound:
//            return "Token which has the name you specified was not found."
//        case .malformed:
//            return "Data is malformed."
//        case .keychainTargetNameIsEmpty:
//            return "Target name is empty, reddift can not do anything."
//        case .keychainDidFailToSerializeToken:
//            return "Failed to serialize token object in order to save into Keychain."
//        case .urlError:
//            return "Failed to parse URL and create a request object."
//        case .multiredditDidFailToCreateJSON:
//            return "Failed to create JSON object to post a new multireddit."
//        default:
//            return "Unknown error."
//        }
//    }
//}
