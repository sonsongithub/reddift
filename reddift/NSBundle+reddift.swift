//
//  NSBundle+reddift.swift
//  reddift
//
//  Created by sonson on 2015/04/13.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

extension NSBundle {
	/**
	Returns object from default info.plist.
	
	:param: key key for value
	:returns: Value
	*/
	class func infoValueFromMainBundleForKey(key:String) -> AnyObject? {
		if let obj:AnyObject = self.mainBundle().localizedInfoDictionary?[key] {
			return obj;
		}
		if let obj:AnyObject = self.mainBundle().infoDictionary?[key] {
			return obj;
		}
		return nil;
	}
}