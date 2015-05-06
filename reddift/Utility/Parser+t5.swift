//
//  Parser+t5.swift
//  reddift
//
//  Created by sonson on 2015/04/21.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Parser {
	class func parseDataInThing_t5(data:[String:AnyObject]) -> Thing {
		var subreddit = Subreddit()
		if let temp = data["banner_img"] as? String {
			subreddit.banner_img = temp
		}
		if let temp = data["user_sr_theme_enabled"] as? Bool {
			subreddit.user_sr_theme_enabled = temp
		}
		if let temp = data["submit_text_html"] as? String {
			subreddit.submit_text_html = temp
		}
		if let temp = data["user_is_banned"] as? Bool {
			subreddit.user_is_banned = temp
		}
		if let temp = data["id"] as? String {
			subreddit.id = temp
		}
		if let temp = data["submit_text"] as? String {
			subreddit.submit_text = temp
		}
		if let temp = data["display_name"] as? String {
			subreddit.display_name = temp
		}
		if let temp = data["header_img"] as? String {
			subreddit.header_img = temp
		}
		if let temp = data["description_html"] as? String {
			subreddit.description_html = temp
		}
		if let temp = data["title"] as? String {
			subreddit.title = temp
		}
		if let temp = data["collapse_deleted_comments"] as? Bool {
			subreddit.collapse_deleted_comments = temp
		}
		if let temp = data["over18"] as? Bool {
			subreddit.over18 = temp
		}
		if let temp = data["public_description_html"] as? String {
			subreddit.public_description_html = temp
		}
		if let temp = data["icon_size"] as? [Int] {
			subreddit.icon_size = temp
		}
		if let temp = data["icon_img"] as? String {
			subreddit.icon_img = temp
		}
		if let temp = data["header_title"] as? String {
			subreddit.header_title = temp
		}
		if let temp = data["description"] as? String {
			subreddit.description = temp
		}
		if let temp = data["submit_link_label"] as? String {
			subreddit.submit_link_label = temp
		}
		if let temp = data["accounts_active"] as? Int {
			subreddit.accounts_active = temp
		}
		if let temp = data["public_traffic"] as? Bool {
			subreddit.public_traffic = temp
		}
		if let temp = data["header_size"] as? [Int] {
			subreddit.header_size = temp
		}
		if let temp = data["subscribers"] as? Int {
			subreddit.subscribers = temp
		}
		if let temp = data["submit_text_label"] as? String {
			subreddit.submit_text_label = temp
		}
		if let temp = data["user_is_moderator"] as? Bool {
			subreddit.user_is_moderator = temp
		}
		if let temp = data["name"] as? String {
			subreddit.name = temp
		}
		if let temp = data["created"] as? Int {
			subreddit.created = temp
		}
		if let temp = data["url"] as? String {
			subreddit.url = temp
		}
		if let temp = data["hide_ads"] as? Bool {
			subreddit.hide_ads = temp
		}
		if let temp = data["created_utc"] as? Int {
			subreddit.created_utc = temp
		}
		if let temp = data["banner_size"] as? [Int] {
			subreddit.banner_size = temp
		}
		if let temp = data["user_is_contributor"] as? Bool {
			subreddit.user_is_contributor = temp
		}
		if let temp = data["public_description"] as? String {
			subreddit.public_description = temp
		}
		if let temp = data["comment_score_hide_mins"] as? Int {
			subreddit.comment_score_hide_mins = temp
		}
		if let temp = data["subreddit_type"] as? String {
			subreddit.subreddit_type = temp
		}
		if let temp = data["submission_type"] as? String {
			subreddit.submission_type = temp
		}
		if let temp = data["user_is_subscriber"] as? Bool {
			subreddit.user_is_subscriber = temp
		}
		return subreddit
	}
}
