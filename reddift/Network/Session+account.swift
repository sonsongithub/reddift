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
    Gets the identity of the user currently authenticated via OAuth.

    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getProfile(completion:(Result<Account>) -> Void) -> NSURLSessionDataTask? {
        let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/v1/me", method:"GET", token:token)
        if let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2RedditAny)
                .flatMap({ (json:JSON) -> Result<Account> in
                    if let object = json as? JSONDictionary {
                        return resultFromOptional(Account(data:object), error: ReddiftError.ParseThingT2.error)
                    }
                    return resultFromOptional(nil, error: ReddiftError.Malformed.error)
                })
            completion(result)
        }) {
            task.resume()
            return task
        }
        return nil
    }
}