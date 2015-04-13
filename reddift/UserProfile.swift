//
//  UserProfile.swift
//  reddift
//
//  Created by sonson on 2015/04/13.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class UserProfile {
    var hasMail = false
    var name = ""
    var created:NSTimeInterval = 0
    var hideFromRobots = false
    var goldCreddits = 0
    var createdUTC:NSTimeInterval = 0
    var hasModMail = false
    var linkKarma = 0
    var commentKarma = 0
    var over18 = false
    var isGold = false
    var isMod = false
    var goldExpiration:NSTimeInterval = 0
    var hasVerifiedMail = false
    var id = ""
    var inboxCount = 0
    
    func updateWithJSON(json:[String:AnyObject]) {
        if let temp = json["has_mail"] as? Bool {
            hasMail = temp
        }
        if let temp = json["name"] as? String {
            name = temp
        }
        if let temp = json["created"] as? NSTimeInterval {
            created = temp
        }
        if let temp = json["hide_from_robots"] as? Bool {
            hideFromRobots = temp
        }
        if let temp = json["gold_creddits"] as? Int {
            goldCreddits = temp
        }
        if let temp = json["created_utc"] as? NSTimeInterval {
            createdUTC = temp
        }
        if let temp = json["has_mod_mail"] as? Bool {
            hasModMail = temp
        }
        if let temp = json["link_karma"] as? Int {
            linkKarma = temp
        }
        if let temp = json["comment_karma"] as? Int {
            commentKarma = temp
        }
        if let temp = json["over_18"] as? Bool {
            over18 = temp
        }
        if let temp = json["is_gold"] as? Bool {
            isGold = temp
        }
        if let temp = json["is_mod"] as? Bool {
            isMod = temp
        }
        if let temp = json["gold_expiration"] as? Int {
            linkKarma = temp
        }
        if let temp = json["has_verified_email"] as? Bool {
            hasVerifiedMail = temp
        }
        if let temp = json["id"] as? String {
            id = temp
        }
        if let temp = json["inbox_count"] as? Int {
            inboxCount = temp
        }
    }
    
    init(json:[String:AnyObject]) {
        self.updateWithJSON(json)
    }
}
