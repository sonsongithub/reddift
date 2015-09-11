//
//  NSURLComponents+reddift.swift
//  reddift
//
//  Created by sonson on 2015/05/06.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension NSURLComponents {
    func dictionary() -> [String:String] {
        var parameters:[String:String] = [:]
        if let queryItems = self.queryItems {
            for queryItem in queryItems {
                #if os(iOS)
                    parameters[queryItem.name] = queryItem.value
                #elseif os(OSX)
                    parameters[queryItem.name] = queryItem.value!
                #endif
            }
        }
        return parameters
    }
}
