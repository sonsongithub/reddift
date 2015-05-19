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
		account.hasMail = data["has_mail"] as? Bool ?? false
		account.name = data["name"] as? String ?? ""
		account.created = data["created"] as? Int ?? 0
		account.hideFromRobots = data["hide_from_robots"] as? Bool ?? false
		account.goldCreddits = data["gold_creddits"] as? Int ?? 0
		account.createdUtc = data["created_utc"] as? Int ?? 0
		account.hasModMail = data["has_mod_mail"] as? Bool ?? false
		account.linkKarma = data["link_karma"] as? Int ?? 0
		account.commentKarma = data["comment_karma"] as? Int ?? 0
		account.over18 = data["over_18"] as? Bool ?? false
		account.isGold = data["is_gold"] as? Bool ?? false
		account.isMod = data["is_mod"] as? Bool ?? false
		account.goldExpiration = data["gold_expiration"] as? Bool ?? false
		account.hasVerifiedEmail = data["has_verified_email"] as? Bool ?? false
		account.id = data["id"] as? String ?? ""
		account.inboxCount = data["inbox_count"] as? Int ?? 0
		return account
	}
    
    class func parseDataInJSON_t2(json:JSON) -> Result<JSON> {
        if let object = json as? JSONDictionary {
            return resultFromOptional(Parser.parseDataInThing_t2(object), ReddiftError.ParseThingT2.error)
        }
        return resultFromOptional(nil, ReddiftError.ParseThingT2.error)
    }
}
