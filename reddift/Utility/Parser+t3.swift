//
//  Parser+t3.swift
//  reddift
//
//  Created by sonson on 2015/04/21.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Parser {
    /**
    Parse t3 object.
    
    :param: data Dictionary, must be generated parsing "t3".
    :returns: Link object as Thing.
    */
    class func parseDataInThing_t3(data:[String:AnyObject]) -> Thing {
        let link = Link()
        link.domain = data["domain"] as? String ?? ""
        link.bannedBy = data["banned_by"] as? String ?? ""
        link.subreddit = data["subreddit"] as? String ?? ""
        link.selftextHtml = data["selftext_html"] as? String ?? ""
        link.selftext = data["selftext"] as? String ?? ""
        link.likes = data["likes"] as? Bool ?? nil
        link.linkFlairText = data["link_flair_text"] as? String ?? ""
        link.id = data["id"] as? String ?? ""
        link.gilded = data["gilded"] as? Int ?? 0
        link.archived = data["archived"] as? Bool ?? false
        link.clicked = data["clicked"] as? Bool ?? false
        link.author = data["author"] as? String ?? ""
        link.numComments = data["num_comments"] as? Int ?? 0
        link.score = data["score"] as? Int ?? 0
        link.approvedBy = data["approved_by"] as? String ?? ""
        link.over18 = data["over_18"] as? Bool ?? false
        link.hidden = data["hidden"] as? Bool ?? false
        link.thumbnail = data["thumbnail"] as? String ?? ""
        link.subredditId = data["subreddit_id"] as? String ?? ""
        link.edited = data["edited"] as? Bool ?? false
        link.linkFlairCssClass = data["link_flair_css_class"] as? String ?? ""
        link.authorFlairCssClass = data["author_flair_css_class"] as? String ?? ""
        link.downs = data["downs"] as? Int ?? 0
        link.saved = data["saved"] as? Bool ?? false
        link.isSelf = data["is_self"] as? Bool ?? false
        link.name = data["name"] as? String ?? ""
        link.permalink = data["permalink"] as? String ?? ""
        link.stickied = data["stickied"] as? Bool ?? false
        link.created = data["created"] as? Int ?? 0
        link.url = data["url"] as? String ?? ""
        link.authorFlairText = data["author_flair_text"] as? String ?? ""
        link.title = data["title"] as? String ?? ""
        link.createdUtc = data["created_utc"] as? Int ?? 0
        link.ups = data["ups"] as? Int ?? 0
        link.upvoteRatio = data["upvote_ratio"] as? Double ?? 0
        link.visited = data["visited"] as? Bool ?? false
        link.numReports = data["num_reports"] as? Int ?? 0
        link.distinguished = data["distinguished"] as? Bool ?? false
        if let temp = data["media"] as? [String:AnyObject] {
            if temp.count > 0 {
                let media = Media()
                media.updateWithJSON(temp)
                link.media = media
            }
        }
        if let temp = data["media_embed"] as? [String:AnyObject] {
            if temp.count > 0 {
                let media_embed = MediaEmbed()
                media_embed.updateWithJSON(temp)
                link.mediaEmbed = media_embed
            }
        }
        return link
    }
}
