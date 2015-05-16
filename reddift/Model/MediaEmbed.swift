//
//  MediaEmbed.swift
//  reddift
//
//  Created by sonson on 2015/04/21.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
Media represents the content which is embeded a link.
*/
public class MediaEmbed {
	/// Height of content.
	var height = 0
	/// Width of content.
	var width = 0
	/// Information of content.
	var content = ""
	/// Is content scrolled?
    var scrolling = false
	
    /**
    Update each property with JSON object.
    
    :param: json JSON object which is included "t2" JSON.
    */
    func updateWithJSON(json:[String:AnyObject]) {
        if let temp = json["height"] as? Int {
            self.height = temp
        }
        if let temp = json["width"] as? Int {
            self.width = temp
        }
        if let temp = json["content"] as? String {
            self.content = temp
        }
        if let temp = json["scrolling"] as? Bool {
            self.scrolling = temp
        }
    }
	
	func toString() -> String {
		return "{content=\(content)\nsize=\(width)x\(height)}\n"
	}
}
