//
//  Session+listings.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Session {
    
    /**
    The Serendipity content.
    But this endpoints return invalid redirect URL...
    I don't know how this URL should be handled....
    
    :param: subreddit Specified subreddit to which you would like to get random link
    :returns: Data task which requests search to reddit.com.
    */
    public func getRandom(subreddit:Subreddit?, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        if let subreddit = subreddit {
            var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:subreddit.url + "/random", method:"GET", token:token)
            return handleAsJSONRequest(request, completion:completion)
        }
        else {
            var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/random", method:"GET", token:token)
            return handleAsJSONRequest(request, completion:completion)
        }
    }
    
    /**
    Get the comment tree for a given Link article.
    If supplied, comment is the ID36 of a comment in the comment tree for article. This comment will be the (highlighted) focal point of the returned view and context will be the number of parents shown.
    
    :param: link Link from which comment will be got.
    :param: sort The type of sorting.
    :param: comments If supplied, comment is the ID36 of a comment in the comment tree for article.
    :param: depth The maximum depth of subtrees in the thread. Default is 4.
    :param: limit The maximum number of comments to return. Default is 100.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getArticles(link:Link, sort:CommentSort, comments:[String]?, depth:Int = 4, limit:Int = 100, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var parameter:[String:String] = ["sort":sort.type, "depth":"\(depth)", "showmore":"True", "limit":"\(limit)"]
        if let comments = comments {
            var commaSeparatedIDString = commaSeparatedStringFromList(comments)
            parameter["comment"] = commaSeparatedIDString
        }
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/comments/" + link.id, parameter:parameter, method:"GET", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseListFromJSON >>> filterArticleResponse
            
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Get Links from all subreddits or user specified subreddit.
    
    :param: paginator Paginator object for paging contents.
    :param: sort The type of sorting a list.
    :param: TimeFilterWithin The type of filtering contents.
    :param: subreddit Subreddit from which Links will be gotten.
    :param: limit The maximum number of comments to return. Default is 25.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getList(paginator:Paginator, sort:LinkSortBy, timeFilterWithin:TimeFilterWithin, subreddit:SubredditURLPath?, limit:Int = 25, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var parameter = ["t":timeFilterWithin.param];
        parameter["limit"] = "\(limit)"
        parameter["show"] = "all"
        // parameter["sr_detail"] = "true"
        parameter.update(paginator.parameters())
        
        var path = sort.path
        if let subreddit = subreddit {
            path = "\(subreddit.path)/\(sort.path)/.json"
        }
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:path, parameter:parameter, method:"GET", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseListFromJSON
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Get hot Links from all subreddits or user specified subreddit.
    
    :param: paginator Paginator object for paging contents.
    :param: subreddit Subreddit from which Links will be gotten.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getHotList(paginator:Paginator, subreddit:SubredditURLPath?, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        return getNewOrHotList(paginator, subreddit: subreddit, type: "hot", completion: completion)
    }
    
    /**
    Get new Links from all subreddits or user specified subreddit.
    
    :param: paginator Paginator object for paging contents.
    :param: subreddit Subreddit from which Links will be gotten.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getNewList(paginator:Paginator, subreddit:SubredditURLPath?, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        return getNewOrHotList(paginator, subreddit: subreddit, type: "new", completion: completion)
    }
    
    /**
    Get hot or new Links from all subreddits or user specified subreddit.
    
    :param: paginator Paginator object for paging contents.
    :param: subreddit Subreddit from which Links will be gotten.
    :param: limit The maximum number of comments to return. Default is 25.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getNewOrHotList(paginator:Paginator, subreddit:SubredditURLPath?, type:String, limit:Int = 25, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var parameter:[String:String] = [:]
        parameter["limit"] = "\(limit)"
        parameter["show"] = "all"
        // parameter["sr_detail"] = "true"
        parameter.update(paginator.parameters())
        
        var path = type
        if let subreddit = subreddit {
            path = "\(subreddit.path)/\(type)/.json"
        }
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:path, parameter:parameter, method:"GET", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseListFromJSON
            completion(result)
        })
        task.resume()
        return task
    }
}