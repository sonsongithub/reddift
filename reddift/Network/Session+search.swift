//
//  Session+search.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Session {
    
    /**
    Search link with query. If subreddit is nil, this method searched links from all of reddit.com.
    
    :param: subreddit Specified subreddit to which you would like to limit your search.
    :param: query The search keywords, must be less than 512 characters.
    :param: paginator Paginator object for paging.
    :param: sort Sort type, specified by SearchSortBy.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getSearch(subreddit:Subreddit?, query:String, paginator:Paginator?, sort:SearchSortBy, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
        var customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
        var escapedString = query.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        if let escapedString = escapedString {
            if count(escapedString) > 512 {
                return nil
            }
            var parameter = ["q":escapedString, "sort":sort.path]
            
            if let paginator = paginator {
                for (key, value) in paginator.parameters() {
                    parameter[key] = value
                }
            }
            if let subreddit = subreddit {
                var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:subreddit.url + "search", parameter:parameter, method:"GET", token:token)
                return handleRequest(request, completion:completion)
            }
            else {
                var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/search", parameter:parameter, method:"GET", token:token)
                return handleRequest(request, completion:completion)
            }
        }
        return nil
    }
    
}