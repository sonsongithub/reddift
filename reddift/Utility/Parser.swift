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
    class func parseThing(json:JSONDictionary) -> Any? {
        if let data = json["data"] as? JSONDictionary, kind = json["kind"] as? String {
            switch(kind) {
            case "t1":
                // comment
                return Comment(data:data)
            case "t2":
                // account
                return Account(data:data)
            case "t3":
                // link
                return Link(data:data)
            case "t4":
				// mesasge
                return Message(data:data)
            case "t5":
                // subreddit
                return Subreddit(data:data)
            case "t6":
                // trophy
                return Trophy(data:data)
			case "more":
                return More(data:data)
            case "LabeledMulti":
                return Multireddit(json: data) as Multireddit
            case "LabeledMultiDescription":
                return MultiredditDescription(json: data)
            case "UserList":
                return parseUserList(data)
            case "TrophyList":
                return parseTrophyList(data)
            default:
                break
            }
        }
        else if let data = json["data"] as? JSONArray, kind = json["kind"] as? String {
            switch(kind) {
            case "KarmaList":
                return parseSubredditKarmaList(data)
            default:
                break
            }
        }
        return nil
    }
    
    /**
     Parse more list
     Parse json object to extract a list which is composed of Comment and More.
    */
    class func parseCommentAndMoreJSON(json:JSON) -> ([Thing], NSError?) {
        if let json = json as? JSONDictionary {
            if let root = json["json"] as? JSONDictionary {
                if let data = root["data"] as? JSONDictionary {
                    if let things = data["things"] as? [JSONDictionary] {
                        let r = things
                            .flatMap { Parser.parseThing($0) }
                            .flatMap { $0 as? Thing }
                        return (r, nil)
                    }
                }
                if let _ = json["errors"] {
                    // There is not any specifigations of error messages.
                    // How do I handle it?av
                }
            }
        }
        return ([], ReddiftError.ParseMoreError.error)
    }
    
    /**
    Parse User list
    */
    class func parseUserList(json:JSONDictionary) -> [User] {
        var result:[User] = []
        if let children = json["children"] as? [[String:AnyObject]] {
            children.forEach({
                if let date = $0["date"] as? Double,
                    let name = $0["name"] as? String,
                    let id = $0["id"] as? String {
                    result.append(User(date: date, permissions: $0["mod_permissions"] as? [String], name: name, id: id))
                }
            })
        }
        return result
    }
    
    /**
     Parse SubredditKarma list
     */
    class func parseSubredditKarmaList(array:JSONArray) -> [SubredditKarma] {
        var result:[SubredditKarma] = []
        if let children = array as? [[String:AnyObject]] {
            children.forEach({
                if let sr = $0["sr"] as? String,
                    let comment_karma = $0["comment_karma"] as? Int,
                    let link_karma = $0["link_karma"] as? Int {
                        result.append(SubredditKarma(subreddit: sr, commentKarma: comment_karma, linkKarma: link_karma))
                }
            })
        }
        return result
    }
    
    /**
     Parse Trophy list
     */
    class func parseTrophyList(json:JSONDictionary) -> [Trophy] {
        var result:[Trophy] = []
        if let children = json["trophies"] as? [[String:AnyObject]] {
            result.appendContentsOf(children.flatMap({ parseThing($0) as? Trophy }))
        }
        return result
    }
	
	/**
	Parse list object in JSON
	*/
    class func parseListing(json:JSONDictionary) -> Listing {
        var list:[Thing] = []
        var paginator:Paginator? = Paginator()
        
        if let data = json["data"] as? JSONDictionary {
            if let children = data["children"] as? JSONArray {
                for child in children {
                    if let child = child as? JSONDictionary {
                        let obj:Any? = parseJSON(child)
                        if let obj = obj as? Thing {
                            list.append(obj)
                        }
                    }
                }
            }
            
            if data["after"] != nil || data["before"] != nil {
                let a:String = data["after"] as? String ?? ""
                let b:String = data["before"] as? String ?? ""
                
                if !a.isEmpty || !b.isEmpty {
                    paginator = Paginator(after: a, before: b, modhash: data["modhash"] as? String ?? "")
                }
            }
        }
        return Listing(children:list, paginator: paginator ?? Paginator())
    }
    
	/**
	Parse JSON of the style which is Thing.
	*/
    class func parseJSON(json:JSON) -> RedditAny? {
        // array
        // json->[AnyObject]
        if let array = json as? JSONArray {
            var output:[Any] = []
            for element in array {
                if let element = element as? JSONDictionary {
                    let obj:Any? = self.parseJSON(element)
                    if let obj:Any = obj {
                        output.append(obj)
                    }
                }
            }
            return output;
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
