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

/**
 The friend type
 */
public enum FriendType : String {
    case Friend             = "friend"
    case Enemy              = "enemy"
    case Moderator          = "moderator"
    case Moderator_invite   = "moderator_invite"
    case Contributor        = "contributor"
    case Banned             = "banned"
    case Muted              = "muted"
    case Wikibanned         = "wikibanned"
    case Wikicontributor    = "wikicontributor"
}

extension Session {
    /**
     Create or update a "friend" relationship.
     This operation is idempotent. It can be used to add a new friend, or update an existing friend (e.g., add/change the note on that friend)
     - parameter username: A valid, existing reddit username.
     - parameter note: A string no longer than 300 characters. This propery does NOT work. Ignored.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func friend(username:String, note:String = "", completion:(Result<JSON>) -> Void) throws -> URLSessionDataTask {
        var json:[String:String] = [:]
        if !note.isEmpty { json["note"] = note }
        do {
            let data:NSData = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
            guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: Session.OAuthEndpointURL, path:"api/v1/me/friends/" + username, data:data, method:"PUT", token:token)
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
        } catch {
            throw error
        }
    }
    
    /**
     Stop being friends with a user.
     - parameter username: A valid, existing reddit username.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func unfriend(username:String, completion:(Result<JSON>) -> Void) throws -> URLSessionDataTask {
        let parameters:[String:String] = [
            "id":username
        ]
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: Session.OAuthEndpointURL, path:"api/v1/me/friends/" + username, parameter:parameters, method:"DELETE", token:token)
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
     Get information about a specific 'friend', such as notes.
     - parameter username: A valid, existing reddit username.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getFriends(username:String? = nil, completion:(Result<[User]>) -> Void) throws -> URLSessionDataTask {
        var path = "/api/v1/me/friends"
        if let username = username { path = "/api/v1/me/friends/" + username }
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: Session.OAuthEndpointURL, path:path, parameter:[:], method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result:Result<[User]> = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
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
     Get information about a specific 'blocked', such as notes.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getBlocked(completion:(Result<[User]>) -> Void) throws -> URLSessionDataTask {
        let path = "/api/v1/me/blocked"
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: Session.OAuthEndpointURL, path:path, parameter:[:], method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result:Result<[User]> = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
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
     Create a relationship between a user and another user or subreddit.
     OAuth2 use requires appropriate scope based on the 'type' of the relationship:
     * moderator: Use "moderator_invite"
     * moderator_invite: modothers
     * contributor: modcontributors
     * banned: modcontributors
     * muted: modcontributors
     * wikibanned: modcontributors and modwiki
     * wikicontributor: modcontributors and modwiki
     * friend: Use /api/v1/me/friends/{username}
     * enemy: Use /api/block
     - parameter name: the name of an existing user
     - parameter note: a string no longer than 300 characters
     - parameter banMessageMd: raw markdown text
     - parameter duration: an integer between 1 and 999
     - parameter type: FriendType
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func friend(name:String, note:String, banMessageMd:String, container:String, duration:Int, type:FriendType, completion:(Result<JSON>) -> Void) throws -> URLSessionDataTask {
        let parameters:[String:String] = [
            "container":container,
            "name":name,
            "type":"friend"
//            "uh":modhash
        ]
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/friend", parameter:parameters, method:"POST", token:token)
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
     Remove a relationship between a user and another user or subreddit
     The user can either be passed in by name (nuser) or by fullname (iuser).
     If type is friend or enemy, 'container' MUST be the current user's fullname; for other types, the subreddit must be set via URL (e.g., /r/funny/api/unfriend)
     OAuth2 use requires appropriate scope based on the 'type' of the relationship:
     * moderator: modothers
     * moderator_invite: modothers
     * contributor: modcontributors
     * banned: modcontributors
     * muted: modcontributors
     * wikibanned: modcontributors and modwiki
     * wikicontributor: modcontributors and modwiki
     * friend: Use /api/v1/me/friends/{username}
     * enemy: privatemessages
     - parameter name: the name of an existing user
     - parameter id: fullname of a thing
     - parameter type: FriendType
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func unfriend(name:String = "", id:String = "", type:FriendType, completion:(Result<JSON>) -> Void) throws -> URLSessionDataTask {
        var parameters:[String:String] = [
            "type":type.rawValue
//            "uh":modhash
        ]
        
        if !name.isEmpty { parameters["name"] = name }
        if !id.isEmpty { parameters["id"] = id }
        
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/unfriend", parameter:parameters, method:"POST", token:token)
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
     Get my notifications.
     - parameter sort: Sort type of notifications, as NotificationSort.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getNotifications(sort:NotificationSort, completion:(Result<JSON>) -> Void) throws -> URLSessionDataTask {
        let parameters:[String:String] = [
            "count":"30",
//            "start_date":"",
//            "end_date":"",
            "sort":sort.rawValue
        ]
		guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: Session.OAuthEndpointURL, path:"/api/v1/me/notifications", parameter:parameters, method:"GET", token:token)
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
     Mark a notification as read or unread.
     - parameter id: Notification's ID.
     - parameter read: true or false as boolean.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func setNotifications(id:Int, read:Bool, completion:(Result<JSON>) -> Void) throws -> URLSessionDataTask {
        let json:[String:String] = [
            "read": read ? "true" : "false"
        ]
        do {
            let data:NSData = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
            
			guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: Session.OAuthEndpointURL, path:"/api/v1/me/notifications/\(id)", data:data, method:"PATCH", token:token)
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
        catch { throw error }
    }
    
    /**
     Return a list of trophies for the specified user.
     - parameter username: Name of user.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getTrophies(username:String, completion:(Result<[Trophy]>) -> Void) throws -> URLSessionDataTask {
        let path = "/api/v1/user/\(username)/trophies"
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: Session.OAuthEndpointURL, path:path, method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result:Result<[Trophy]> = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
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
    Get Links or Comments that a user liked, saved, commented, hide, diskiked and etc.
    - parameter username: Name of user.
    - parameter content: The type of user's contents as UserContent.
    - parameter paginator: Paginator object for paging contents.
    - parameter limit: The maximum number of comments to return. Default is 25.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getUserContent(username:String, content:UserContent, sort:UserContentSortBy, timeFilterWithin:TimeFilterWithin, paginator:Paginator, limit:Int = 25, completion:(Result<Listing>) -> Void) throws -> URLSessionDataTask {
        let parameter = paginator.addParametersToDictionary(dict: [
            "limit"    : "\(limit)",
//          "sr_detail": "true",
            "sort"     : sort.param,
            "show"     : "given"
            ])
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/user/" + username + content.path, parameter:parameter, method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result:Result<Listing> = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
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
    Return information about the user, including karma and gold status.
    - parameter username: The name of an existing user
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getUserProfile(username:String, completion:(Result<Account>) -> Void) throws -> URLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/user/\(username)/about", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result:Result<Account> = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Json)
                .flatMap(transform: json2RedditAny)
                .flatMap(transform: redditAny2Object)
            completion(result)
        })
        task.resume()
        return task
    }
}
