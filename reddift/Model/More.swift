//
//  More.swift
//  reddift
//
//  Created by sonson on 2015/04/21.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class More : Thing {
	var parent_id = ""
	var count = 0
	var children:[String] = []
	
	override func toString() -> String {
		var buf = "more\n"
		for child in children {
			buf += (child + ",")
		}
		buf += "\n"
		return buf
	}
}
