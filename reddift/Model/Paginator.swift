//
//  Paginator.swift
//  reddift
//
//  Created by sonson on 2015/04/14.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class Paginator {
    var after = ""
    var before = ""
    var sortingType = ""
    
    func parameters() -> [String:String] {
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
