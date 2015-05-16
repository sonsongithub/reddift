//
//  Parser+t4.swift
//  reddift
//
//  Created by sonson on 2015/04/21.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Parser {
	/**
	Parse t4 object.
	
	:param: data Dictionary, must be generated parsing "t4".
	:returns: Message object as Thing.
	*/
	class func parseDataInThing_t4(data:[String:AnyObject]) -> Thing {
		var message = Message()
		message.body = data["body"] as? String ?? ""
		message.wasComment = data["was_comment"] as? Bool ?? false
		message.firstMessage = data["first_message"] as? String ?? ""
		message.name = data["name"] as? String ?? ""
		message.firstMessageName = data["first_message_name"] as? String ?? ""
		message.created = data["created"] as? Int ?? 0
		message.dest = data["dest"] as? String ?? ""
		message.author = data["author"] as? String ?? ""
		message.createdUtc = data["created_utc"] as? Int ?? 0
		message.bodyHtml = data["body_html"] as? String ?? ""
		message.subreddit = data["subreddit"] as? String ?? ""
		message.parentId = data["parent_id"] as? String ?? ""
		message.context = data["context"] as? String ?? ""
		message.replies = data["replies"] as? String ?? ""
		message.id = data["id"] as? String ?? ""
		message.new = data["new"] as? Bool ?? false
		message.distinguished = data["distinguished"] as? String ?? ""
		message.subject = data["subject"] as? String ?? ""
		return message
	}
}

