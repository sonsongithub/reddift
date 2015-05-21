//
//  Session+multis.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
    public typealias RedditColor = UIColor
    #elseif os(OSX)
    import Cocoa
    public typealias RedditColor = NSColor
#endif

func parseMultiFromJSON(json: JSON) -> Result<Multireddit> {
    if let kind = json["kind"] as? String {
        if kind == "LabeledMulti" {
            if let data = json["data"] as? [String:AnyObject] {
                let obj = Multireddit(json: data)
                return Result(value: obj)
            }
        }
    }
    return Result(error: ReddiftError.ParseThing.error)
}

extension Session {
    /**
    Create a new multi. Responds with 409 Conflict if it already exists.
    
    :param: multipath Multireddit url path
    :param: displayName A string no longer than 50 characters.
    :param: descriptionMd Raw markdown text.
    :param: iconName Icon name as MultiIconName.
    :param: keyColor Color. as RedditColor object.(does not implement. always uses white.)
    :param: subreddits List of subreddits as String array.
    :param: visibility Visibility as MultiVisibilityType.
    :param: weightingScheme One of `classic` or `fresh`.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    func createMulti(displayName:String, descriptionMd:String, iconName:MultiredditIconName = .None, keyColor:RedditColor = RedditColor.whiteColor(), visibility:MultiredditVisibility = .Private, weightingScheme:String = "classic", completion:(Result<Multireddit>) -> Void) -> NSURLSessionDataTask? {
        var multipath = "/user/\(token.name)/m/\(displayName)"
        var json:[String:AnyObject] = [:]
        var names:[[String:String]] = []
        json["description_md"] = descriptionMd
        json["display_name"] = displayName
        json["icon_name"] = ""
        json["key_color"] = "#FFFFFF"
        json["subreddits"] = names
        json["visibility"] = "private"
        json["weighting_scheme"] = "classic"
        
        if let data:NSData = NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.allZeros, error: nil) {
            if let jsonString = NSString(data: data, encoding: NSUTF8StringEncoding) {
                let customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
                let escapedJsonString = jsonString.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
                if let escapedJsonString = escapedJsonString {
                    var parameter:[String:String] = ["model":escapedJsonString]
                    
                    var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/multi/" + multipath, parameter:parameter, method:"POST", token:token)
                    let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
                        self.updateRateLimitWithURLResponse(response)
                        let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
                        let result = responseResult >>> parseResponse >>> decodeJSON >>> parseMultiFromJSON
                        completion(result)
                    })
                    task.resume()
                }
            }
        }
        
        return nil
    }
    
    /**
    Copy the muliti.
    
    :param: multi Multi object to be copied.
    :returns: Data task which requests search to reddit.com.
    */
    func copyMulti(multi:Multireddit, newDisplayName:String, completion:(Result<Multireddit>) -> Void) -> NSURLSessionDataTask? {
        var error:NSError? = nil
        let regex = NSRegularExpression(pattern:"/[^/]+?$",
            options: .CaseInsensitive,
            error: &error)
        
        let to = regex?.stringByReplacingMatchesInString(multi.path, options: .allZeros, range: NSMakeRange(0, count(multi.path)), withTemplate: "/" + newDisplayName)
        
        var parameter:[String:String] = [:]
        parameter["display_name"] = newDisplayName
        parameter["from"] = multi.path
        parameter["to"] = to
        var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/multi/copy", parameter:parameter, method:"POST", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseMultiFromJSON
            completion(result)
        })
        task.resume()
        return task
    }

    /**
    Delete the multi.
    
    :param: multi Multi object to be deleted.
    :returns: Data task which requests search to reddit.com.
    */
    func deleteMulti(multi:Multireddit, completion:(Result<NSData>) -> Void) -> NSURLSessionDataTask? {
        var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/multi/" + multi.path, method:"DELETE", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Update the multi. Responds with 409 Conflict if it already exists.
    
    :param: multi Multi object to be updated.
    :returns: Data task which requests search to reddit.com.
    */
    func updateMulti(multi:Multireddit, completion:(Result<Multireddit>) -> Void) -> NSURLSessionDataTask? {
        var multipath = multi.path
        var json:[String:AnyObject] = [:]
        var names:[[String:String]] = []
        
        json["description_md"] = multi.descriptionMd
        json["display_name"] = multi.name
        json["icon_name"] = multi.iconName.rawValue
        json["key_color"] = "#FFFFFF"
        json["subreddits"] = names
        json["visibility"] = multi.visibility.rawValue
        json["weighting_scheme"] = "classic"
        
        if let data:NSData = NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.allZeros, error: nil) {
            if let jsonString = NSString(data: data, encoding: NSUTF8StringEncoding) {
                let customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
                let escapedJsonString = jsonString.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
                if let escapedJsonString:String = escapedJsonString {
                    var parameter:[String:String] = ["model":escapedJsonString]
                    
                    var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/multi/" + multipath, parameter:parameter, method:"PUT", token:token)
                    let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
                        self.updateRateLimitWithURLResponse(response)
                        let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
                        let result = responseResult >>> parseResponse >>> decodeJSON >>> parseMultiFromJSON
                        completion(result)
                    })
                    task.resume()
                    return task
                }
            }
        }
        
        return nil
    }

    /**
    Get users own multis.
    
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    func getMineMulti(completion:(Result<[Multireddit]>) -> Void) -> NSURLSessionDataTask? {
        var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/multi/mine", method:"GET", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> Parser.parseDataInJSON_Multi
            completion(result)
        })
        task.resume()
        return task
    }
}