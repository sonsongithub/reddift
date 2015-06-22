//
//  Session.swift
//  reddift
//
//  Created by sonson on 2015/04/14.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/// For JSON object, typically this alias means [AnyObject] or [String:AnyObject], and so on.
public typealias JSON = Any

/// For JSON object, typically this alias means [String:AnyObject]
public typealias JSONDictionary = Dictionary<String, AnyObject>

/// For JSON object, typically this alias means [AnyObject]
public typealias JSONArray = Array<AnyObject>

/// For reddit object.
public typealias RedditAny = Any

/// Session class to communicate with reddit.com using OAuth.
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
    
    /**
    Initialize session object with OAuth token.
    
    - parameter token: Token object, that is an instance of OAuth2Token or OAuth2AppOnlyToken.
    */
    public init(token:Token) {
        self.token = token
    }
	
	/**
	Update API usage state.

	- parameter response: NSURLResponse object is passed from NSURLSession.
	*/
    func updateRateLimitWithURLResponse(response:NSURLResponse) {
        if let httpResponse:NSHTTPURLResponse = response as? NSHTTPURLResponse {
            if let temp = httpResponse.allHeaderFields["x-ratelimit-reset"] as? String {
                x_ratelimit_reset = Int(temp) ?? 0
            }
            if let temp = httpResponse.allHeaderFields["x-ratelimit-used"] as? String {
                x_ratelimit_used = Int(temp) ?? 0
            }
            if let temp = httpResponse.allHeaderFields["x-ratelimit-remaining"] as? String {
                x_ratelimit_remaining = Int(temp) ?? 0
            }
        }
//		print("x_ratelimit_reset \(x_ratelimit_reset)")
//		print("x_ratelimit_used \(x_ratelimit_used)")
//		print("x_ratelimit_remaining \(x_ratelimit_remaining)")
    }
    
    /**
    Returns object which is generated from JSON object from reddit.com.
    This method automatically parses JSON and generates data.
    
    - parameter response: NSURLResponse object is passed from NSURLSession.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    func handleRequest(request:NSMutableURLRequest, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
		let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if let response = response {
                self.updateRateLimitWithURLResponse(response)
            }
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseListFromJSON
            completion(result)
        })
        if let task = task {
            task.resume()
        }
        return task
    }
    
    /**
    Returns JSON object which is obtained from reddit.com.
    
    - parameter response: NSURLResponse object is passed from NSURLSession.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    func handleAsJSONRequest(request:NSMutableURLRequest, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if let data = data, let response = response {
                self.updateRateLimitWithURLResponse(response)
                let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                let result = responseResult >>> parseResponse >>> decodeJSON
                completion(result)
            }
            else {
                completion(Result(error: error))
            }
        })
        if let task = task {
            task.resume()
        }
        return task
    }

}
