//
//  Session+multireddit.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias RedditColor = UIColor
#elseif os(OSX)
    import Cocoa
    public typealias RedditColor = NSColor
#endif

/**
Parse JSON dictionary object to the list of Multireddit.

- parameter json: JSON dictionary object is generated NSJSONSeirialize class.

- returns: Result object. Result object has any Thing or Listing object, otherwise error object.
*/
func json2Multireddit(json: JSON) -> Result<Multireddit> {
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

extension Session {
    /**
    Create a new multireddit. Responds with 409 Conflict if it already exists.
    
    - parameter multipath: Multireddit url path
    - parameter displayName: A string no longer than 50 characters.
    - parameter descriptionMd: Raw markdown text.
    - parameter iconName: Icon name as MultiIconName.
    - parameter keyColor: Color. as RedditColor object.(does not implement. always uses white.)
    - parameter subreddits: List of subreddits as String array.
    - parameter visibility: Visibility as MultiVisibilityType.
    - parameter weightingScheme: One of `classic` or `fresh`.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    func createMultireddit(displayName:String, descriptionMd:String, iconName:MultiredditIconName = .None, keyColor:RedditColor = RedditColor.whiteColor(), visibility:MultiredditVisibility = .Private, weightingScheme:String = "classic", completion:(Result<Multireddit>) -> Void) throws -> NSURLSessionDataTask {
        guard let token = self.token
            else { throw ReddiftError.URLError.error }
        
        let multipath = "/user/\(token.name)/m/\(displayName)"
        var json:[String:AnyObject] = [:]
        let names:[[String:String]] = []
        json["description_md"] = descriptionMd
        json["display_name"] = displayName
        json["icon_name"] = ""
        json["key_color"] = "#FFFFFF"
        json["subreddits"] = names
        json["visibility"] = "private"
        json["weighting_scheme"] = "classic"
        
        var jsonStringOptional:String? = nil
        
        do {
            let data:NSData = try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions())
            jsonStringOptional = NSString(data: data, encoding: NSUTF8StringEncoding) as String?
        }
        catch { throw error }
        
        if let jsonString = jsonStringOptional {
            let parameter:[String:String] = ["model":jsonString]
            guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/multi/" + multipath, parameter:parameter, method:"POST", token:token)
                else { throw ReddiftError.URLError.error }
            let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                self.updateRateLimitWithURLResponse(response)
                let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                    .flatMap(response2Data)
                    .flatMap(data2Json)
                    .flatMap(json2Multireddit)
                completion(result)
            })
            task.resume()
            return task
        }
        else {
            throw ReddiftError.MultiredditDidFailToCreateJSON.error
        }
    }
    

    /**
    Convert "/user/sonson_twit/m/testmultireddit12" to "/user/sonson_twit/m/[newName]".
    
    - parameter currentPath: Input string.
    - parameter newName: New display name for path.
    - returns: new path as String.
    */
    func createNewPath(currentPath:String, newName:String) throws -> String {
        do {
            let regex = try NSRegularExpression(pattern:"/[^/]+?$", options: .CaseInsensitive)
            return regex.stringByReplacingMatchesInString(currentPath, options: [], range: NSMakeRange(0, currentPath.characters.count), withTemplate: "/" + newName)
        } catch {
            throw error
        }
    }
    
    /**
    Copy the mulitireddit.
    path	String	"/user/sonson_twit/m/testmultireddit12"
    
    - parameter multi: Multireddit object to be copied.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    func copyMultireddit(multi:Multireddit, newDisplayName:String, completion:(Result<Multireddit>) -> Void) throws -> NSURLSessionDataTask {
        do {
            let parameter:[String:String] = [
                "display_name" : newDisplayName,
                "from" : multi.path,
                "to" : try createNewPath(multi.path, newName:newDisplayName)
            ]
            guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/multi/copy", parameter:parameter, method:"POST", token:token)
                else { throw ReddiftError.URLError.error }
            let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                self.updateRateLimitWithURLResponse(response)
                let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                    .flatMap(response2Data)
                    .flatMap(data2Json)
                    .flatMap(json2Multireddit)
                completion(result)
            })
            task.resume()
            return task
        } catch { throw error }
    }
    
    /**
    Rename the mulitireddit.
    
    - parameter multi: Multireddit object to be copied.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    func renameMultireddit(multi:Multireddit, newDisplayName:String, completion:(Result<Multireddit>) -> Void) throws -> NSURLSessionDataTask {
        do {
            let parameter:[String:String] = [
                "display_name" : newDisplayName,
                "from" : multi.path,
                "to" : try createNewPath(multi.path, newName:newDisplayName)
            ]
            guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/multi/rename", parameter:parameter, method:"POST", token:token)
                else { throw ReddiftError.URLError.error }
            let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                self.updateRateLimitWithURLResponse(response)
                let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                    .flatMap(response2Data)
                    .flatMap(data2Json)
                    .flatMap(json2Multireddit)
                completion(result)
            })
            task.resume()
            return task
        }
        catch { throw error }
    }

    /**
    Delete the multi.
    
    - parameter multi: Multireddit object to be deleted.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    func deleteMultireddit(multi:Multireddit, completion:(Result<String>) -> Void) throws -> NSURLSessionDataTask {
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/multi/" + multi.path, method:"DELETE", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2String)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Update the multireddit. Responds with 409 Conflict if it already exists.
    
    - parameter multi: Multireddit object to be updated.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    func updateMultireddit(multi:Multireddit, completion:(Result<Multireddit>) -> Void) throws -> NSURLSessionDataTask {
        let multipath = multi.path
        let names:[[String:String]] = []
        let json:[String:AnyObject] = [
            "description_md" : multi.descriptionMd,
            "display_name" : multi.name,
            "icon_name" : multi.iconName.rawValue,
            "key_color" : "#FFFFFF",
            "subreddits" : names,
            "visibility" : multi.visibility.rawValue,
            "weighting_scheme" : "classic"
        ]
        do {
            let data:NSData = try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions())
            if let jsonString = NSString(data: data, encoding: NSUTF8StringEncoding) {
                let parameter:[String:String] = ["model":jsonString as String]
                guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/multi/" + multipath, parameter:parameter, method:"PUT", token:token)
                    else { throw ReddiftError.URLError.error }
                let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                    self.updateRateLimitWithURLResponse(response)
                    let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                        .flatMap(response2Data)
                        .flatMap(data2Json)
                        .flatMap(json2Multireddit)
                    completion(result)
                })
                task.resume()
                return task
            }
            else {
                throw ReddiftError.MultiredditDidFailToCreateJSON.error
            }
        } catch {
            throw error
        }
    }
    
    /**
    Add a subreddit to multireddit.
    
    - parameter multireddit:
    - parameter subreddit:
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    func addSubredditToMultireddit(multireddit:Multireddit, subredditDisplayName:String, completion:(Result<String>) -> Void) throws -> NSURLSessionDataTask {
        let jsonString = "{\"name\":\"\(subredditDisplayName)\"}"
        let srname = subredditDisplayName
        let parameter = ["model":jsonString, "srname":srname]
    
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/multi/" + multireddit.path + "/r/" + srname, parameter:parameter, method:"PUT", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap({(json:JSON) -> Result<String> in
                    if let json = json as? JSONDictionary {
                        if let subreddit = json["name"] as? String {
                            return Result(value: subreddit)
                        }
                    }
                    return Result(error: ReddiftError.ParseThing.error)
                })
            completion(result)
        })
        task.resume()
        return task
    }

    /**
    Get users own multireddit.
    
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    func getMineMultireddit(completion:(Result<RedditAny>) -> Void) throws -> NSURLSessionDataTask {
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/multi/mine", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2RedditAny)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Get the description of the specified Multireddit.
    
    - parameter multireddit:
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    func getMultiredditDescription(multireddit:Multireddit, completion:(Result<RedditAny>) -> Void) throws -> NSURLSessionDataTask {
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/multi/" + multireddit.path + "/description", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2RedditAny)
            completion(result)
        })
        task.resume()
        return task
    }
}