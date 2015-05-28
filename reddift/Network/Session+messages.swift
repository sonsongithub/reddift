//
//  Session+messages.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Session {
    
    /**
    Get the message from the specified box.
    
    :param: messageWhere The box from which you want to get your messages.
    :param: limit The maximum number of comments to return. Default is 100.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getMessage(messageWhere:MessageWhere, limit:Int = 100, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/message" + messageWhere.path, method:"GET", token:token)
        return handleRequest(request, completion:completion)
    }
    
    /**
    Compose new message to specified user.
    
    :param: to Account object of user to who you want to send a message.
    :param: subject A string no longer than 100 characters
    :param: text Raw markdown text
    :param: fromSubreddit Subreddit name?
    :param: captcha The user's response to the CAPTCHA challenge
    :param: captchaIden The identifier of the CAPTCHA challenge
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func composeMessage(to:Account, subject:String, text:String, fromSubreddit:Subreddit, captcha:String, captchaIden:String, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        
        var customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
        var escapedSubject = subject.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        var escapedText = text.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        
        if let escapedSubject = escapedSubject, let escapedText = escapedText {
            var parameter:[String:String] = [:]
            
            parameter["api_type"] = "json"
            parameter["captcha"] = captcha
            parameter["iden"] = captchaIden
            
            parameter["from_sr"] = fromSubreddit.displayName
            parameter["text"] = escapedText
            parameter["subject"] = escapedSubject
            parameter["to"] = to.id
            
            var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/submit", parameter:parameter, method:"POST", token:token)
            return handleAsJSONRequest(request, completion:completion)
        }
        return nil
    }
}