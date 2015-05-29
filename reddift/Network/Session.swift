//
//  Session.swift
//  reddift
//
//  Created by sonson on 2015/04/14.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
type alias for JSON object
*/
public typealias JSON = Any
public typealias JSONDictionary = Dictionary<String, AnyObject>
public typealias JSONArray = Array<AnyObject>
public typealias ThingList = AnyObject

public typealias RedditAny = Any

public class Session : NSObject, NSURLSessionDelegate, NSURLSessionDataDelegate {
    /// Token object to access via OAuth
    public var token:Token = OAuth2Token()
    /// Base URL for OAuth API
    static let baseURL = "https://oauth.reddit.com"
    /// Session object to communicate a server
    var URLSession:NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    /// Duration until rate limit of API usage as second.
    var x_ratelimit_reset:Int = 0
    /// Count of use API after rete limit is reseted.
    var x_ratelimit_used:Int = 0
    /// Duration until rate limit of API usage as second.
	var x_ratelimit_remaining:Int = 0
    
    public init(token:Token) {
        self.token = token
    }
	
	/**
	Update API usage state.

	:param: response NSURLResponse object is passed from NSURLSession.
	*/
    func updateRateLimitWithURLResponse(response:NSURLResponse) {
        if let httpResponse:NSHTTPURLResponse = response as? NSHTTPURLResponse {
            if let temp = httpResponse.allHeaderFields["x-ratelimit-reset"] as? String {
                x_ratelimit_reset = temp.toInt() ?? 0
            }
            if let temp = httpResponse.allHeaderFields["x-ratelimit-used"] as? String {
                x_ratelimit_used = temp.toInt() ?? 0
            }
            if let temp = httpResponse.allHeaderFields["x-ratelimit-remaining"] as? String {
                x_ratelimit_remaining = temp.toInt() ?? 0
            }
        }
//		println("x_ratelimit_reset \(x_ratelimit_reset)")
//		println("x_ratelimit_used \(x_ratelimit_used)")
//		println("x_ratelimit_remaining \(x_ratelimit_remaining)")
    }
    
    func handleRequest(request:NSMutableURLRequest, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
		let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
			self.updateRateLimitWithURLResponse(response)
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseListFromJSON
            completion(result)
        })
        task.resume()
        return task
    }
    
    func handleAsJSONRequest(request:NSMutableURLRequest, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
			self.updateRateLimitWithURLResponse(response)
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON
            completion(result)
        })
        task.resume()
        return task
    }

}
