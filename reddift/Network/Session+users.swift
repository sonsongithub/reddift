//
//  Session+users.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Session {
    
    // MARK: BDT does not cover following methods.
    
    /**
    Get Links or Comments that a user liked, saved, commented, hide, diskiked and etc.
    
    - parameter username: Name of user.
    - parameter content: The type of user's contents as UserContent.
    - parameter paginator: Paginator object for paging contents.
    - parameter limit: The maximum number of comments to return. Default is 25.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getUserContent(username:String, content:UserContent, sort:UserContentSortBy, timeFilterWithin:TimeFilterWithin, paginator:Paginator, limit:Int = 25, completion:(Result<Listing>) -> Void) -> NSURLSessionDataTask? {
        var parameter = ["t":timeFilterWithin.param];
        parameter["limit"] = "\(limit)"
        parameter["show"] = "given"
        parameter["sort"] = sort.param
        // parameter["sr_detail"] = "true"
        parameter.update(paginator.parameters())
        
        let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/user/" + username + content.path, parameter:parameter, method:"GET", token:token)
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
    
    /**
    Return information about the user, including karma and gold status.
    
    - parameter username: The name of an existing user
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getUserProfile(username:String, completion:(Result<Account>) -> Void) -> NSURLSessionDataTask? {
        let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/user/\(username)/about", method:"GET", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2RedditAny)
                .flatMap({
                    (redditAny: RedditAny) -> Result<Account> in
                    if let account = redditAny as? Account {
                        return Result(value: account)
                    }
                    return Result(error: ReddiftError.Malformed.error)
                })
            completion(result)
        })
        task.resume()
        return task
    }
}