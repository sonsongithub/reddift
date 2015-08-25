//
//  helper.swift
//  reddift
//
//  Created by sonson on 2015/04/27.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Dictionary {
	mutating func update(other:Dictionary) {
		for (key,value) in other {
			self.updateValue(value, forKey:key)
		}
	}
}

func commaSeparatedStringFromList(list:[String]) -> String {
    var string = ""
    for element in list {
        string = string + element + ","
    }
    if string.characters.count > 1 {
        let range = Range<String.Index>(start: string.endIndex.advancedBy(-1), end: string.endIndex)
        string.removeRange(range)
    }
    return string
}
