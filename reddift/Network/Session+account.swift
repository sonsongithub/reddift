//
//  Session+account.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Session {
    /**
     Get preference
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getPreference(completion: (Result<Preference>) -> Void) throws -> NSURLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.OAuthEndpointURL, path:"/api/v1/me/prefs", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let closure = {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Result<Preference> in
            return resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2Preference)
        }
        return executeTask(request, handleResponse: closure, completion: completion)
    }
    
    /**
     DOES NOT WORK, I CAN NOT UNDERSTAND WHY IT DOES NOT.
     Patch preference with Preference object.
     - parameter preference: Preference object.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func patchPreference(preference: Preference, completion: (Result<Preference>) -> Void) throws -> NSURLSessionDataTask {
        let json = preference.json()
        do {
            let data: NSData = try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions())
            guard let request: NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.OAuthEndpointURL, path:"/api/v1/me/prefs", data:data, method:"PATCH", token:token)
                else { throw ReddiftError.URLError.error }
            let closure = {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Result<Preference> in
                return resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                    .flatMap(response2Data)
                    .flatMap(data2Json)
                    .flatMap(json2Preference)
            }
            return executeTask(request, handleResponse: closure, completion: completion)
        } catch { throw error }
    }
    
    /**
     Get friends
     - parameter paginator: Paginator object for paging contents.
     - parameter limit: The maximum number of comments to return. Default is 25.
     - parameter count: A positive integer (default: 0)
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getFriends(paginator: Paginator, count: Int = 0, limit: Int = 1, completion: (Result<RedditAny>) -> Void) throws -> NSURLSessionDataTask {
        do {
            let parameter = paginator.addParametersToDictionary([
                "limit"    : "\(limit)",
                "show"     : "all",
                "count"    : "\(count)"
                //          "sr_detail": "true",
                ])
            guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/prefs/friends", parameter:parameter, method:"GET", token:token)
                else { throw ReddiftError.URLError.error }
            let closure = {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Result<RedditAny> in
                return resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                    .flatMap(response2Data)
                    .flatMap(data2Json)
                    .flatMap(json2RedditAny)
            }
            return executeTask(request, handleResponse: closure, completion: completion)
        } catch { throw error }
    }
    
    /**
     Get blocked
     - parameter paginator: Paginator object for paging contents.
     - parameter limit: The maximum number of comments to return. Default is 25.
     - parameter count: A positive integer (default: 0)
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getBlocked(paginator: Paginator, count: Int = 0, limit: Int = 25, completion: (Result<[User]>) -> Void) throws -> NSURLSessionDataTask {
        do {
            let parameter = paginator.addParametersToDictionary([
                "limit"    : "\(limit)",
                "show"     : "all",
                "count"    : "\(count)"
                //          "sr_detail": "true",
                ])
            guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/prefs/blocked", parameter:parameter, method:"GET", token:token)
                else { throw ReddiftError.URLError.error }
            let closure = {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Result<[User]> in
                return resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                    .flatMap(response2Data)
                    .flatMap(data2Json)
                    .flatMap(json2RedditAny)
                    .flatMap(redditAny2Object)
            }
            return executeTask(request, handleResponse: closure, completion: completion)
        } catch { throw error }
    }
    
    /**
     Return a breakdown of subreddit karma.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getKarma(completion: (Result<[SubredditKarma]>) -> Void) throws -> NSURLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/v1/me/karma", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let closure = {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Result<[SubredditKarma]> in
            return resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2RedditAny)
                .flatMap(redditAny2Object)
        }
        return executeTask(request, handleResponse: closure, completion: completion)
    }
    
    /**
     Return a list of trophies for the current user.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getTrophies(completion: (Result<[Trophy]>) -> Void) throws -> NSURLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/v1/me/trophies", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let closure = {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Result<[Trophy]> in
            return resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2RedditAny)
                .flatMap(redditAny2Object)
        }
        return executeTask(request, handleResponse: closure, completion: completion)
    }
    
    /**
    Gets the identity of the user currently authenticated via OAuth.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getProfile(completion: (Result<Account>) -> Void) throws -> NSURLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/v1/me", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let closure = {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Result<Account> in
            return resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2Account)
        }
        return executeTask(request, handleResponse: closure, completion: completion)
    }
}
