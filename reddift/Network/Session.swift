//
//  Session.swift
//  reddift
//
//  Created by sonson on 2015/04/14.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/// For JSON object, typically this alias means [AnyObject] or JSONDictionary, and so on.
public typealias JSONAny = Any

/// For JSON object, typically this alias means JSONDictionary
public typealias JSONDictionary = Dictionary<String, AnyObject>

/// For JSON object, typically this alias means [AnyObject]
public typealias JSONArray = Array<AnyObject>

/// For reddit object.
public typealias RedditAny = Any

/// Session class to communicate with reddit.com using OAuth.
public class Session: NSObject, NSURLSessionDelegate, NSURLSessionDataDelegate {
    /// Token object to access via OAuth
    public var token: Token? = nil
    /// Base URL for OAuth API
    let baseURL: String
    /// Session object to communicate a server
    var URLSession: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    /// Duration until rate limit of API usage as second.
    var rateLimitDurationToReset: Double = 0
    /// Count of use API after rete limit is reseted.
    var rateLimitUsedCount: Double = 0
    /// Remaining count of use API until rate limit will be reseted.
    var rateLimitRemainingCount: Double = 0
    
    /// OAuth endpoint URL
    static let OAuthEndpointURL = "https://oauth.reddit.com/"
    
    /// Public endpoint URL
    static let publicEndpointURL = "https://www.reddit.com/"
    
    /**
    Initialize session object with OAuth token.
    
    - parameter token: Token object, that is an instance of OAuth2Token or OAuth2AppOnlyToken.
    */
    public init(token: Token) {
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
    func updateRateLimitWithURLResponse(response: NSURLResponse?, verbose: Bool = false) {
        if let response = response, let httpResponse: NSHTTPURLResponse = response as? NSHTTPURLResponse {
            if let temp = httpResponse.allHeaderFields["x-ratelimit-reset"] as? String {
                rateLimitDurationToReset = Double(temp) ?? 0
            }
            if let temp = httpResponse.allHeaderFields["x-ratelimit-used"] as? String {
                rateLimitUsedCount = Double(temp) ?? 0
            }
            if let temp = httpResponse.allHeaderFields["x-ratelimit-remaining"] as? String {
                rateLimitRemainingCount = Double(temp) ?? 0
            }
        }
        if verbose {
            print("x_ratelimit_reset \(rateLimitDurationToReset)")
            print("x_ratelimit_used \(rateLimitUsedCount)")
            print("x_ratelimit_remaining \(rateLimitRemainingCount)")
        }
    }
    
    func handleResponse2RedditAny(data: NSData?, response: NSURLResponse?, error: NSError?) -> Result<RedditAny> {
        self.updateRateLimitWithURLResponse(response)
        return resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
            .flatMap(response2Data)
            .flatMap(data2Json)
            .flatMap(json2RedditAny)
    }
    
    func handleResponse2JSON(data: NSData?, response: NSURLResponse?, error: NSError?) -> Result<JSONAny> {
        self.updateRateLimitWithURLResponse(response)
        return resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
            .flatMap(response2Data)
            .flatMap(data2Json)
    }
    
    /**
     Executes the passed task after refreshing the current OAuth token.
     
     - parameter request: Request object is used for creating NSURLSessionDataTask. OAuth token of thie reqeust can be replaced new token when it is expired.
     - parameter handleResponse: Closure returns Result<T> object by handling response, data and error that is returned from NSURLSession.
     - parameter completion: The completion handler to call when the load request is complete.
     */
    func executeTaskAgainAfterRefresh<T>(request: NSMutableURLRequest, handleResponse: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Result<T>, completion: (Result<T>) -> Void) -> Void {
        do {
            try self.refreshToken({ (result) -> Void in
                switch result {
                case .Failure(let error):
                    completion(Result(error: error as NSError))
                case .Success(let token):
                    // http header must be updated with new OAuth token.
                    request.setOAuth2Token(token)
                    print("new token - \(token.accessToken) - automatically refreshed.")
                    let task = self.URLSession.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                        self.updateRateLimitWithURLResponse(response)
                        completion(handleResponse(data:data, response: response, error: error))
                    })
                    task.resume()
                }
            })
        } catch { completion(Result(error: error as NSError)) }
    }
    
    /**
     Executes the passed task. It's executed after refreshing the current OAuth token if the current OAuth token is expired.
     
     - parameter request: Request object is used for creating NSURLSessionDataTask. OAuth token of thie reqeust can be replaced new token when it is expired.
     - parameter handleResponse: Closure returns Result<T> object by handling response, data and error that is returned from NSURLSession.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    func executeTask<T>(request: NSMutableURLRequest, handleResponse: ((data: NSData?, response: NSURLResponse?, error: NSError?) -> Result<T>), completion: ((Result<T>) -> Void)) -> NSURLSessionDataTask {
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result = handleResponse(data:data, response: response, error: error)
            switch result {
            case .Failure(let error):
                guard let token = self.token else { completion(result); return; }
                if !token.refreshToken.isEmpty && error.code == 401 {
                    self.executeTaskAgainAfterRefresh(request, handleResponse: handleResponse, completion: completion)
                } else {
                    completion(result)
                }
            case .Success:
                completion(result)
            }
        })
        task.resume()
        return task
    }
}
