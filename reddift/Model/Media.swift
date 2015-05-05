//
//  Media.swift
//  reddift
//
//  Created by sonson on 2015/04/20.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

public class Media {
    /**
    example "i.imgur.com"
    */
    public var type = ""
    /**
    oembed object
    */
    public var oembed:Oembed = Oembed()
    
    public func updateWithJSON(json:[String:AnyObject]) {
        if let temp = json["type"] as? String {
            self.type = temp
        }
        if let temp = json["oembed"] as? [String:AnyObject] {
            self.oembed.updateWithJSON(temp)
        }
    }
	
	public func toString() -> String {
		return "{type=\(type)}\n"
	}
}
