//
//  Paginator.swift
//  reddift
//
//  Created by sonson on 2015/04/14.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

public class Paginator : Thing {
	var after:String
	var before:String
    var modhash:String
    
    public override init() {
        self.after = ""
        self.before = ""
        self.modhash = ""
    }
	
    public init(after:String, before:String, modhash:String) {
		self.after = after
		self.before = before
        self.modhash = modhash
	}
    
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
