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
    public func getPreference(completion:(Result<JSON>) -> Void) throws -> NSURLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/v1/me/prefs", method:"GET", token:token)
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
     Patch preference with the following JSON object,
     {
     "beta": boolean value,
     "clickgadget": boolean value,
     "collapse_read_messages": boolean value,
     "compress": boolean value,
     "creddit_autorenew": boolean value,
     "default_comment_sort": one of (`confidence`, `old`, `top`, `qa`, `controversial`, `new`),
     "domain_details": boolean value,
     "email_messages": boolean value,
     "enable_default_themes": boolean value,
     "hide_ads": boolean value,
     "hide_downs": boolean value,
     "hide_from_robots": boolean value,
     "hide_locationbar": boolean value,
     "hide_ups": boolean value,
     "highlight_controversial": boolean value,
     "highlight_new_comments": boolean value,
     "ignore_suggested_sort": boolean value,
     "label_nsfw": boolean value,
     "lang": a valid IETF language tag (underscore separated),
     "legacy_search": boolean value,
     "mark_messages_read": boolean value,
     "media": one of (`on`, `off`, `subreddit`),
     "min_comment_score": an integer between -100 and 100,
     "min_link_score": an integer between -100 and 100,
     "monitor_mentions": boolean value,
     "newwindow": boolean value,
     "no_profanity": boolean value,
     "num_comments": an integer between 1 and 500,
     "numsites": an integer between 1 and 100,
     "organic": boolean value,
     "other_theme": subreddit name,
     "over_18": boolean value,
     "private_feeds": boolean value,
     "public_votes": boolean value,
     "research": boolean value,
     "show_flair": boolean value,
     "show_gold_expiration": boolean value,
     "show_link_flair": boolean value,
     "show_promote": boolean value,
     "show_stylesheets": boolean value,
     "show_trending": boolean value,
     "store_visits": boolean value,
     "theme_selector": subreddit name,
     "threaded_messages": boolean value,
     "threaded_modmail": boolean value,
     "use_global_defaults": boolean value,
     }
     - parameter json: JSON object.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func patchPreference(completion:(Result<JSON>) -> Void) throws -> NSURLSessionDataTask {
        // this is scaffold......
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/v1/me/prefs", method:"PATCH", token:token)
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
     Get friends
     - parameter paginator: Paginator object for paging contents.
     - parameter limit: The maximum number of comments to return. Default is 25.
     - parameter count: A positive integer (default: 0)
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getFriends(paginator:Paginator, count:Int = 0, limit:Int = 25, completion:(Result<Listing>) -> Void) throws -> NSURLSessionDataTask {
        do {
            let parameter = paginator.addParametersToDictionary([
                "limit"    : "\(limit)",
                "show"     : "all",
                "count"    : "\(count)"
                //          "sr_detail": "true",
                ])
            guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/prefs/friends", parameter:parameter, method:"GET", token:token)
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
        catch { throw error }
    }
    
    /**
     Get blocked
     - parameter paginator: Paginator object for paging contents.
     - parameter limit: The maximum number of comments to return. Default is 25.
     - parameter count: A positive integer (default: 0)
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getBlocked(paginator:Paginator, count:Int = 0, limit:Int = 25, completion:(Result<Listing>) -> Void) throws -> NSURLSessionDataTask {
        do {
            let parameter = paginator.addParametersToDictionary([
                "limit"    : "\(limit)",
                "show"     : "all",
                "count"    : "\(count)"
                //          "sr_detail": "true",
                ])
            guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/prefs/blocked", parameter:parameter, method:"GET", token:token)
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
        catch { throw error }
    }
    
    /**
     Return a breakdown of subreddit karma.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getKarma(completion:(Result<JSON>) -> Void) throws -> NSURLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/v1/me/karma", method:"GET", token:token)
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
    Gets the identity of the user currently authenticated via OAuth.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getProfile(completion:(Result<Account>) -> Void) throws -> NSURLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/v1/me", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2Account)
            completion(result)
        })
        task.resume()
        return task
    }
}