//
//  Parser+t3.swift
//  reddift
//
//  Created by sonson on 2015/04/21.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Parser {
    class func parseDataInThing_t3(data:[String:AnyObject]) -> Thing {
        let link = Link()
		if let temp = data["domain"] as? String {
			link.domain = temp
		}
		if let temp = data["banned_by"] as? String {
			link.banned_by = temp
		}
		if let temp = data["media_embed"] as? [String:AnyObject] {
			if temp.count > 0 {
				let media_embed = MediaEmbed()
				media_embed.updateWithJSON(temp)
				link.media_embed = media_embed
			}
		}
		if let temp = data["subreddit"] as? String {
			link.subreddit = temp
		}
		if let temp = data["selftext_html"] as? String {
			link.selftext_html = temp
		}
		if let temp = data["selftext"] as? String {
			link.selftext = temp
		}
		
		if let temp = data["likes"] as? Bool {
			link.likes = temp
		}
		
		//            if let temp = data["user_reports"] as? {
		//                link.user_reports = temp
		//            }
		//
		//            if let temp = data["secure_media"] as? {
		//                link.secure_media = temp
		//            }
		
		if let temp = data["link_flair_text"] as? String {
			link.link_flair_text = temp
		}
		if let temp = data["id"] as? String {
			link.id = temp
		}
		if let temp = data["gilded"] as? Int {
			link.gilded = temp
		}
		if let temp = data["archived"] as? Bool {
			link.archived = temp
		}
		if let temp = data["clicked"] as? Bool {
			link.clicked = temp
		}
		
		//            if let temp = data["report_reasons"] as? {
		//                link.report_reasons = temp
		//            }
		
		if let temp = data["author"] as? String {
			link.author = temp
		}
		
		if let temp = data["num_comments"] as? Int {
			link.num_comments = temp
		}
		if let temp = data["score"] as? Int {
			link.score = temp
		}
		if let temp = data["approved_by"] as? String {
			link.approved_by = temp
		}
		if let temp = data["over_18"] as? Bool {
			link.over_18 = temp
		}
		if let temp = data["hidden"] as? Bool {
			link.hidden = temp
		}
		if let temp = data["thumbnail"] as? String {
			link.thumbnail = temp
		}
		if let temp = data["subreddit_id"] as? String {
			link.subreddit_id = temp
		}
		if let temp = data["edited"] as? Bool {
			link.edited = temp
		}
		if let temp = data["link_flair_css_class"] as? String {
			link.link_flair_css_class = temp
		}
		if let temp = data["author_flair_css_class"] as? String {
			link.author_flair_css_class = temp
		}
		if let temp = data["downs"] as? Int {
			link.downs = temp
		}
		
		//            if let temp = data["mod_reports"] as? {
		//                link.mod_reports = temp
		//            }
		//
		//            if let temp = data["secure_media_embed"] as? {
		//                link.secure_media_embed = temp
		//            }
		
		if let temp = data["saved"] as? Bool {
			link.saved = temp
		}
		if let temp = data["is_self"] as? Bool {
			link.is_self = temp
		}
		if let temp = data["name"] as? String {
			link.name = temp
		}
		if let temp = data["permalink"] as? String {
			link.permalink = temp
		}
		if let temp = data["stickied"] as? Bool {
			link.stickied = temp
		}
		if let temp = data["created"] as? Int {
			link.created = temp
		}
		if let temp = data["url"] as? String {
			link.url = temp
		}
		if let temp = data["author_flair_text"] as? String {
			link.author_flair_text = temp
		}
		if let temp = data["title"] as? String {
			link.title = temp
		}
		if let temp = data["created_utc"] as? Int {
			link.created_utc = temp
		}
		if let temp = data["ups"] as? Int {
			link.ups = temp
		}
		if let temp = data["upvote_ratio"] as? Double {
			link.upvote_ratio = temp
		}
		
		if let temp = data["media"] as? [String:AnyObject] {
			if temp.count > 0 {
				let media = Media()
				media.updateWithJSON(temp)
				link.media = media
			}
		}
		
		if let temp = data["visited"] as? Bool {
			link.visited = temp
		}
		if let temp = data["num_reports"] as? Int {
			link.num_reports = temp
		}
		if let temp = data["distinguished"] as? Bool {
			link.distinguished = temp
		}
        return link
    }
}
