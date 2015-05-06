//
//  Parser+t2.swift
//  reddift
//
//  Created by sonson on 2015/04/21.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Parser {
	class func parseDataInThing_t2(data:[String:AnyObject]) -> Thing {
		var account = Account()
		
		if let temp = data["has_mail"] as? Bool {
			account.has_mail = temp
		}
		if let temp = data["name"] as? String {
			account.name = temp
		}
		if let temp = data["created"] as? Int {
			account.created = temp
		}
		if let temp = data["hide_from_robots"] as? Bool {
			account.hide_from_robots = temp
		}
		if let temp = data["gold_creddits"] as? Int {
			account.gold_creddits = temp
		}
		if let temp = data["created_utc"] as? Int {
			account.created_utc = temp
		}
		if let temp = data["has_mod_mail"] as? Bool {
			account.has_mod_mail = temp
		}
		if let temp = data["link_karma"] as? Int {
			account.link_karma = temp
		}
		if let temp = data["comment_karma"] as? Int {
			account.comment_karma = temp
		}
		if let temp = data["over_18"] as? Bool {
			account.over_18 = temp
		}
		if let temp = data["is_gold"] as? Bool {
			account.is_gold = temp
		}
		if let temp = data["is_mod"] as? Bool {
			account.is_mod = temp
		}
		if let temp = data["gold_expiration"] as? Bool {
			account.gold_expiration = temp
		}
		if let temp = data["has_verified_email"] as? Bool {
			account.has_verified_email = temp
		}
		if let temp = data["id"] as? String {
			account.id = temp
		}
		if let temp = data["inbox_count"] as? Int {
			account.inbox_count = temp
		}
		
		return account
	}
}
