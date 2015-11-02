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

private var time_buffer:timeval = timeval(tv_sec: 0, tv_usec: 0)

func tic() {
    gettimeofday(&time_buffer, nil)
}

func toc() {
    var time_buffer2:timeval = timeval(tv_sec: 0, tv_usec: 0)
    gettimeofday(&time_buffer2, nil)
    
    let diff = time_buffer2.tv_sec - time_buffer.tv_sec
    let diff_u = time_buffer2.tv_usec - time_buffer.tv_usec

    
    
    print("\(diff * 1000000 + diff_u)[msec]")
}

//func toc() -> Int32 {
//    var time_buffer2:timeval = timeval(tv_sec: 0, tv_usec: 0)
//    gettimeofday(&time_buffer2, nil)
//    return (time_buffer2.tv_sec * 1000000 + time_buffer2.tv_usec) - (time_buffer.tv_sec * 1000000 + time_buffer.tv_usec)
//}
