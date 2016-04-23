//
//  Session+subreddits.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
 The type of subreddit user
 */
public enum SubredditAbout: String {
    case Banned             = "banned"
    case Muted              = "muted"
    case Wikibanned         = "wikibanned"
    case Contributors       = "contributors"
    case Wikicontributors   = "wikicontributors"
    case Moderators         = "moderators"
}

extension Session {
    /**
     Return subreddits recommended for the given subreddit(s).
     Gets a list of subreddits recommended for srnames, filtering out any that appear in the optional omit param.
    */
    public func recommendedSubreddits(omit: [String], srnames: [String], completion: (Result<[String]>) -> Void) throws -> NSURLSessionDataTask {
        var parameter: [String:String] = [:]
        
        if omit.count > 0 {
            parameter["omit"] = omit.joinWithSeparator(",")
        }
        if srnames.count > 0 {
            parameter["srnames"] = srnames.joinWithSeparator(",")
        }
        
        guard let request: NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/recommend/sr/srnames", parameter:parameter, method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result: Result<[String]> = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap({
                    if let array = $0 as? [[String:String]] {
                        return Result(value: array.flatMap({$0["sr_name"]}))
                    }
                    return Result(error:ReddiftError.ParseCommentError.error)
                })
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
     List subreddit names that begin with a query string.
     Subreddits whose names begin with query will be returned. If include_over_18 is false, subreddits with over-18 content restrictions will be filtered from the results.
     If exact is true, only an exact match will be returned.
     - parameter exact: boolean value, if this is true, only an exact match will be returned.
     - parameter include_over_18: boolean value, if this is true NSFW contents will be included returned list.
     - parameter query: a string up to 50 characters long, consisting of printable characters.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func searchRedditNames(query: String, exact: Bool = false, includeOver18: Bool = false, completion: (Result<[String]>) -> Void) throws -> NSURLSessionDataTask {
        let parameter = [
            "query":query,
            "exact":exact.string,
            "include_over_18":includeOver18.string
        ]
        guard let request: NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/search_reddit_names", parameter:parameter, method:"POST", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result: Result<[String]> = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap({
                    if let dict = $0 as? [String:AnyObject], let array = dict["names"] as? [String] {
                        return Result(value: array.flatMap({$0}))
                    }
                    return Result(error:ReddiftError.ParseCommentError.error)
                })
            completion(result)
        })
        task.resume()
        return task
    }
     
    /**
     Return information about the subreddit.
     - parameter subredditName: Subreddit's name.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
    */
    public func about(subredditName: String, completion: (Result<Subreddit>) -> Void) throws -> NSURLSessionDataTask {
        guard let request: NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/r/\(subredditName)/about", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result: Result<Subreddit> = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2RedditAny)
                .flatMap(redditAny2Object)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
     Return a list of subreddits that are relevant to a search query.
     Data includes the subscriber count, description, and header image.
     - parameter query: Query is used for seqrch.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func searchSubredditsByTopic(query: String, completion: (Result<[String]>) -> Void) throws -> NSURLSessionDataTask {
        let parameter = ["query":query]
        guard let request: NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/subreddits_by_topic", parameter:parameter, method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result: Result<[String]> = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap({
                    if let array = $0 as? [[String:String]] {
                        return Result(value: array.flatMap({$0["name"]}))
                    }
                    return Result(error:ReddiftError.ParseCommentError.error)
                })
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
     Get the submission text for the subreddit.
     This text is set by the subreddit moderators and intended to be displayed on the submission form.
     See also: /api/site_admin.
     - parameter subredditName: Subreddit's name.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getSubmitText(subredditName: String, completion: (Result<String>) -> Void) throws -> NSURLSessionDataTask {
        guard let request: NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/r/\(subredditName)/api/submit_text", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result: Result<String> = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap({
                    if let dict = $0 as? [String:String], let submitText = dict["submit_text"] {
                        return Result(value: submitText)
                    }
                    return Result(error:ReddiftError.ParseCommentError.error)
                })
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
     Fetch user list of subreddit.
     - parameter subreddit: Subreddit.
     - parameter aboutWhere: Type of user list, SubredditAbout.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
    */
    public func about(subreddit: Subreddit, aboutWhere: SubredditAbout, user: String = "", count: Int = 0, limit: Int = 25, completion: (Result<[User]>) -> Void) throws -> NSURLSessionDataTask {
        let parameter = [
            "count"    : "\(count)",
            "limit"    : "\(limit)",
            "show"     : "all",
//          "sr_detail": "true",
//          "user"     :"username"
            ]
        let path = "/r/\(subreddit.displayName)/about/\(aboutWhere.rawValue)"
        guard let request: NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:path, parameter:parameter, method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result: Result<[User]> = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2RedditAny)
                .flatMap(redditAny2Object)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Subscribe to or unsubscribe from a subreddit. The user must have access to the subreddit to be able to subscribe to it.
    - parameter subreddit: Subreddit obect to be subscribed/unsubscribed
    - parameter subscribe: If you want to subscribe it, set true.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func setSubscribeSubreddit(subreddit: Subreddit, subscribe: Bool, completion: (Result<JSON>) -> Void) throws -> NSURLSessionDataTask {
        var parameter: [String:String] = ["sr":subreddit.name]
        parameter["action"] = (subscribe) ? "sub" : "unsub"
        guard let request: NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/subscribe", parameter:parameter, method:"POST", token:token)
            else { throw ReddiftError.URLError.error }
        return handleAsJSONRequest(request, completion:completion)
    }
    
    /**
     Get all subreddits.
     The where parameter chooses the order in which the subreddits are displayed.
     popular sorts on the activity of the subreddit and the position of the subreddits can shift around. 
     new sorts the subreddits based on their creation date, newest first.
    - parameter subredditsWhere: Chooses the order in which the subreddits are displayed among SubredditsWhere.
    - parameter paginator: Paginator object for paging.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getSubreddit(subredditWhere: SubredditsWhere, paginator: Paginator?, completion: (Result<Listing>) -> Void) throws -> NSURLSessionDataTask {
        let parameter = paginator?.addParametersToDictionary([:])
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:subredditWhere.path, parameter:parameter, method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result: Result<Listing> = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2RedditAny)
                .flatMap({
                    (redditAny: RedditAny) -> Result<Listing> in
                    if let listing = redditAny as? Listing {
                        return Result(value: listing)
                    }
                    return Result(error: ReddiftError.Malformed.error)
                })
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Get subreddits the user has a relationship with. The where parameter chooses which subreddits are returned as follows:
    
    - subscriber - subreddits the user is subscribed to
    - contributor - subreddits the user is an approved submitter in
    - moderator - subreddits the user is a moderator of
    
    - parameter mine: The type of relationship with the user as SubredditsMineWhere.
    - parameter paginator: Paginator object for paging contents.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getUserRelatedSubreddit(mine: SubredditsMineWhere, paginator: Paginator, completion: (Result<Listing>) -> Void) throws -> NSURLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:mine.path, parameter:paginator.parameterDictionary, method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result: Result<Listing> = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2RedditAny)
                .flatMap(redditAny2Object)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Search subreddits by title and description.
    
    - parameter query: The search keywords, must be less than 512 characters.
    - parameter paginator: Paginator object for paging.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getSubredditSearch(query: String, paginator: Paginator, completion: (Result<Listing>) -> Void) throws -> NSURLSessionDataTask? {
        let parameter = paginator.addParametersToDictionary(["q":query])
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/subreddits/search", parameter:parameter, method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result: Result<Listing> = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2RedditAny)
                .flatMap(redditAny2Object)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    DOES NOT WORK... WHY?
    */
    public func getSticky(subreddit: Subreddit, completion: (Result<RedditAny>) -> Void) throws -> NSURLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/r/" + subreddit.displayName + "/sticky", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        return handleRequest(request, completion:completion)
    }
}
