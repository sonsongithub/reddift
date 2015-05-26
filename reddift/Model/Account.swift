//
//  Account.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-15 11:23:32 +0900
//

import Foundation

/**
Account object.
*/
public struct Account : Thing {
    /// identifier of Thing like 15bfi0.
    public var id = ""
    /// name of Thing, that is fullname, like t3_15bfi0.
    public var name = ""
    /// type of Thing, like t3.
    public static var kind = "t2"
    
    /**
    user has unread mail? null if not your account
    example: false
    */
    public var hasMail = false
    /**
    
    example: 1427126074
    */
    public var  created = 0
    /**
    
    example: false
    */
    public var hideFromRobots = false
    /**
    
    example: 0
    */
    public var goldCreddits = 0
    /**
    
    example: 1427122474
    */
    public var createdUtc = 0
    /**
    user has unread mod mail? null if not your account
    example: false
    */
    public var hasModMail = false
    /**
    user's link karma
    example: 1
    */
    public var linkKarma = 0
    /**
    user's comment karma
    example: 1
    */
    public var commentKarma = 0
    /**
    whether this account is set to be over 18
    example: true
    */
    public var over18 = false
    /**
    reddit gold status
    example: false
    */
    public var isGold = false
    /**
    whether this account moderates any subreddits
    example: false
    */
    public var isMod = false
    /**
    
    example:
    */
    public var goldExpiration = false
    /**
    user has provided an email address and got it verified?
    example: false
    */
    public var hasVerifiedEmail = false
    /**
    Number of unread messages in the inbox. Not present if not your account
    example: 0
    */
    public var inboxCount = 0
    
    public func toString() -> String {
        return ""
    }
    
    /**
    Parse t2 object.
    
    :param: data Dictionary, must be generated parsing "t2".
    :returns: Account object as Thing.
    */
    public init(data:JSONDictionary) {
        id = data["id"] as? String ?? ""
        hasMail = data["has_mail"] as? Bool ?? false
        name = data["name"] as? String ?? ""
        created = data["created"] as? Int ?? 0
        hideFromRobots = data["hide_from_robots"] as? Bool ?? false
        goldCreddits = data["gold_creddits"] as? Int ?? 0
        createdUtc = data["created_utc"] as? Int ?? 0
        hasModMail = data["has_mod_mail"] as? Bool ?? false
        linkKarma = data["link_karma"] as? Int ?? 0
        commentKarma = data["comment_karma"] as? Int ?? 0
        over18 = data["over_18"] as? Bool ?? false
        isGold = data["is_gold"] as? Bool ?? false
        isMod = data["is_mod"] as? Bool ?? false
        goldExpiration = data["gold_expiration"] as? Bool ?? false
        hasVerifiedEmail = data["has_verified_email"] as? Bool ?? false
        id = data["id"] as? String ?? ""
        inboxCount = data["inbox_count"] as? Int ?? 0
    }
}

func parseDataInJSON_t2(json:JSON) -> Result<JSON> {
    if let object = json as? JSONDictionary {
        return resultFromOptional(Account(data:object), ReddiftError.ParseThingT2.error)
    }
    return resultFromOptional(nil, ReddiftError.ParseThingT2.error)
}

