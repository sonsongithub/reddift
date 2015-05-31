//
//  Session+listings.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
The sort method for listing Link object, "/r/[subreddit]/[sort]" or "/[sort]".
*/
enum PrivateLinkSortBy {
    case Controversial
    case Top
    
    var path:String {
        switch self{
        case .Controversial:
            return "/controversial"
        case .Top:
            return "/hot"
        }
    }
}

extension Session {
    
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
    public func getArticles(link:Link, sort:CommentSort, comments:[String]?, depth:Int = 4, limit:Int = 100, completion:(Result<Listing>) -> Void) -> NSURLSessionDataTask? {
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
    :param: subreddit Subreddit from which Links will be gotten.
    :param: integratedSort The original type of sorting a list, .Controversial, .Top, .Hot, or .New.
    :param: TimeFilterWithin The type of filtering contents. When integratedSort is .Hot or .New, this parameter is ignored.
    :param: limit The maximum number of comments to return. Default is 25.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getList(paginator:Paginator, subreddit:SubredditURLPath?, sort:LinkSortType, timeFilterWithin:TimeFilterWithin, limit:Int = 25, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
        switch sort {
        case .Controversial:
            return getList(paginator, subreddit: subreddit, privateSortType: PrivateLinkSortBy.Controversial, timeFilterWithin: timeFilterWithin, limit: limit, completion: completion)
        case .Top:
            return getList(paginator, subreddit: subreddit, privateSortType: PrivateLinkSortBy.Top, timeFilterWithin: timeFilterWithin, limit: limit, completion: completion)
        case .New:
            return getNewOrHotList(paginator, subreddit: subreddit, type: "new", limit:limit, completion: completion)
        case .Hot:
            return getNewOrHotList(paginator, subreddit: subreddit, type: "hot", limit:limit, completion: completion)
        }
    }
    
    /**
    Get Links from all subreddits or user specified subreddit.
    
    :param: paginator Paginator object for paging contents.
    :param: subreddit Subreddit from which Links will be gotten.
    :param: sort The type of sorting a list.
    :param: TimeFilterWithin The type of filtering contents.
    :param: limit The maximum number of comments to return. Default is 25.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    func getList(paginator:Paginator, subreddit:SubredditURLPath?, privateSortType:PrivateLinkSortBy, timeFilterWithin:TimeFilterWithin, limit:Int = 25, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
        var parameter = ["t":timeFilterWithin.param];
        parameter["limit"] = "\(limit)"
        parameter["show"] = "all"
        // parameter["sr_detail"] = "true"
        parameter.update(paginator.parameters())
        
        var path = privateSortType.path
        if let subreddit = subreddit {
            path = "\(subreddit.path)\(privateSortType.path).json"
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
    func getHotList(paginator:Paginator, subreddit:SubredditURLPath?, limit:Int = 25, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
        return getNewOrHotList(paginator, subreddit: subreddit, type: "hot", limit:limit, completion: completion)
    }
    
    /**
    Get new Links from all subreddits or user specified subreddit.
    
    :param: paginator Paginator object for paging contents.
    :param: subreddit Subreddit from which Links will be gotten.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getNewList(paginator:Paginator, subreddit:SubredditURLPath?, limit:Int = 25, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
        return getNewOrHotList(paginator, subreddit: subreddit, type: "new", limit:limit, completion: completion)
    }
    
    /**
    Get hot or new Links from all subreddits or user specified subreddit.
    
    :param: paginator Paginator object for paging contents.
    :param: subreddit Subreddit from which Links will be gotten.
    :param: type "new" or "hot" as type.
    :param: limit The maximum number of comments to return. Default is 25.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    func getNewOrHotList(paginator:Paginator, subreddit:SubredditURLPath?, type:String, limit:Int = 25, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
        var parameter:[String:String] = [:]
        parameter["limit"] = "\(limit)"
        parameter["show"] = "all"
        // parameter["sr_detail"] = "true"
        parameter.update(paginator.parameters())
        
        var path = type
        if let subreddit = subreddit {
            path = "\(subreddit.path)/\(type).json"
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
    
    // MARK: BDT does not cover following methods.
    
    /**
    The Serendipity content.
    But this endpoints return invalid redirect URL...
    I don't know how this URL should be handled....
    
    :param: subreddit Specified subreddit to which you would like to get random link
    :returns: Data task which requests search to reddit.com.
    */
    public func getRandom(subreddit:Subreddit?, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
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
    Related page: performs a search using title of article as the search query.
    
    :param: paginator Paginator object for paging contents.
    :param: thing  Thing object to which you want to obtain the contents that are related.
    :param: limit The maximum number of comments to return. Default is 25.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getRelatedArticles(paginator:Paginator, thing:Thing, limit:Int = 25, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
        var parameter:[String:String] = [:]
        parameter["limit"] = "\(limit)"
        parameter["show"] = "all"
        // parameter["sr_detail"] = "true"
        parameter.update(paginator.parameters())
        
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/related/" + thing.id, parameter:parameter, method:"GET", token:token)
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
    Return a list of other submissions of the same URL.
    
    :param: paginator Paginator object for paging contents.
    :param: thing  Thing object by which you want to obtain the same URL is mentioned.
    :param: limit The maximum number of comments to return. Default is 25.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getDuplicatedArticles(paginator:Paginator, thing:Thing, limit:Int = 25, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
        var parameter:[String:String] = [:]
        parameter["limit"] = "\(limit)"
        parameter["show"] = "all"
        // parameter["sr_detail"] = "true"
        parameter.update(paginator.parameters())
        
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/duplicates/" + thing.id, parameter:parameter, method:"GET", token:token)
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
    Get a listing of links by fullname.
    
    :params: links A list of Links
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getLinksById(links:[Link], completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
        let fullnameList = links.map({ (link: Link) -> String in link.name })
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/by_id/" + commaSeparatedStringFromList(fullnameList), method:"GET", token:token)
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