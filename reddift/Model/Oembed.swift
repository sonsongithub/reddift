//
//  Oembed.swift
//  reddift
//
//  Created by sonson on 2015/04/20.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

/**
Media represents the content which is embeded a link.
*/
public class Oembed {
    /**
    example, "http://i.imgur.com",
    */
    var provider_url = ""
    /**
    example, "The Internet's visual storytelling community. Explore, share, and discuss the best visual stories the Internet has to offer.",
    */
    var description = ""
    /**
    example, "Imgur GIF",
    */
    var title = ""
    /**
    example, 245,
    */
    var thumbnail_width = 0
    /**
    example, 333,
    */
    var height = 0
    /**
    example, 245,
    */
    var width = 0
    /**
    example, "&lt;iframe class=\"embedly-embed\" src=\"//cdn.embedly.com/widgets/media.html?src=https%3A%2F%2Fi.imgur.com%2FkhgfcrQ.mp4&amp;src_secure=1&amp;url=http%3A%2F%2Fi.imgur.com%2FkhgfcrQ.gifv&amp;image=http%3A%2F%2Fi.imgur.com%2FkhgfcrQ.gif&amp;key=2aa3c4d5f3de4f5b9120b660ad850dc9&amp;type=video%2Fmp4&amp;schema=imgur\" width=\"245\" height=\"333\" scrolling=\"no\" frameborder=\"0\" allowfullscreen&gt;&lt;/iframe&gt;",
    */
    var html = ""
    /**
    example, "1.0",
    */
    var version = ""
    /**
    example, "Imgur",
    */
    var provider_name = ""
    /**
    example, "http://i.imgur.com/khgfcrQ.gif",
    */
    var thumbnail_url = ""
    /**
    example, "video",
    */
    var type = ""
    /**
    example, 333
    */
    var thumbnail_height = 0
    /**
    Update each property with JSON object.
    
    :param: json JSON object which is included "t2" JSON.
    */
    func updateWithJSON(json:[String:AnyObject]) {
        if let temp = json["provider_url"] as? String {
            self.provider_url = temp
        }
        if let temp = json["description"] as? String {
            self.description = temp
        }
        if let temp = json["title"] as? String {
            self.title = temp
        }
        if let temp = json["thumbnail_width"] as? Int {
            self.thumbnail_width = temp
        }
        if let temp = json["height"] as? Int {
            self.height = temp
        }
        if let temp = json["width"] as? Int {
            self.width = temp
        }
        if let temp = json["html"] as? String {
            self.html = temp
        }
        if let temp = json["version"] as? String {
            self.version = temp
        }
        if let temp = json["provider_name"] as? String {
            self.provider_name = temp
        }
        if let temp = json["thumbnail_url"] as? String {
            self.thumbnail_url = temp
        }
        if let temp = json["type"] as? String {
            self.type = temp
        }
        if let temp = json["thumbnail_height"] as? Int {
            self.thumbnail_height = temp
        }
    }
}