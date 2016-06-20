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
public enum SubredditAbout : String {
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
    public func recommendedSubreddits(omit:[String], srnames:[String], completion:(Result<[String]>) -> Void) throws -> URLSessionDataTask {
        var parameter:[String:String] = [:]
        
        if omit.count > 0 {
            parameter["omit"] = omit.joined(separator: ",")
        }
        if srnames.count > 0 {
            parameter["srnames"] = srnames.joined(separator: ",")
        }
        
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/recommend/sr/srnames", parameter:parameter, method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result:Result<[String]> = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Json)
                .flatMap(transform: {
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
    public func searchRedditNames(query:String, exact:Bool = false, includeOver18:Bool = false, completion:(Result<[String]>) -> Void) throws -> URLSessionDataTask {
        let parameter = [
            "query":query,
            "exact":exact.string,
            "include_over_18":includeOver18.string
        ]
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/search_reddit_names", parameter:parameter, method:"POST", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result:Result<[String]> = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Json)
                .flatMap(transform: {
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
    public func about(subredditName:String, completion:(Result<Subreddit>) -> Void) throws -> URLSessionDataTask {
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/r/\(subredditName)/about", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result:Result<Subreddit> = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
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
     Return a list of subreddits that are relevant to a search query.
     Data includes the subscriber count, description, and header image.
     - parameter query: Query is used for seqrch.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func searchSubredditsByTopic(query:String, completion:(Result<[String]>) -> Void) throws -> URLSessionDataTask {
        let parameter = ["query":query]
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/subreddits_by_topic", parameter:parameter, method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result:Result<[String]> = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Json)
                .flatMap(transform: {
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
    public func getSubmitText(subredditName:String, completion:(Result<String>) -> Void) throws -> URLSessionDataTask {
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/r/\(subredditName)/api/submit_text", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result:Result<String> = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Json)
                .flatMap(transform: {
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
    public func about(subreddit:Subreddit, aboutWhere:SubredditAbout, user:String = "", count:Int = 0, limit:Int = 25, completion:(Result<[User]>) -> Void) throws -> URLSessionDataTask {
        let parameter = [
            "count"    : "\(count)",
            "limit"    : "\(limit)",
            "show"     : "all",
//          "sr_detail": "true",
//          "user"     :"username"
            ]
        let path = "/r/\(subreddit.displayName)/about/\(aboutWhere.rawValue)"
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:path, parameter:parameter, method:"GET", token:token)
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
    Subscribe to or unsubscribe from a subreddit. The user must have access to the subreddit to be able to subscribe to it.
    - parameter subreddit: Subreddit obect to be subscribed/unsubscribed
    - parameter subscribe: If you want to subscribe it, set true.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func setSubscribeSubreddit(subreddit:Subreddit, subscribe:Bool, completion:(Result<JSON>) -> Void) throws -> URLSessionDataTask {
        var parameter:[String:String] = ["sr":subreddit.name]
        parameter["action"] = (subscribe) ? "sub" : "unsub"
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/subscribe", parameter:parameter, method:"POST", token:token)
            else { throw ReddiftError.URLError.error }
        return handleAsJSONRequest(request: request, completion:completion)
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
    public func getSubreddit(subredditWhere:SubredditsWhere, paginator:Paginator?, completion:(Result<RedditAny>) -> Void) throws -> URLSessionDataTask {
        let parameter = paginator?.addParametersToDictionary(dict: [:])
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:subredditWhere.path, parameter:parameter, method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        return handleRequest(request: request, completion:completion)
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
    public func getUserRelatedSubreddit(mine:SubredditsMineWhere, paginator:Paginator?, completion:(Result<Listing>) -> Void) throws -> URLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:mine.path, parameter:paginator?.parameterDictionary, method:"GET", token:token)
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
    Search subreddits by title and description.
    
    - parameter query: The search keywords, must be less than 512 characters.
    - parameter paginator: Paginator object for paging.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getSubredditSearch(query:String, paginator:Paginator?, completion:(Result<Listing>) -> Void) throws -> URLSessionDataTask? {
        let parameter = paginator?.addParametersToDictionary(dict: ["q":query])
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/subreddits/search", parameter:parameter, method:"GET", token:token)
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
    DOES NOT WORK... WHY?
    */
    public func getSticky(subreddit:Subreddit, completion:(Result<RedditAny>) -> Void) throws -> URLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/r/" + subreddit.displayName + "/sticky", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        return handleRequest(request: request, completion:completion)
    }
}
