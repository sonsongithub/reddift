//
//  Parser.swift
//  reddift
//
//  Created by sonson on 2015/04/20.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class Parser: NSObject {
    class func parseThing(json:[String:AnyObject], depth:Int) -> AnyObject? {
        if let data = json["data"] as? [String:AnyObject], kind = json["kind"] as? String {            
            switch(kind) {
            case "t1":
                // comment
                return parseDataInThing_t1(data)
            case "t2":
                // account
				return parseDataInThing_t2(data)
            case "t3":
                // link
                return parseDataInThing_t3(data)
            case "t4":
                // mesasge
                break
            case "t5":
                // subreddit
				return parseDataInThing_t5(data)
			case "more":
				return parseDataThing_more(data)
            default:
                break
            }
        }
        return nil
    }
    
    class func parseListing(json:[String:AnyObject], depth:Int) -> Listing {
        let listing = Listing()
        if let data = json["data"] as? [String:AnyObject] {
            if let children = data["children"] as? [AnyObject] {
                for child in children {
                    if let child = child as? [String:AnyObject] {
                        let obj:AnyObject? = parseJSON(child, depth: depth + 1)
                        if let obj:AnyObject = obj {
                            listing.children.append(obj)
                        }
                    }
                }
            }
            if let after = data["after"] as? String {
                listing.after = after
            }
            if let before = data["before"] as? String {
                listing.before = before
            }
            if let modhash = data["modhash"] as? String {
                listing.modhash = modhash
            }
        }
        return listing
    }
    
    class func parseJSON(json:AnyObject, depth:Int) -> AnyObject? {
        // array
        // json->[AnyObject]
        if let array = json as? [AnyObject] {
            var output:[AnyObject] = []
            for element in array {
                if let element = element as? [String:AnyObject] {
                    let obj:AnyObject? = self.parseJSON(element, depth:depth)
                    if let obj:AnyObject = obj {
                        output.append(obj)
                    }
                }
            }
            return output;
        }
        // dictionary
        // json->[String:AnyObject]
        else if let json = json as? [String:AnyObject] {
            if let kind = json["kind"] as? String {
                if kind == "Listing" {
                    let listing = parseListing(json, depth:depth)
                    return listing
                }
                else {
                    return parseThing(json, depth:depth)
                }
            }
        }
        return nil
    }
}
