//
//  Session+users.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
 The sort method for listing user's subreddit object, "/subreddits/[where]".
 */
public enum NotificationSort : String {
    case New  = "new"
    case Old  = "old"
    case None = "none"
}

extension Session {
    /**
     Get my notifications.
     - parameter sort: Sort type of notifications, as NotificationSort.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getNotifications(sort:NotificationSort, completion:(Result<JSON>) -> Void) throws -> NSURLSessionDataTask {
        let parameters:[String:String] = [
            "count":"30",
            "start_date":"",
            "end_date":"",
            "sort":sort.rawValue
        ]
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/v1/me/notifications", parameter:parameters, method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
     Mark a notification as read or unread.
     - parameter id: Notification's ID.
     - parameter read: true or false as boolean.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func setNotifications(id:Int, read:Bool, completion:(Result<JSON>) -> Void) throws -> NSURLSessionDataTask {
        let json:[String:String] = [
            "read": read ? "true" : "false"
        ]
        do {
            let data:NSData = try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions())
            
            guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/v1/me/notifications/\(id)", data:data, method:"PATCH", token:token)
                else { throw ReddiftError.URLError.error }
            let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                self.updateRateLimitWithURLResponse(response)
                let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                    .flatMap(response2Data)
                    .flatMap(data2Json)
                completion(result)
            })
            task.resume()
            return task
        }
        catch { throw error }
    }
    
    /**
     Return a list of trophies for the specified user.
     - parameter username: Name of user.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getTrophies(username:String, completion:(Result<JSON>) -> Void) throws -> NSURLSessionDataTask {
        let path = "/api/v1/user/\(username)/trophies"
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:path, method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Get Links or Comments that a user liked, saved, commented, hide, diskiked and etc.
    
    - parameter username: Name of user.
    - parameter content: The type of user's contents as UserContent.
    - parameter paginator: Paginator object for paging contents.
    - parameter limit: The maximum number of comments to return. Default is 25.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getUserContent(username:String, content:UserContent, sort:UserContentSortBy, timeFilterWithin:TimeFilterWithin, paginator:Paginator, limit:Int = 25, completion:(Result<Listing>) -> Void) throws -> NSURLSessionDataTask {
        let parameter = paginator.addParametersToDictionary([
            "limit"    : "\(limit)",
//          "sr_detail": "true",
            "sort"     : sort.param,
            "show"     : "given"
            ])
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/user/" + username + content.path, parameter:parameter, method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2RedditAny)
                .flatMap(redditAny2Listing)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Return information about the user, including karma and gold status.
    
    - parameter username: The name of an existing user
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getUserProfile(username:String, completion:(Result<Account>) -> Void) throws -> NSURLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/user/\(username)/about", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2RedditAny)
                .flatMap({
                    (redditAny: RedditAny) -> Result<Account> in
                    if let account = redditAny as? Account {
                        return Result(value: account)
                    }
                    return Result(error: ReddiftError.Malformed.error)
                })
            completion(result)
        })
        task.resume()
        return task
    }
}