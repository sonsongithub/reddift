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
    public func createMultireddit(displayName:String, descriptionMd:String, iconName:MultiredditIconName = .None, keyColor:RedditColor = RedditColor.white(), visibility:MultiredditVisibility = .Private, weightingScheme:String = "classic", completion:(Result<Multireddit>) -> Void) throws -> URLSessionDataTask {
        guard let token = self.token else { throw ReddiftError.URLError.error }
        
        let multipath = "/user/\(token.name)/m/\(displayName)"
        let names:[[String:String]] = []
        let json:[String:AnyObject] = [
            "description_md" : descriptionMd,
            "display_name" : displayName,
            "icon_name" : "",
            "key_color" : "#FFFFFF",
            "subreddits" : names,
            "visibility" : "private",
            "weighting_scheme" : "classic"
        ]
        
        do {
            let data:NSData = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
            guard let jsonString = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) as String?
                else { throw ReddiftError.MultiredditDidFailToCreateJSON.error }
        
            let parameter:[String:String] = ["model":jsonString]
            guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/multi/" + multipath, parameter:parameter, method:"POST", token:token)
                else { throw ReddiftError.URLError.error }
            let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
                self.updateRateLimitWithURLResponse(response: response)
                let result = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                    .flatMap(transform: response2Data)
                    .flatMap(transform: data2Json)
                    .flatMap(transform: json2Multireddit)
                completion(result)
            })
            task.resume()
            return task
        }
        catch { throw error }
    }
    
    /**
     Fetch a multi's data and subreddit list by name.
     This API does not work.
     
     - parameter multi: Multireddit object to be deleted.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getMultireddit(multi:Multireddit, completion:(Result<[Multireddit]>) -> Void) throws -> URLSessionDataTask {
        let parameter:[String:String] = ["multipath":multi.path, "expand_srs":"true"]
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/multi/" + multi.path, parameter:parameter, method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result:Result<[Multireddit]> = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Json)
                .flatMap(transform: json2RedditAny)
                .flatMap(transform: redditAny2Object)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
     Delete the multi.
     
     - parameter multi: Multireddit object to be deleted.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func deleteMultireddit(multi:Multireddit, completion:(Result<String>) -> Void) throws -> URLSessionDataTask {
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/multi/" + multi.path, method:"DELETE", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2String)
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
    public func updateMultireddit(multi:Multireddit, completion:(Result<Multireddit>) -> Void) throws -> URLSessionDataTask {
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
            let data:NSData = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
            if let jsonString = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) {
                let parameter:[String:String] = ["model":jsonString as String]
                guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/multi/" + multipath, parameter:parameter, method:"PUT", token:token)
                    else { throw ReddiftError.URLError.error }
                let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
                    self.updateRateLimitWithURLResponse(response: response)
                    let result = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                        .flatMap(transform: response2Data)
                        .flatMap(transform: data2Json)
                        .flatMap(transform: json2Multireddit)
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
     Fetch a list of public multis belonging to username.
     - parameter username: A valid, existing reddit username
     - parameter expandSrs: Boolean value, default is false.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getPublicMultiredditOfUsername(username:String, expandSrs:Bool = false, completion:(Result<[Multireddit]>) -> Void) throws -> URLSessionDataTask {
        let parameter:[String:String] = ["expand_srs":expandSrs ? "true" : "false", "username":username]
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/multi/user/" + username, parameter:parameter, method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result:Result<[Multireddit]> = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Json)
                .flatMap(transform: json2RedditAny)
                .flatMap(transform: redditAny2Object)
            completion(result)
        })
        task.resume()
        return task
    }

    /**
    Convert "/user/sonson_twit/m/testmultireddit12" to "/user/sonson_twit/m/[newName]".
    
    - parameter currentPath: Input string.
    - parameter newName: New display name for path.
    - returns: new path as String.
    */
    public func createNewPath(currentPath:String, newName:String) throws -> String {
        do {
            let regex = try RegularExpression(pattern:"/[^/]+?$", options: .caseInsensitive)
            return regex.stringByReplacingMatches(in: currentPath, options: [], range: NSMakeRange(0, currentPath.characters.count), withTemplate: "/" + newName)
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
    public func copyMultireddit(multi:Multireddit, newDisplayName:String, completion:(Result<Multireddit>) -> Void) throws -> URLSessionDataTask {
        do {
            let parameter:[String:String] = [
                "display_name" : newDisplayName,
                "from" : multi.path,
                "to" : try createNewPath(currentPath: multi.path, newName:newDisplayName)
            ]
            guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/multi/copy", parameter:parameter, method:"POST", token:token)
                else { throw ReddiftError.URLError.error }
            let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
                self.updateRateLimitWithURLResponse(response: response)
                let result = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                    .flatMap(transform: response2Data)
                    .flatMap(transform: data2Json)
                    .flatMap(transform: json2Multireddit)
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
    public func renameMultireddit(multi:Multireddit, newDisplayName:String, completion:(Result<Multireddit>) -> Void) throws -> URLSessionDataTask {
        do {
            let parameter:[String:String] = [
                "display_name" : newDisplayName,
                "from" : multi.path,
                "to" : try createNewPath(currentPath: multi.path, newName:newDisplayName)
            ]
            guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/multi/rename", parameter:parameter, method:"POST", token:token)
                else { throw ReddiftError.URLError.error }
            let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
                self.updateRateLimitWithURLResponse(response: response)
                let result = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                    .flatMap(transform: response2Data)
                    .flatMap(transform: data2Json)
                    .flatMap(transform: json2Multireddit)
                completion(result)
            })
            task.resume()
            return task
        }
        catch { throw error }
    }

    
    /**
    Add a subreddit to multireddit.
    
    - parameter multireddit: multireddit object
    - parameter subreddit:
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func addSubredditToMultireddit(multireddit:Multireddit, subredditDisplayName:String, completion:(Result<String>) -> Void) throws -> URLSessionDataTask {
        let jsonString = "{\"name\":\"\(subredditDisplayName)\"}"
        let srname = subredditDisplayName
        let parameter = ["model":jsonString, "srname":srname]
    
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/multi/" + multireddit.path + "/r/" + srname, parameter:parameter, method:"PUT", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Json)
                .flatMap(transform: {(json:JSON) -> Result<String> in
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
     Remove a subreddit from multireddit.
     
     - parameter multireddit: multireddit object
     - parameter subreddit: displayname of subreddit to be removed.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func removeSubredditFromMultireddit(multireddit:Multireddit, subredditDisplayName:String, completion:(Result<JSON>) -> Void) throws -> URLSessionDataTask {
        let jsonString = "{\"name\":\"\(subredditDisplayName)\"}"
        let srname = subredditDisplayName
        let parameter = ["model":jsonString, "srname":srname]
        
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/multi/" + multireddit.path + "/r/" + srname, parameter:parameter, method:"DELETE", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Json)
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
    public func getMineMultireddit(completion:(Result<[Multireddit]>) -> Void) throws -> URLSessionDataTask {
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/multi/mine", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result:Result<[Multireddit]> = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Json)
                .flatMap(transform: json2RedditAny)
                .flatMap(transform: redditAny2Object)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Get the description of the specified Multireddit.
    
    - parameter multireddit: multireddit object
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getMultiredditDescription(multireddit:Multireddit, completion:(Result<MultiredditDescription>) -> Void) throws -> URLSessionDataTask {
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/multi/" + multireddit.path + "/description", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result:Result<MultiredditDescription> = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Json)
                .flatMap(transform: json2RedditAny)
                .flatMap(transform: redditAny2Object)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
     Put the description of the specified Multireddit.
     
     - parameter multireddit: multireddit object
     - parameter description: description as Markdown format.
     - parameter modhash: a modhash, default is blank string.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func putMultiredditDescription(multireddit:Multireddit, description:String, modhash:String = "", completion:(Result<MultiredditDescription>) -> Void) throws -> URLSessionDataTask {
        let json:[String:AnyObject] = ["body_md":description]
        do {
            let data:NSData = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
            guard let jsonString = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) as String?
                else { throw ReddiftError.MultiredditDidFailToCreateJSON.error }
            
            let parameter = ["model":jsonString]
            guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/multi/" + multireddit.path + "/description/", parameter:parameter, method:"PUT", token:token)
                else { throw ReddiftError.URLError.error }
            let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
                self.updateRateLimitWithURLResponse(response: response)
                let result:Result<MultiredditDescription> = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                    .flatMap(transform: response2Data)
                    .flatMap(transform: data2Json)
                    .flatMap(transform: json2RedditAny)
                    .flatMap(transform: redditAny2Object)
                completion(result)
            })
            task.resume()
            return task
        }
        catch { throw error }
    }
}
