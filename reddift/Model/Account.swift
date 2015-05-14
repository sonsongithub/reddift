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
public class Account : Thing {
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
    
    public override func toString() -> String {
        return ""
    }
}


