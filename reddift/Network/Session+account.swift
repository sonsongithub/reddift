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
     Get preference
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getPreference(completion:(Result<Preference>) -> Void) throws -> URLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: Session.OAuthEndpointURL, path:"/api/v1/me/prefs", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
		
		//----SWIFT MIGRATION BUG FIX---///
		//https://stackoverflow.com/questions/37812286/swift-3-urlsession-shared-ambiguous-reference-to-member-datataskwithcomplet
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Json)
                .flatMap(transform: json2Preference)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
     DOES NOT WORK, I CAN NOT UNDERSTAND ABOUT REASON.
     Patch preference with Preference object.
     - parameter preference: Preference object.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func patchPreference(preference:Preference, completion:(Result<Preference>) -> Void) throws -> URLSessionDataTask {
        let json = preference.json()
        do {
            let data:NSData = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions())
			guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: Session.OAuthEndpointURL, path:"/api/v1/me/prefs", data:data, method:"PATCH", token:token)
                else { throw ReddiftError.URLError.error }
			//----SWIFT MIGRATION BUG FIX---///
			//https://stackoverflow.com/questions/37812286/swift-3-urlsession-shared-ambiguous-reference-to-member-datataskwithcomplet
            let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
                self.updateRateLimitWithURLResponse(response: response)
                let result = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                    .flatMap(transform: response2Data)
                    .flatMap(transform: data2Json)
                    .flatMap(transform: json2Preference)
                completion(result)
            })
            task.resume()
            return task
        }
        catch { throw error }
    }
    
    /**
     Get friends
     - parameter paginator: Paginator object for paging contents.
     - parameter limit: The maximum number of comments to return. Default is 25.
     - parameter count: A positive integer (default: 0)
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getFriends(paginator:Paginator, count:Int = 0, limit:Int = 1, completion:(Result<RedditAny>) -> Void) throws -> URLSessionDataTask {
        do {
            let parameter = paginator.addParametersToDictionary(dict: [
                "limit"    : "\(limit)",
                "show"     : "all",
                "count"    : "\(count)"
                //          "sr_detail": "true",
                ])
			guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/prefs/friends", parameter:parameter, method:"GET", token:token)
                else { throw ReddiftError.URLError.error }
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
    public func getBlocked(paginator:Paginator, count:Int = 0, limit:Int = 25, completion:(Result<[User]>) -> Void) throws -> URLSessionDataTask {
        do {
            let parameter = paginator.addParametersToDictionary(dict: [
                "limit"    : "\(limit)",
                "show"     : "all",
                "count"    : "\(count)"
                //          "sr_detail": "true",
                ])
			guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/prefs/blocked", parameter:parameter, method:"GET", token:token)
                else { throw ReddiftError.URLError.error }
            let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
                self.updateRateLimitWithURLResponse(response: response)
                let result:Result<[User]> = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                    .flatMap(transform: response2Data)
                    .flatMap(transform: data2Json)
                    .flatMap(transform: json2RedditAny)
                    .flatMap(transform: redditAny2Object)
                completion(result)
            })
            task.resume()
            return task
        }
        catch { throw error }
    }
    
    /**
     Return a breakdown of subreddit karma.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getKarma(completion:(Result<[SubredditKarma]>) -> Void) throws -> URLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/v1/me/karma", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result:Result<[SubredditKarma]> = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Json)
                .flatMap(transform: json2RedditAny)
                .flatMap(transform: redditAny2Object)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
     Return a list of trophies for the current user.
     - parameter completion: The completion handler to call when the load request is complete.
     - returns: Data task which requests search to reddit.com.
     */
    public func getTrophies(completion:(Result<[Trophy]>) -> Void) throws -> URLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/v1/me/trophies", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result:Result<[Trophy]> = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Json)
                .flatMap(transform: json2RedditAny)
                .flatMap(transform: redditAny2Object)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Gets the identity of the user currently authenticated via OAuth.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getProfile(completion:(Result<Account>) -> Void) throws -> URLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/v1/me", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Json)
                .flatMap(transform: json2Account)
            completion(result)
        })
        task.resume()
        return task
    }
}
