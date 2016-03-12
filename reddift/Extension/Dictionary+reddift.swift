//
//  Dictionary+reddift.swift
//  reddift
//
//  Created by sonson on 2015/09/17.
//  Copyright © 2015年 sonson. All rights reserved.
//

import Foundation

/**
Protocol to generate URL query string from Dictionary[String:String].
*/
protocol QueryEscapableString {
    var stringByAddingPercentEncoding: String { get }
}

extension String: QueryEscapableString {
    /**
    Returns string by adding percent encoding in UTF-8
    Protocol to generate URL query string from Dictionary[String:String].
    */
    var stringByAddingPercentEncoding: String {
        get {
            let set = NSCharacterSet.alphanumericCharacterSet()
            return self.stringByAddingPercentEncodingWithAllowedCharacters(set) ?? self
        }
    }
}

/**
Protocol to generate URL query string from Dictionary[String:String].
*/
extension Dictionary where Key: QueryEscapableString, Value: QueryEscapableString {
    /**
    Gets escped string.
    - returns: Returns string by adding percent encoding in UTF-8
    */
    func URLQueryString() -> String {
        var components: [String] = []
        for (key, value) in self {
            components.append("\(key.stringByAddingPercentEncoding)=\(value.stringByAddingPercentEncoding)")
        }
        return components.joinWithSeparator("&")
    }
}
