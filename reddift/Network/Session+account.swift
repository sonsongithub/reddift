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

    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getProfile(completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/v1/me", method:"GET", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> Parser.parseDataInJSON_t2
            completion(result)
        })
        task.resume()
        return task
    }
}