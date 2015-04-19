//
//  Parser.swift
//  reddift
//
//  Created by sonson on 2015/04/20.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class Parser: NSObject {

    class func parseThing(json:[String:AnyObject], depth:Int) -> (AnyObject?, Paginator?) {
        if let data = json["data"] as? [String:AnyObject] {
            //            println(data)
            println("----------------------------------------------------------------")
            for (key, value) in data {
                //                println(key)
            }
            if let value = data["replies"] as? [String:AnyObject] {
                parseListing(value, depth:depth)
            }
            //            if let keys = data.keys as? [String] {
            //                for key in keys {
            //                    println(key)
            //                }
            //            }
            //            if let replies = data["replies"] as? [AnyObject] {
            //                println(replies)
            //            }
        }
        if let kind = json["kind"] as? String {
            // comment
            println("\(depth):\(kind)")
        }
        return (nil, nil)
    }
    
    class func parseListing(json:[String:AnyObject], depth:Int) -> (AnyObject?, Paginator?) {
        if let data = json["data"] as? [String:AnyObject] {
            if let children = data["children"] as? [AnyObject] {
                for child in children {
                    if let child = child as? [String:AnyObject] {
                        parseJSON(child, depth: depth + 1)
                    }
                }
            }
        }
        return (nil, nil)
    }
    
    class func parseJSON(json:AnyObject, depth:Int) -> (AnyObject?, Paginator?) {
        
        let kindDict = [
            "t1":"Comment",
            "t2":"Account",
            "t3":"Link",
            "t4":"Message",
            "t5":"Subreddit",
            "t6":"Award",
            "t8":"PromoCampaign"
        ]
        
        // array
        // json->[AnyObject]
        if let array = json as? [AnyObject] {
            for element in array {
                if let element = element as? [String:AnyObject] {
                    self.parseJSON(element, depth:depth)
                }
            }
        }
            // dictionary
            // json->[String:AnyObject]
        else if let json = json as? [String:AnyObject] {
            if let kind = json["kind"] as? String {
                if kind == "Listing" {
                    parseListing(json, depth:depth)
                }
                else {
                    parseThing(json, depth:depth)
                }
            }
        }
        
        return (nil, nil)
    }
}
