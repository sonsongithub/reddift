//
//  Listing.swift
//  reddift
//
//  Created by sonson on 2015/04/20.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class Listing {
    var after = ""
    var before = ""
    var modhash = ""
    var children:[AnyObject] = []
	
	func toString() -> String {
		var buf = ""
		for child in children {
			if let child = child as? Thing {
				buf += child.toString()
			}
		}
		return buf
	}
	
	func paginator() -> Paginator {
		return Paginator(after: after, before: before)
	}
}
