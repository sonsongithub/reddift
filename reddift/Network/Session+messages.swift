//
//  Session+messages.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Session {
    
    // MARK: Update message status
	
    /**
    Mark messages as "unread"
    - parameter id: A comma-separated list of thing fullnames
    - parameter modhash: A modhash, default is blank string not nil.
    - returns: Data task which requests search to reddit.com.
    */
    public func markMessagesAsUnread(fullnames:[String], modhash:String = "", completion:(Result<JSON>) -> Void) throws -> URLSessionDataTask {
        let commaSeparatedFullameString = fullnames.joined(separator: ",")
        let parameter = ["id":commaSeparatedFullameString]
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/unread_message", parameter:parameter, method:"POST", token:token)
            else { throw ReddiftError.URLError.error }
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
    
    /**
    Mark messages as "read"
    - parameter id: A comma-separated list of thing fullnames
    - parameter modhash: A modhash, default is blank string not nil.
    - returns: Data task which requests search to reddit.com.
    */
    public func markMessagesAsRead(fullnames:[String], modhash:String = "", completion:(Result<JSON>) -> Void) throws -> URLSessionDataTask {
        let commaSeparatedFullameString = fullnames.joined(separator: ",")
        let parameter = ["id":commaSeparatedFullameString]
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/read_message", parameter:parameter, method:"POST", token:token)
            else { throw ReddiftError.URLError.error }
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
    
    /**
     Mark all messages as "read"
     Queue up marking all messages for a user as read.
     This may take some time, and returns 202 to acknowledge acceptance of the request.
     - parameter modhash: A modhash, default is blank string not nil.
     - returns: Data task which requests search to reddit.com.
     */
    public func markAllMessagesAsRead(modhash:String = "", completion:(Result<JSON>) -> Void) throws -> URLSessionDataTask {
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/read_all_messages", parameter:nil, method:"POST", token:token)
            else { throw ReddiftError.URLError.error }
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
    
    /**
     Collapse messages
     - parameter id: A comma-separated list of thing fullnames
     - parameter modhash: A modhash, default is blank string not nil.
     - returns: Data task which requests search to reddit.com.
     */
    public func collapseMessages(fullnames:[String], modhash:String = "", completion:(Result<JSON>) -> Void) throws -> URLSessionDataTask {
        let commaSeparatedFullameString = fullnames.joined(separator: ",")
        let parameter = ["id":commaSeparatedFullameString]
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/collapse_message", parameter:parameter, method:"POST", token:token)
            else { throw ReddiftError.URLError.error }
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
    
    /**
     Uncollapse messages
     - parameter id: A comma-separated list of thing fullnames
     - parameter modhash: A modhash, default is blank string not nil.
     - returns: Data task which requests search to reddit.com.
     */
    public func uncollapseMessages(fullnames:[String], modhash:String = "", completion:(Result<JSON>) -> Void) throws -> URLSessionDataTask {
        let commaSeparatedFullameString = fullnames.joined(separator: ",")
        let parameter = ["id":commaSeparatedFullameString]
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/uncollapse_message", parameter:parameter, method:"POST", token:token)
            else { throw ReddiftError.URLError.error }
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
    
    /**
     For blocking via inbox.
     - parameter id: fullname of a thing
     - parameter modhash: A modhash, default is blank string not nil.
     - returns: Data task which requests search to reddit.com.
     */
    public func blockViaInbox(fullname:String, modhash:String = "", completion:(Result<JSON>) -> Void) throws -> URLSessionDataTask {
        let parameter = ["id":fullname]
		guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: Session.OAuthEndpointURL, path:"/api/block", parameter:parameter, method:"POST", token:token)
            else { throw ReddiftError.URLError.error }
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
    
    /**
     For unblocking via inbox.
     - parameter id: fullname of a thing
     - parameter modhash: A modhash, default is blank string not nil.
     - returns: Data task which requests search to reddit.com.
     */
    public func unblockViaInbox(fullname:String, modhash:String = "", completion:(Result<JSON>) -> Void) throws -> URLSessionDataTask {
        let parameter = ["id":fullname]
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/unblock_subreddit", parameter:parameter, method:"POST", token:token)
            else { throw ReddiftError.URLError.error }
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
    
    // MARK: Get messages
    
    /**
    Get the message from the specified box.
    - parameter messageWhere: The box from which you want to get your messages.
    - parameter limit: The maximum number of comments to return. Default is 100.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getMessage(messageWhere:MessageWhere, limit:Int = 100, completion:(Result<Listing>) -> Void) throws -> URLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/message" + messageWhere.path, method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result:Result<Listing> = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Json)
                .flatMap(transform: json2RedditAny)
                .flatMap(transform: redditAny2Object)
            completion(result)
        })
        task.resume()
        return task
    }
    
    // MARK: Compose a message
    
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
    public func composeMessage(to:Account, subject:String, text:String, fromSubreddit:Subreddit, captcha:String, captchaIden:String, completion:(Result<JSON>) -> Void) throws -> URLSessionDataTask {
        let parameter:[String:String] = [
            "api_type" : "json",
            "captcha" : captcha,
            "iden" : captchaIden,
            "from_sr" : fromSubreddit.displayName,
            "text" : text,
            "subject" : subject,
            "to" : to.id
        ]
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/submit", parameter:parameter, method:"POST", token:token)
            else { throw ReddiftError.URLError.error }
        return handleAsJSONRequest(request: request, completion:completion)
    }
}
