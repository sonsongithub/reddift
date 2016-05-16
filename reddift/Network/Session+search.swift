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
    
    - parameter subreddit: Specified subreddit to which you would like to limit your search.
    - parameter query: The search keywords, must be less than 512 characters.
    - parameter paginator: Paginator object for paging.
    - parameter sort: Sort type, specified by SearchSortBy.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getSearch(subreddit: Subreddit?, query: String, paginator: Paginator, sort: SearchSortBy, completion: (Result<Listing>) -> Void) throws -> NSURLSessionDataTask {
        let parameter = paginator.addParametersToDictionary(["q":query, "sort":sort.path])
        var path = "/search"
        if let subreddit = subreddit { path = subreddit.url + "search" }
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:path, parameter:parameter, method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let closure = {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Result<Listing> in
            self.updateRateLimitWithURLResponse(response)
            return resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2RedditAny)
                .flatMap(redditAny2Object)
        }
        return executeTask(request, handleResponse: closure, completion: completion)
    }
    
}
