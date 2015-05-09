//
//  Paginator.swift
//  reddift
//
//  Created by sonson on 2015/04/14.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
Paginator object for paiging listing object.
*/
public class Paginator : Thing {
	var after:String
	var before:String
    var modhash:String
    
    public override init() {
        self.after = ""
        self.before = ""
        self.modhash = ""
        super.init()
    }
	
    public init(after:String, before:String, modhash:String) {
		self.after = after
		self.before = before
        self.modhash = modhash
        super.init()
	}
    
    /**
    Generate dictionary to add query parameters to URL.
    
    :returns: Dictionary object for paging.
    */
    public func parameters() -> [String:String] {
        var dict:[String:String] = [:]
        if count(after) > 0 {
            dict["after"] = after
        }
        if count(before) > 0 {
            dict["before"] = before
        }
        return dict
    }
}
