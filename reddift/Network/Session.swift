//
//  Session.swift
//  reddift
//
//  Created by sonson on 2015/04/14.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
    public typealias CAPTCHAImage = UIImage
#elseif os(OSX)
    import Cocoa
    public typealias CAPTCHAImage = NSImage
#endif

/**
type alias for JSON object
*/
public typealias JSON = AnyObject
public typealias JSONDictionary = Dictionary<String, JSON>
public typealias JSONArray = Array<JSON>
public typealias ThingList = AnyObject

public class Session {
    /// Token object to access via OAuth
    public let token:OAuth2Token
    /// Base URL for OAuth API
    static let baseURL = "https://oauth.reddit.com"
    /// Session object to communicate a server
    let URLSession:NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    /// Duration until rate limit of API usage as second.
    var x_ratelimit_reset:Int = 0
    /// Count of use API after rete limit is reseted.
    var x_ratelimit_used:Int = 0
    /// Duration until rate limit of API usage as second.
	var x_ratelimit_remaining:Int = 0
    
    public init(token:OAuth2Token) {
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
    
    func handleRequest(request:NSMutableURLRequest, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
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
