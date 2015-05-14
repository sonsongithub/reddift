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
			subreddit.bannerImg = temp
		}
		if let temp = data["user_sr_theme_enabled"] as? Bool {
			subreddit.userSrThemeEnabled = temp
		}
		if let temp = data["submit_text_html"] as? String {
			subreddit.submitTextHtml = temp
		}
		if let temp = data["user_is_banned"] as? Bool {
			subreddit.userIsBanned = temp
		}
		if let temp = data["id"] as? String {
			subreddit.id = temp
		}
		if let temp = data["submit_text"] as? String {
			subreddit.submitText = temp
		}
		if let temp = data["display_name"] as? String {
			subreddit.displayName = temp
		}
		if let temp = data["header_img"] as? String {
			subreddit.headerImg = temp
		}
		if let temp = data["description_html"] as? String {
			subreddit.descriptionHtml = temp
		}
		if let temp = data["title"] as? String {
			subreddit.title = temp
		}
		if let temp = data["collapse_deleted_comments"] as? Bool {
			subreddit.collapseDeletedComments = temp
		}
		if let temp = data["over18"] as? Bool {
			subreddit.over18 = temp
		}
		if let temp = data["public_description_html"] as? String {
			subreddit.publicDescriptionHtml = temp
		}
		if let temp = data["icon_size"] as? [Int] {
			subreddit.iconSize = temp
		}
		if let temp = data["icon_img"] as? String {
			subreddit.iconImg = temp
		}
		if let temp = data["header_title"] as? String {
			subreddit.headerTitle = temp
		}
		if let temp = data["description"] as? String {
			subreddit.description = temp
		}
		if let temp = data["submit_link_label"] as? String {
			subreddit.submitLinkLabel = temp
		}
		if let temp = data["accounts_active"] as? Int {
			subreddit.accountsActive = temp
		}
		if let temp = data["public_traffic"] as? Bool {
			subreddit.publicTraffic = temp
		}
		if let temp = data["header_size"] as? [Int] {
			subreddit.headerSize = temp
		}
		if let temp = data["subscribers"] as? Int {
			subreddit.subscribers = temp
		}
		if let temp = data["submit_text_label"] as? String {
			subreddit.submitTextLabel = temp
		}
		if let temp = data["user_is_moderator"] as? Bool {
			subreddit.userIsModerator = temp
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
			subreddit.hideAds = temp
		}
		if let temp = data["created_utc"] as? Int {
			subreddit.createdUtc = temp
		}
		if let temp = data["banner_size"] as? [Int] {
			subreddit.bannerSize = temp
		}
		if let temp = data["user_is_contributor"] as? Bool {
			subreddit.userIsContributor = temp
		}
		if let temp = data["public_description"] as? String {
			subreddit.publicDescription = temp
		}
		if let temp = data["comment_score_hide_mins"] as? Int {
			subreddit.commentScoreHideMins = temp
		}
		if let temp = data["subreddit_type"] as? String {
			subreddit.subredditType = temp
		}
		if let temp = data["submission_type"] as? String {
			subreddit.submissionType = temp
		}
		if let temp = data["user_is_subscriber"] as? Bool {
			subreddit.userIsSubscriber = temp
		}
		return subreddit
	}
}
