//
//  Parser+t1.swift
//  reddift
//
//  Created by sonson on 2015/04/21.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Parser {
    /**
    Parse t1 Thing.
    
    :param: data Dictionary, must be generated parsing t1 Thing.
    :returns: Comment object as Thing.
    */
    class func parseDataInThing_t1(data:[String:AnyObject]) -> Thing {
        let comment = Comment()
        comment.subredditId = data["subreddit_id"] as? String ?? ""
        comment.bannedBy = data["banned_by"] as? String ?? ""
        comment.linkId = data["link_id"] as? String ?? ""
        comment.likes = data["likes"] as? String ?? ""
        comment.saved = data["saved"] as? Bool ?? false
        comment.id = data["id"] as? String ?? ""
        comment.gilded = data["gilded"] as? Int ?? 0
        comment.archived = data["archived"] as? Bool ?? false
        comment.author = data["author"] as? String ?? ""
        comment.parentId = data["parent_id"] as? String ?? ""
        comment.score = data["score"] as? Int ?? 0
        comment.approvedBy = data["approved_by"] as? String ?? ""
        comment.controversiality = data["controversiality"] as? Int ?? 0
        comment.body = data["body"] as? String ?? ""
        comment.edited = data["edited"] as? Bool ?? false
        comment.authorFlairCssClass = data["author_flair_css_class"] as? String ?? ""
        comment.downs = data["downs"] as? Int ?? 0
        comment.bodyHtml = data["body_html"] as? String ?? ""
        comment.subreddit = data["subreddit"] as? String ?? ""
        comment.scoreHidden = data["score_hidden"] as? Bool ?? false
        comment.name = data["name"] as? String ?? ""
        comment.created = data["created"] as? Int ?? 0
        comment.authorFlairText = data["author_flair_text"] as? String ?? ""
        comment.createdUtc = data["created_utc"] as? Int ?? 0
        comment.distinguished = data["distinguished"] as? Bool ?? false
        comment.numReports = data["num_reports"] as? Int ?? 0
        comment.ups = data["ups"] as? Int ?? 0
        if let temp = data["replies"] as? [String:AnyObject] {
            if let obj = parseJSON(temp) as? Listing {
                comment.replies = obj
            }
        }
        return comment
    }
    
    /**
    Parse more object.
    
    :param: data Dictionary, must be generated parsing "more".
    :returns: More object as Thing.
    */
    class func parseDataInThing_more(data:[String:AnyObject]) -> Thing {
        let more = More()
        more.id = data["id"] as? String ?? ""
        more.name = data["name"] as? String ?? ""
        more.parentId = data["parent_id"] as? String ?? ""
        more.count = data["count"] as? Int ?? 0
        more.children = data["children"] as? [String] ?? []
        return more
    }
}
