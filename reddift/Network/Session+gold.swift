//
//  Session+gold.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Session {
    /**
     Reddit gold?
     Gilds the specified content by fullname?
     - parameter fullname: fullname of a thing
     - returns: Data task which requests search to reddit.com.
     */
    public func gild(fullname:String, completion:(Result<JSON>) -> Void) throws -> NSURLSessionDataTask {
        let parameter:[String:String] = ["fullname":fullname]
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/v1/gold/gild/", parameter:parameter, method:"POST", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
     Reddit gold?
     Gives gold to the specified user whose name is specified by username?
     - parameter username: A valid, existing reddit username
     - parameter months: an integer between 1 and 36
     - returns: Data task which requests search to reddit.com.
     */
    public func giveGold(username:String, months:Int, completion:(Result<JSON>) -> Void) throws -> NSURLSessionDataTask {
        let parameter:[String:String] = ["fullname":username, "months":String(months)]
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/v1/gold/give/", parameter:parameter, method:"POST", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
            completion(result)
        })
        task.resume()
        return task
    }
}