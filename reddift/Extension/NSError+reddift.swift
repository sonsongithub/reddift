//
//  NSError+reddift.swift
//  reddift
//
//  Created by sonson on 2015/04/12.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

extension NSError {
    class func errorWithCode(code:Int, userinfo:[NSObject:AnyObject]?) -> NSError {
        return NSError(domain:Config.sharedInstance.bundleIdentifier, code:code, userInfo:userinfo)
    }
}