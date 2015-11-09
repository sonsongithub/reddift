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
                .flatMap({ (json:JSON) -> Result<Account> in
                    if let object = json as? JSONDictionary {
                        return resultFromOptional(Account(data:object), error: ReddiftError.ParseThingT2.error)
                    }
                    return resultFromOptional(nil, error: ReddiftError.Malformed.error)
                })
            completion(result)
        })
        task.resume()
        return task
    }
}