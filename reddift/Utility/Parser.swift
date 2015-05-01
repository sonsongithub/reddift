//
//  Parser.swift
//  reddift
//
//  Created by sonson on 2015/04/20.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class Parser: NSObject {
    class func parseThing(json:[String:AnyObject]) -> AnyObject? {
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
				return parseDataInThing_t4(data)
            case "t5":
                // subreddit
				return parseDataInThing_t5(data)
			case "more":
				return parseDataInThing_more(data)
            default:
                break
            }
        }
        return nil
    }
    
    class func parseListing(json:[String:AnyObject]) -> Listing {
        let listing = Listing()
        if let data = json["data"] as? [String:AnyObject] {
            if let children = data["children"] as? [AnyObject] {
                for child in children {
                    if let child = child as? [String:AnyObject] {
                        let obj:AnyObject? = parseJSON(child)
                        if let obj = obj as? Thing {
                            if let more = obj as? More {
                                listing.more = more
                            }
                            else {
                                listing.children.append(obj)
                            }
                        }
                    }
                }
            }
            
            if data["after"] != nil || data["before"] != nil {
                var a:String = ""
                var b:String = ""
                if let after = data["after"] as? String {
                    if !after.isEmpty {
                        a = after
                    }
                }
                if let before = data["before"] as? String {
                    if !before.isEmpty {
                        b = before
                    }
                }
                
                if !a.isEmpty || !b.isEmpty {
                    var paginator = Paginator(after: a, before: b, modhash: "")
                    if let modhash = data["modhash"] as? String {
                        paginator.modhash = modhash
                    }
                    listing.paginator = paginator
                }
            }
        }
        return listing
    }

    class func parseJSON(json:AnyObject) -> AnyObject? {
        // array
        // json->[AnyObject]
        if let array = json as? [AnyObject] {
            var output:[AnyObject] = []
            for element in array {
                if let element = element as? [String:AnyObject] {
                    let obj:AnyObject? = self.parseJSON(element)
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
                    let listing = parseListing(json)
                    return listing
                }
                else {
                    return parseThing(json)
                }
            }
        }
        return nil
    }
}
