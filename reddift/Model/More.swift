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
    
    /**
    Parse more object.
    
    :param: data Dictionary, must be generated parsing "more".
    :returns: More object as Thing.
    */
    public init(data:[String:AnyObject]) {
        super.init(id: data["id"] as? String ?? "", kind: "more")
        name = data["name"] as? String ?? ""
        parentId = data["parent_id"] as? String ?? ""
        count = data["count"] as? Int ?? 0
        children = data["children"] as? [String] ?? []
    }
}
