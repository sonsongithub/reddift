//
//  helper.swift
//  reddift
//
//  Created by sonson on 2015/04/27.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Dictionary {
    /**
    Update value with key.
    */
	mutating func update(other: Dictionary) {
		for (key, value) in other {
			self.updateValue(value, forKey:key)
		}
	}
}


extension Bool {
    var string: String {
        return self ? "true" : "false"
    }
}

private var timeBuffer: timeval = timeval(tv_sec: 0, tv_usec: 0)

func tic() {
    gettimeofday(&timeBuffer, nil)
}

func toc() {
    var time_buffer2: timeval = timeval(tv_sec: 0, tv_usec: 0)
    gettimeofday(&time_buffer2, nil)
    let diff = time_buffer2.tv_sec - timeBuffer.tv_sec
    let diff_u = time_buffer2.tv_usec - timeBuffer.tv_usec
    print("\(diff * 1000000 + diff_u)[msec]")
}
