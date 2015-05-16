//
//  Parser+t2.swift
//  reddift
//
//  Created by sonson on 2015/04/21.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Parser {
	/**
	Parse t2 object.
	
	:param: data Dictionary, must be generated parsing "more".
	:returns: Account object as Thing.
	*/
	class func parseDataInThing_t2(data:[String:AnyObject]) -> Thing {
		var account = Account()
		
		if let temp = data["has_mail"] as? Bool {
			account.hasMail = temp
		}
		if let temp = data["name"] as? String {
			account.name = temp
		}
		if let temp = data["created"] as? Int {
			account.created = temp
		}
		if let temp = data["hide_from_robots"] as? Bool {
			account.hideFromRobots = temp
		}
		if let temp = data["gold_creddits"] as? Int {
			account.goldCreddits = temp
		}
		if let temp = data["created_utc"] as? Int {
			account.createdUtc = temp
		}
		if let temp = data["has_mod_mail"] as? Bool {
			account.hasModMail = temp
		}
		if let temp = data["link_karma"] as? Int {
			account.linkKarma = temp
		}
		if let temp = data["comment_karma"] as? Int {
			account.commentKarma = temp
		}
		if let temp = data["over_18"] as? Bool {
			account.over18 = temp
		}
		if let temp = data["is_gold"] as? Bool {
			account.isGold = temp
		}
		if let temp = data["is_mod"] as? Bool {
			account.isMod = temp
		}
		if let temp = data["gold_expiration"] as? Bool {
			account.goldExpiration = temp
		}
		if let temp = data["has_verified_email"] as? Bool {
			account.hasVerifiedEmail = temp
		}
		if let temp = data["id"] as? String {
			account.id = temp
		}
		if let temp = data["inbox_count"] as? Int {
			account.inboxCount = temp
		}
		
		return account
	}
}
