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
public class Session : NSObject, URLSessionDelegate, URLSessionDataDelegate {
    /// Token object to access via OAuth
    public var token:Token? = nil
    /// Base URL for OAuth API
    let baseURL:String
    /// Session object to communicate a server
    var urlSession:URLSession = URLSession(configuration: URLSessionConfiguration.default())
    /// Duration until rate limit of API usage as second.
    var x_ratelimit_reset:Int = 0
    /// Count of use API after rete limit is reseted.
    var x_ratelimit_used:Int = 0
    /// Duration until rate limit of API usage as second.
	var x_ratelimit_remaining:Int = 0
    
    /// OAuth endpoint URL
    static let OAuthEndpointURL = "https://oauth.reddit.com/"
    
    /// Public endpoint URL
    static let publicEndpointURL = "https://www.reddit.com/"
    
    /**
    Initialize session object with OAuth token.
    
    - parameter token: Token object, that is an instance of OAuth2Token or OAuth2AppOnlyToken.
    */
    public init(token:Token) {
        self.token = token
        baseURL = Session.OAuthEndpointURL
    }
    
    /**
    Initialize anonymouse session object
    */
    override public init() {
        baseURL = Session.publicEndpointURL
        super.init()
    }
	
	/**
	Update API usage state.

	- parameter response: NSURLResponse object is passed from NSURLSession.
	*/
    func updateRateLimitWithURLResponse(response:URLResponse?, verbose:Bool = false) {
        if let response = response, let httpResponse:HTTPURLResponse = response as? HTTPURLResponse {
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
        if verbose {
    		print("x_ratelimit_reset \(x_ratelimit_reset)")
    		print("x_ratelimit_used \(x_ratelimit_used)")
    		print("x_ratelimit_remaining \(x_ratelimit_remaining)")
        }
    }
    
    /**
    Returns object which is generated from JSON object from reddit.com.
    This method automatically parses JSON and generates data.
    
    - parameter response: NSURLResponse object is passed from NSURLSession.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    func handleRequest(request:NSMutableURLRequest, completion:(Result<RedditAny>) -> Void) -> URLSessionDataTask {
		let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Json)
                .flatMap(transform: json2RedditAny)
            completion(result)
        })
        task.resume()
        return task
    }
        
    /**
    Returns JSON object which is obtained from reddit.com.
    
    - parameter response: NSURLResponse object is passed from NSURLSession.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    func handleAsJSONRequest(request:NSMutableURLRequest, completion:(Result<JSON>) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Json)
            completion(result)
        })
        task.resume()
        return task
    }

}
