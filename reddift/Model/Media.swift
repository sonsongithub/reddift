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
public struct Media {
    /**
    example "i.imgur.com"
    */
    public var type:String
    /**
    oembed object
    */
    public var oembed:Oembed
    /**
    Update each property with JSON object.
    
    :param: json JSON object which is included "t2" JSON.
    */
    public init(json:JSONDictionary) {
		type = json["type"] as? String ?? ""
        oembed = Oembed(json:(json["oembed"] as? JSONDictionary ?? [:]))
    }
	
	public func toString() -> String {
		return "{type=\(type)}\n"
	}
}
