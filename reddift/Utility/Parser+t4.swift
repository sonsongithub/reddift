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
		if let temp = data["body"] as? String {
			message.body = temp
		}
		if let temp = data["was_comment"] as? Bool {
			message.wasComment = temp
		}
		if let temp = data["first_message"] as? String {
			message.firstMessage = temp
		}
		if let temp = data["name"] as? String {
			message.name = temp
		}
		if let temp = data["first_message_name"] as? String {
			message.firstMessageName = temp
		}
		if let temp = data["created"] as? Int {
			message.created = temp
		}
		if let temp = data["dest"] as? String {
			message.dest = temp
		}
		if let temp = data["author"] as? String {
			message.author = temp
		}
		if let temp = data["created_utc"] as? Int {
			message.createdUtc = temp
		}
		if let temp = data["body_html"] as? String {
			message.bodyHtml = temp
		}
		if let temp = data["subreddit"] as? String {
			message.subreddit = temp
		}
		if let temp = data["parent_id"] as? String {
			message.parentId = temp
		}
		if let temp = data["context"] as? String {
			message.context = temp
		}
		if let temp = data["replies"] as? String {
			message.replies = temp
		}
		if let temp = data["id"] as? String {
			message.id = temp
		}
		if let temp = data["new"] as? Bool {
			message.new = temp
		}
		if let temp = data["distinguished"] as? String {
			message.distinguished = temp
		}
		if let temp = data["subject"] as? String {
			message.subject = temp
		}
		return message
	}
}

