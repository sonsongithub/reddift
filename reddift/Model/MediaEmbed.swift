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
    func updateWithJSON(json:JSONDictionary) {
		self.height = json["height"] as? Int ?? 0
		self.width = json["width"] as? Int ?? 0
		self.content = json["content"] as? String ?? ""
		self.scrolling = json["scrolling"] as? Bool ?? false
    }
	
	func toString() -> String {
		return "{content=\(content)\nsize=\(width)x\(height)}\n"
	}
}
