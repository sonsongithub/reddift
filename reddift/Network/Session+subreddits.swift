//
//  Session+subreddits.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Session {
    /**
    Subscribe to or unsubscribe from a subreddit. The user must have access to the subreddit to be able to subscribe to it.
    
    :param: subreddit Subreddit obect to be subscribed/unsubscribed
    :param: subscribe If you want to subscribe it, set true.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func setSubscribeSubreddit(subreddit:Subreddit, subscribe:Bool, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var parameter:[String:String] = ["sr":subreddit.name]
        parameter["action"] = (subscribe) ? "sub" : "unsub"
        var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/subscribe", parameter:parameter, method:"POST", token:token)
        return handleAsJSONRequest(request, completion:completion)
    }
    
    /**
    Search subreddits by title and description.
    
    :param: query The search keywords, must be less than 512 characters.
    :param: paginator Paginator object for paging.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getSubredditSearch(query:String, paginator:Paginator?, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
        var customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
        var escapedString = query.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        if let escapedString = escapedString {
            if count(escapedString) > 512 {
                return nil
            }
            var parameter:[String:String] = ["q":escapedString]
            
            if let paginator = paginator {
                for (key, value) in paginator.parameters() {
                    parameter[key] = value
                }
            }
            var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/subreddits/search", parameter:parameter, method:"GET", token:token)
            return handleRequest(request, completion:completion)
        }
        return nil
    }
    
    /**
    Get all subreddits.
    
    :param: subredditsWhere Chooses the order in which the subreddits are displayed among SubredditsWhere.
    :param: paginator Paginator object for paging.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getSubreddit(subredditWhere:SubredditsWhere, paginator:Paginator?, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
        var parameter:[String:String] = [:]
        if let paginator = paginator {
            for (key, value) in paginator.parameters() {
                parameter[key] = value
            }
        }
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:subredditWhere.path, parameter:parameter, method:"GET", token:token)
        return handleRequest(request, completion:completion)
    }
    
    /**
    DOES NOT WORK... WHY?
    */
    public func getSticky(subreddit:Subreddit, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/r/" + subreddit.displayName + "/sticky", method:"GET", token:token)
        return handleRequest(request, completion:completion)
    }
    
    /**
    Get subreddits the user has a relationship with. The where parameter chooses which subreddits are returned as follows:
    
    - subscriber - subreddits the user is subscribed to
    - contributor - subreddits the user is an approved submitter in
    - moderator - subreddits the user is a moderator of
    
    :param: mine The type of relationship with the user as SubredditsMineWhere.
    :param: paginator Paginator object for paging contents.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getUserRelatedSubreddit(mine:SubredditsMineWhere, paginator:Paginator?, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:mine.path, parameter:paginator?.parameters(), method:"GET", token:token)
        return handleRequest(request, completion:completion)
    }
    
}