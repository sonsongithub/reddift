//
//  Parser+t1.swift
//  reddift
//
//  Created by sonson on 2015/04/21.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

extension Parser {
    class func parseThing_t1(json:[String:AnyObject]) -> Thing {
        let comment = Comment()
        if let data = json["data"] as? [String:AnyObject] {
            if let temp = data["subreddit_id"] as? String {
                comment.subreddit_id = temp
            }
            if let temp = data["banned_by"] as? String {
                comment.banned_by = temp
            }
            if let temp = data["link_id"] as? String {
                comment.link_id = temp
            }
            if let temp = data["likes"] as? String {
                comment.likes = temp
            }
            if let temp = data["replies"] as? [String:AnyObject] {
                if let obj:AnyObject = parseJSON(temp, depth:0) {
					comment.replies = obj
                }
            }
//            if let temp = data["user_reports"] as? String {
//                comment.user_reports = temp
//            }
            if let temp = data["saved"] as? Bool {
                comment.saved = temp
            }
            if let temp = data["id"] as? String {
                comment.id = temp
            }
            if let temp = data["gilded"] as? Int {
                comment.gilded = temp
            }
            if let temp = data["archived"] as? Bool {
                comment.archived = temp
            }
//            if let temp = data["report_reasons"] as? String {
//                comment.report_reasons = temp
//            }
            if let temp = data["author"] as? String {
                comment.author = temp
            }
            if let temp = data["parent_id"] as? String {
                comment.parent_id = temp
            }
            if let temp = data["score"] as? Int {
                comment.score = temp
            }
            if let temp = data["approved_by"] as? String {
                comment.approved_by = temp
            }
            if let temp = data["controversiality"] as? Int {
                comment.controversiality = temp
            }
            if let temp = data["body"] as? String {
                comment.body = temp
            }
            if let temp = data["edited"] as? Bool {
                comment.edited = temp
            }
            if let temp = data["author_flair_css_class"] as? String {
                comment.author_flair_css_class = temp
            }
            if let temp = data["downs"] as? Int {
                comment.downs = temp
            }
            if let temp = data["body_html"] as? String {
                comment.body_html = temp
            }
            if let temp = data["subreddit"] as? String {
                comment.subreddit = temp
            }
            if let temp = data["score_hidden"] as? Bool {
                comment.score_hidden = temp
            }
            if let temp = data["name"] as? String {
                comment.name = temp
            }
            if let temp = data["created"] as? Int {
                comment.created = temp
            }
            if let temp = data["author_flair_text"] as? String {
                comment.author_flair_text = temp
            }
            if let temp = data["created_utc"] as? Int {
                comment.created_utc = temp
            }
            if let temp = data["distinguished"] as? Bool {
                comment.distinguished = temp
            }
//            if let temp = data["mod_reports"] as? String {
//                comment.mod_reports = temp
//            }
            if let temp = data["num_reports"] as? Int {
                comment.num_reports = temp
            }
            if let temp = data["ups"] as? Int {
                comment.ups = temp
            }
        }
        if let kind = json["kind"] as? String {
            comment.kind = kind
        }
        return comment
    }
	
	class func parseThing_more(json:[String:AnyObject]) -> Thing {
		let more = More()
		if let data = json["data"] as? [String:AnyObject] {
			if let temp = data["id"] as? String {
				more.id = temp
			}
			if let temp = data["name"] as? String {
				more.name = temp
			}
			if let temp = data["parent_id"] as? String {
				more.parent_id = temp
			}
			if let temp = data["count"] as? Int {
				more.count = temp
			}
			if let temp = data["children"] as? [String] {
				more.children = temp
			}
		}
		if let kind = json["kind"] as? String {
			more.kind = kind
		}
		return more
	}
}
