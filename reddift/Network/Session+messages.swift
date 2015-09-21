//
//  Session+messages.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Session {
    
    // MARK: BDT does not cover following methods.
    
    /**
    Get the message from the specified box.
    
    - parameter messageWhere: The box from which you want to get your messages.
    - parameter limit: The maximum number of comments to return. Default is 100.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getMessage(messageWhere:MessageWhere, limit:Int = 100, completion:(Result<Listing>) -> Void) throws -> NSURLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/message" + messageWhere.path, method:"GET", token:token)
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
    
    /**
    Compose new message to specified user.
    
    - parameter to: Account object of user to who you want to send a message.
    - parameter subject: A string no longer than 100 characters
    - parameter text: Raw markdown text
    - parameter fromSubreddit: Subreddit name?
    - parameter captcha: The user's response to the CAPTCHA challenge
    - parameter captchaIden: The identifier of the CAPTCHA challenge
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func composeMessage(to:Account, subject:String, text:String, fromSubreddit:Subreddit, captcha:String, captchaIden:String, completion:(Result<JSON>) -> Void) throws -> NSURLSessionDataTask {
        let parameter:[String:String] = [
            "api_type" : "json",
            "captcha" : captcha,
            "iden" : captchaIden,
            "from_sr" : fromSubreddit.displayName,
            "text" : text,
            "subject" : subject,
            "to" : to.id
        ]
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/submit", parameter:parameter, method:"POST", token:token)
            else { throw ReddiftError.URLError.error }
        return handleAsJSONRequest(request, completion:completion)
    }
}