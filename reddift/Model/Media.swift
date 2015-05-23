//
//  Media.swift
//  reddift
//
//  Created by sonson on 2015/04/20.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
Media represents the content which is embeded a link.
*/
public class Media {
    /**
    example "i.imgur.com"
    */
    public var type = ""
    /**
    oembed object
    */
    public var oembed:Oembed = Oembed()
    /**
    Update each property with JSON object.
    
    :param: json JSON object which is included "t2" JSON.
    */
    func updateWithJSON(json:JSONDictionary) {
		type = json["type"] as? String ?? ""
        if let temp = json["oembed"] as? JSONDictionary {
            self.oembed.updateWithJSON(temp)
        }
    }
	
	public func toString() -> String {
		return "{type=\(type)}\n"
	}
}
