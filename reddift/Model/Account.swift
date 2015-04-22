//
//  Account.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-15 11:23:32 +0900
//

import UIKit

class Account : Thing {
	/**
	user has unread mail? null if not your account
	example: false
	*/
	var has_mail = false
	/**
	
	example: 1427126074
	*/
	var created = 0
	/**
	
	example: false
	*/
	var hide_from_robots = false
	/**
	
	example: 0
	*/
	var gold_creddits = 0
	/**
	
	example: 1427122474
	*/
	var created_utc = 0
	/**
	user has unread mod mail? null if not your account
	example: false
	*/
	var has_mod_mail = false
	/**
	user's link karma
	example: 1
	*/
	var link_karma = 0
	/**
	user's comment karma
	example: 1
	*/
	var comment_karma = 0
	/**
	whether this account is set to be over 18
	example: true
	*/
	var over_18 = false
	/**
	reddit gold status
	example: false
	*/
	var is_gold = false
	/**
	whether this account moderates any subreddits
	example: false
	*/
	var is_mod = false
	/**
	
	example:
	*/
	var gold_expiration = false
	/**
	user has provided an email address and got it verified?
	example: false
	*/
	var has_verified_email = false
	/**
	Number of unread messages in the inbox. Not present if not your account
	example: 0
	*/
	var inbox_count = 0
	
     override func toString() -> String {
		return ""
    }
}


