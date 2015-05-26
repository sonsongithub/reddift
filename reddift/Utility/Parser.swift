//
//  Parser.swift
//  reddift
//
//  Created by sonson on 2015/04/20.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
Uitility class.
Parser class parses JSON and generates objects from it.
*/
class Parser: NSObject {
	/**
	Parse thing object in JSON.
	This method dispatches element of JSON to eithr methods to extract classes derived from Thing class.
	*/
    class func parseThing(json:JSONDictionary) -> Thing? {
        if let data = json["data"] as? JSONDictionary, kind = json["kind"] as? String {
            switch(kind) {
            case "t1":
                // comment
                return Thing(Comment(data:data))
            case "t2":
                // account
                return Thing(Account(data:data))
            case "t3":
                // link
                return Thing(Link(data:data))
            case "t4":
				// mesasge
                return Thing(Message(data:data))
            case "t5":
                // subreddit
                return Thing(Subreddit(data:data))
			case "more":
                return Thing(More(data:data))
            case "LabeledMulti":
                return Thing(Multireddit(json: data))
            case "LabeledMultiDescription":
                return Thing(MultiredditDescription(json: data))
            default:
                break
            }
        }
        return nil
    }
	
	/**
	Parse list object in JSON
	*/
    class func parseListing(json:JSONDictionary) -> Thing {
        var listing = Listing()
        if let data = json["data"] as? JSONDictionary {
            if let children = data["children"] as? JSONArray {
                for child in children {
                    if let child = child as? JSONDictionary {
                        let obj:Thing? = parseJSON(child)
                        if let obj = obj {
                            listing.children.append(obj)
                        }
                    }
                }
            }
            
            if data["after"] != nil || data["before"] != nil {
                var a:String = data["after"] as? String ?? ""
                var b:String = data["before"] as? String ?? ""
                
                if !a.isEmpty || !b.isEmpty {
                    var paginator = Paginator(after: a, before: b, modhash: data["modhash"] as? String ?? "")
                    listing.paginator = paginator
                }
            }
        }
        return Thing(listing)
    }
	
	/**
	Parse JSON of the style which is Thing.
	*/
    class func parseJSON(json:JSON) -> Thing? {
        // array
        // json->[AnyObject]
        if let array = json as? JSONArray {
            var output:[Thing] = []
            for element in array {
                if let element = element as? JSONDictionary {
                    let obj:Thing? = self.parseJSON(element)
                    if let obj = obj {
                        output.append(obj)
                    }
                }
            }
            return Thing(output);
        }
		// dictionary
		// json->JSONDictionary
        else if let json = json as? JSONDictionary {
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
