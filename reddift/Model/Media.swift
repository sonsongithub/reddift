//
//  Media.swift
//  reddift
//
//  Created by sonson on 2015/04/20.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class Media {
    /**
    example "i.imgur.com"
    */
    var type = ""
    /**
    oembed object
    */
    var oembed:Oembed = Oembed()
    
    func updateWithJSON(json:[String:AnyObject]) {
        if let temp = json["type"] as? String {
            self.type = temp
        }
        if let temp = json["oembed"] as? [String:AnyObject] {
            self.oembed.updateWithJSON(temp)
        }
    }
	
	func toString() -> String {
		return "{type=\(type)}\n"
	}
}
