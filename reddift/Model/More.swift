//
//  More.swift
//  reddift
//
//  Created by sonson on 2015/04/21.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
More object.
"more" is included in Listing object(Maybe).
If Listing object has "more" object, it has mure more children to be downloaded.
*/
public class More : Thing {
	public var parentId = ""
	public var count = 0
	public var children:[String] = []
	
	public override func toString() -> String {
		var buf = "more\n"
		for child in children {
			buf += (child + ",")
		}
		buf += "\n"
		return buf
	}
}
