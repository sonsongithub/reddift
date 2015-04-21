//
//  Thing.swift
//  reddift
//
//  Created by sonson on 2015/04/20.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class Thing {
	var id = ""
	var name = ""
    var kind = ""
	
	func toString() -> String {
		return "id=\(id)\n name=\(name)\n kind=\(kind)\n"
	}
}
