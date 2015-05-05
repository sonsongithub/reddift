//
//  NSURLComponents+reddift.swift
//  reddift
//
//  Created by sonson on 2015/05/06.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

extension NSURLComponents {
    func dictionary() -> [String:String] {
        var parameters:[String:String] = [:]
        for queryItem in self.queryItems as! [NSURLQueryItem] {
            parameters[queryItem.name] = queryItem.value
        }
        return parameters
    }
}
