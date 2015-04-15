//
//  Session+listings.swift
//  reddift
//
//  Created by sonson on 2015/04/15.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

enum ListingSortType {
    case Controversial
    case Hot
    case New
    case Top
    
    func path () -> String {
        switch self{
        case ListingSortType.Controversial:
            return "controversial"
        case ListingSortType.Hot:
            return "hot"
        case ListingSortType.New:
            return "new"
        case ListingSortType.Top:
            return "top"
        default :
            return ""
        }
    }
}

extension Session {
    
    func parseLinkListJSON(json:[String:AnyObject]) -> ([Link], Paginator?) {
        if let kind = json["kind"] as? String, data = json["data"] as? [String:AnyObject] {
            if kind == "Listing" {
                if let children = data["children"] as? [AnyObject] {
                    var links:[Link] = []
                    let paginator = Paginator()
                    for obj in children {
                        if let obj = obj as? [String:AnyObject] {
                            if let kind = obj["kind"] as? String, link = obj["data"] as? [String:AnyObject] {
                                if kind == "t3" {
                                    links.append(Link(json:link))
                                }
                            }
                        }
                    }
                    if let modhash = data["modhash"] as? String {
                        println("modhash=> \(modhash)")
                    }
                    if let after = data["after"] as? String {
                        paginator.after = after
                    }
                    if let before = data["before"] as? String {
                        paginator.before = before
                    }
                    return (links, paginator)
                }
            }
        }
        return ([], nil)
    }
    
    func linkList(paginator:Paginator?, sortingType:ListingSortType, completion:(links:[Link], paginator:Paginator?, error:NSError?)->Void) -> NSURLSessionDataTask {
        var parameter:[String:String] = [:]
        
        if let paginator = paginator {
            if paginator.sortingType == sortingType {
                parameter = paginator.parameters()
            }
        }
        
        var URLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/" + sortingType.path(), parameter:parameter, method:"GET", token:token)
        
        let task = URLSession.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(links:[], paginator: nil, error: error)
                })
            }
            else {
                if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
                    let (links, paginator) = self.parseLinkListJSON(json)
                    if links.count > 0 && paginator != nil {
                        paginator?.sortingType = sortingType;
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(links:links, paginator:paginator, error:nil)
                        })
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completion(links:links, paginator:paginator, error:NSError.errorWithCode(0, userinfo: ["error":"Can not get any contents expectedly."]))
                        })
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(links:[], paginator: nil, error:NSError.errorWithCode(0, userinfo: ["error":"Can not parse response object."]))
                    })
                }
            }
        })
        task.resume()
        return task
    }
}
