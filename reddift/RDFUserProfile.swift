//
//  RDFUserProfile.swift
//  reddift
//
//  Created by sonson on 2015/04/13.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class RDFUserProfile {
	var hasMail:Bool = false;
	var name:String = "";
	var created:NSTimeInterval = 0;
	var hideFromRobots:Bool = false;
	var goldCreddits:Int = 0;
	var createdUTC:NSTimeInterval = 0;
	var hasModMail:Bool = false;
	var linkKarma:Int = 0;
	var commentKarma:Int = 0;
	var over18:Bool = false;
	var isGold:Bool = false;
	var isMod:Bool = false;
	var goldExpiration:NSTimeInterval = 0;
	var hasVerifiedMail:Bool = false;
	var id:String = "";
	var inboxCount:Int = 0;
	
	func updateWithJSON(json:[String:AnyObject]) {
		if let temp = json["has_mail"] as? Bool {
			self.hasMail = temp;
		}
		if let temp = json["name"] as? String {
			self.name = temp;
		}
		if let temp = json["created"] as? NSTimeInterval {
			self.created = temp;
		}
		if let temp = json["hide_from_robots"] as? Bool {
			self.hideFromRobots = temp;
		}
		if let temp = json["gold_creddits"] as? Int {
			self.goldCreddits = temp;
		}
		if let temp = json["created_utc"] as? NSTimeInterval {
			self.createdUTC = temp;
		}
		if let temp = json["has_mod_mail"] as? Bool {
			self.hasModMail = temp;
		}
		if let temp = json["link_karma"] as? Int {
			self.linkKarma = temp;
		}
		if let temp = json["comment_karma"] as? Int {
			self.commentKarma = temp;
		}
		if let temp = json["over_18"] as? Bool {
			self.over18 = temp;
		}
		if let temp = json["is_gold"] as? Bool {
			self.isGold = temp;
		}
		if let temp = json["is_mod"] as? Bool {
			self.isMod = temp;
		}
		if let temp = json["gold_expiration"] as? Int {
			self.linkKarma = temp;
		}
		if let temp = json["has_verified_email"] as? Bool {
			self.hasVerifiedMail = temp;
		}
		if let temp = json["id"] as? String {
			self.id = temp;
		}
		if let temp = json["inbox_count"] as? Int {
			self.inboxCount = temp;
		}
	}
	
	init(json:[String:AnyObject]) {
		self.updateWithJSON(json);
	}
}
