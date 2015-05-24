//
//  Session+multireddit.swift
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

/**
Parse JSON dictionary object to the list of Multireddit.

:param: json JSON dictionary object is generated NSJSONSeirialize class.

:returns: Result object. Result object has any Thing or Listing object, otherwise error object.
*/
func parseMultiredditFromJSON(json: JSON) -> Result<Multireddit> {
    if let json = json as? JSONDictionary {
        if let kind = json["kind"] as? String {
            if kind == "LabeledMulti" {
                if let data = json["data"] as? JSONDictionary {
                    let obj = Multireddit(json: data)
                    return Result(value: obj)
                }
            }
        }
    }
    return Result(error: ReddiftError.ParseThing.error)
}

func parseJSONToSubredditName(json: JSON) -> Result<String> {
    if let json = json as? JSONDictionary {
        if let subreddit = json["name"] as? String {
            return Result(value: subreddit)
        }
    }
    return Result(error: ReddiftError.ParseThing.error)
}

extension Session {
    /**
    Create a new multireddit. Responds with 409 Conflict if it already exists.
    
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
    func createMultireddit(displayName:String, descriptionMd:String, iconName:MultiredditIconName = .None, keyColor:RedditColor = RedditColor.whiteColor(), visibility:MultiredditVisibility = .Private, weightingScheme:String = "classic", completion:(Result<Multireddit>) -> Void) -> NSURLSessionDataTask? {
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
                        let result = responseResult >>> parseResponse >>> decodeJSON >>> parseMultiredditFromJSON
                        completion(result)
                    })
                    task.resume()
                }
            }
        }
        
        return nil
    }
    
    /**
    Copy the mulitireddit.
    
    :param: multi Multireddit object to be copied.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    func copyMultireddit(multi:Multireddit, newDisplayName:String, completion:(Result<Multireddit>) -> Void) -> NSURLSessionDataTask? {
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
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseMultiredditFromJSON
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Rename the mulitireddit.
    
    :param: multi Multireddit object to be copied.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    func renameMultireddit(multi:Multireddit, newDisplayName:String, completion:(Result<Multireddit>) -> Void) -> NSURLSessionDataTask? {
        var error:NSError? = nil
        let regex = NSRegularExpression(pattern:"/[^/]+?$",
            options: .CaseInsensitive,
            error: &error)
        
        let to = regex?.stringByReplacingMatchesInString(multi.path, options: .allZeros, range: NSMakeRange(0, count(multi.path)), withTemplate: "/" + newDisplayName)
        
        var parameter:[String:String] = [:]
        parameter["display_name"] = newDisplayName
        parameter["from"] = multi.path
        parameter["to"] = to
        var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/multi/rename", parameter:parameter, method:"POST", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseMultiredditFromJSON
            completion(result)
        })
        task.resume()
        return task
    }

    /**
    Delete the multi.
    
    :param: multi Multireddit object to be deleted.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    func deleteMultireddit(multi:Multireddit, completion:(Result<String>) -> Void) -> NSURLSessionDataTask? {
        var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/multi/" + multi.path, method:"DELETE", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeAsString
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Update the multireddit. Responds with 409 Conflict if it already exists.
    
    :param: multi Multireddit object to be updated.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    func updateMultireddit(multi:Multireddit, completion:(Result<Multireddit>) -> Void) -> NSURLSessionDataTask? {
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
                        let result = responseResult >>> parseResponse >>> decodeJSON >>> parseMultiredditFromJSON
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
    Add a subreddit to multireddit.
    
    :param: multireddit
    :param: subreddit
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    func addSubredditToMultireddit(multireddit:Multireddit, subredditDisplayName:String, completion:(Result<String>) -> Void) -> NSURLSessionDataTask? {
        let jsonString = "{\"name\":\"\(subredditDisplayName)\"}"
        let customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
        let escapedJsonString = jsonString.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        if let escapedJsonString:String = escapedJsonString {
            let srname = subredditDisplayName
            let parameter = ["model":escapedJsonString, "srname":srname]
        
            var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/multi/" + multireddit.path + "/r/" + srname, parameter:parameter, method:"PUT", token:token)
            let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
                self.updateRateLimitWithURLResponse(response)
                let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
                let result = responseResult >>> parseResponse >>> decodeJSON >>> parseJSONToSubredditName
                completion(result)
            })
            task.resume()
            return task
            }
        return nil
    }

    /**
    Get users own multireddit.
    
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    func getMineMultireddit(completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/multi/mine", method:"GET", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseListFromJSON
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Get the description of the specified Multireddit.
    
    :param: multireddit
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    func getMultiredditDescription(multireddit:Multireddit, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/multi/" + multireddit.path + "/description", method:"GET", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseListFromJSON
            completion(result)
        })
        task.resume()
        return task
    }
}