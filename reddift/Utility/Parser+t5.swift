//
//  Parser+t5.swift
//  reddift
//
//  Created by sonson on 2015/04/21.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Parser {
	/**
	Parse t5 object.
	
	:param: data Dictionary, must be generated parsing "t5".
	:returns: Subreddit object as Thing.
	*/
	class func parseDataInThing_t5(data:[String:AnyObject]) -> Thing {
		var subreddit = Subreddit()
		subreddit.bannerImg = data["banner_img"] as? String ?? ""
		subreddit.userSrThemeEnabled = data["user_sr_theme_enabled"] as? Bool ?? false
		subreddit.submitTextHtml = data["submit_text_html"] as? String ?? ""
		subreddit.userIsBanned = data["user_is_banned"] as? Bool ?? false
		subreddit.id = data["id"] as? String ?? ""
		subreddit.submitText = data["submit_text"] as? String ?? ""
		subreddit.displayName = data["display_name"] as? String ?? ""
		subreddit.headerImg = data["header_img"] as? String ?? ""
		subreddit.descriptionHtml = data["description_html"] as? String ?? ""
		subreddit.title = data["title"] as? String ?? ""
		subreddit.collapseDeletedComments = data["collapse_deleted_comments"] as? Bool ?? false
		subreddit.over18 = data["over18"] as? Bool ?? false
		subreddit.publicDescriptionHtml = data["public_description_html"] as? String ?? ""
		subreddit.iconSize = data["icon_size"] as? [Int] ?? []
		subreddit.iconImg = data["icon_img"] as? String ?? ""
		subreddit.headerTitle = data["header_title"] as? String ?? ""
		subreddit.description = data["description"] as? String ?? ""
		subreddit.submitLinkLabel = data["submit_link_label"] as? String ?? ""
		subreddit.accountsActive = data["accounts_active"] as? Int ?? 0
		subreddit.publicTraffic = data["public_traffic"] as? Bool ?? false
		subreddit.headerSize = data["header_size"] as? [Int] ?? []
		subreddit.subscribers = data["subscribers"] as? Int ?? 0
		subreddit.submitTextLabel = data["submit_text_label"] as? String ?? ""
		subreddit.userIsModerator = data["user_is_moderator"] as? Bool ?? false
		subreddit.name = data["name"] as? String ?? ""
		subreddit.created = data["created"] as? Int ?? 0
		subreddit.url = data["url"] as? String ?? ""
		subreddit.hideAds = data["hide_ads"] as? Bool ?? false
		subreddit.createdUtc = data["created_utc"] as? Int ?? 0
		subreddit.bannerSize = data["banner_size"] as? [Int] ?? []
		subreddit.userIsContributor = data["user_is_contributor"] as? Bool ?? false
		subreddit.publicDescription = data["public_description"] as? String ?? ""
		subreddit.commentScoreHideMins = data["comment_score_hide_mins"] as? Int ?? 0
		subreddit.subredditType = data["subreddit_type"] as? String ?? ""
		subreddit.submissionType = data["submission_type"] as? String ?? ""
		subreddit.userIsSubscriber = data["user_is_subscriber"] as? Bool ?? false
		return subreddit
	}
}
