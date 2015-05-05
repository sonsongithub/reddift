//
//  Account.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-15 11:23:32 +0900
//

import Foundation

public class Account : Thing {
    /**
    user has unread mail? null if not your account
    example: false
    */
    public var  has_mail = false
    /**
    
    example: 1427126074
    */
    public var  created = 0
    /**
    
    example: false
    */
    public var  hide_from_robots = false
    /**
    
    example: 0
    */
    public var  gold_creddits = 0
    /**
    
    example: 1427122474
    */
    public var  created_utc = 0
    /**
    user has unread mod mail? null if not your account
    example: false
    */
    public var  has_mod_mail = false
    /**
    user's link karma
    example: 1
    */
    public var  link_karma = 0
    /**
    user's comment karma
    example: 1
    */
    public var  comment_karma = 0
    /**
    whether this account is set to be over 18
    example: true
    */
    public var  over_18 = false
    /**
    reddit gold status
    example: false
    */
    public var  is_gold = false
    /**
    whether this account moderates any subreddits
    example: false
    */
    public var  is_mod = false
    /**
    
    example:
    */
    public var  gold_expiration = false
    /**
    user has provided an email address and got it verified?
    example: false
    */
    public var  has_verified_email = false
    /**
    Number of unread messages in the inbox. Not present if not your account
    example: 0
    */
    public var  inbox_count = 0
    
    public override func toString() -> String {
        return ""
    }
}


