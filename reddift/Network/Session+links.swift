//
//  Session+links.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Session {
    /**
    Submit a new comment or reply to a message, whose parent is the fullname of the thing being replied to.
    Its value changes the kind of object created by this request:
    
    - the fullname of a Link: a top-level comment in that Link's thread.
    - the fullname of a Comment: a comment reply to that comment.
    - the fullname of a Message: a message reply to that message.
    
    Response is JSON whose type is t1 Thing.
    
    - parameter text: The body of comment, should be the raw markdown body of the comment or message.
    - parameter parentName: Name of Thing is commented or replied to.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func postComment(text:String, parentName:String, completion:(Result<Comment>) -> Void) -> NSURLSessionDataTask? {
        let parameter:[String:String] = ["thing_id":parentName, "api_type":"json", "text":text]
        let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/comment", parameter:parameter, method:"POST", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2Comment)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Delete a Link or Comment.
    
    - parameter thing: Thing object to be deleted.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func deleteCommentOrLink(name:String, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
        let parameter:[String:String] = ["id":name]
        let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/del", parameter:parameter, method:"POST", token:token)
        return handleAsJSONRequest(request, completion:completion)
    }
    
    /**
    Vote specified thing.
    
    - parameter direction: The type of voting direction as VoteDirection.
    - parameter thing: Thing will be voted.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func setVote(direction:VoteDirection, name:String, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        let parameter:[String:String] = ["dir":String(direction.rawValue), "id":name]
        let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/vote", parameter:parameter, method:"POST", token:token)
        return handleAsJSONRequest(request, completion:completion)
    }
    
    /**
    Save a specified content.
    
    - parameter save: If you want to save the content, set to "true". On the other, if you want to remove the content from saved content, set to "false".
    - parameter name: Name of Thing will be saved/unsaved.
    - parameter category: Name of category into which you want to saved the content
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func setSave(save:Bool, name:String, category:String = "", completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var parameter:[String:String] = ["id":name]
        if !category.characters.isEmpty {
            parameter["category"] = category
        }
        var request:NSMutableURLRequest! = nil
        if save {
            request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/save", parameter:parameter, method:"POST", token:token)
        }
        else {
            request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/unsave", parameter:parameter, method:"POST", token:token)
        }
        return handleAsJSONRequest(request, completion:completion)
    }
    
    /**
    Set hide/show a specified content.
    
    - parameter save: If you want to hide the content, set to "true". On the other, if you want to show the content, set to "false".
    - parameter name: Name of Thing will be hide/show.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func setHide(hide:Bool, name:String, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        let parameter:[String:String] = ["id":name]
        var request:NSMutableURLRequest! = nil
        if hide {
            request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/hide", parameter:parameter, method:"POST", token:token)
        }
        else {
            request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/unhide", parameter:parameter, method:"POST", token:token)
        }
        return handleAsJSONRequest(request, completion:completion)
    }
    
    /**
    Return a listing of things specified by their fullnames.
    Only Links, Comments, and Subreddits are allowed.
    
    - parameter names: Array of contents' fullnames.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getInfo(names:[String], completion:(Result<Listing>) -> Void) -> NSURLSessionDataTask? {
        let commaSeparatedNameString = commaSeparatedStringFromList(names)
        let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/info", parameter:["id":commaSeparatedNameString], method:"GET", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2RedditAny)
                .flatMap({
                    (redditAny: RedditAny) -> Result<Listing> in
                    if let listing = redditAny as? Listing {
                        return Result(value: listing)
                    }
                    return Result(error: ReddiftError.Malformed.error)
                })
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Mark or unmark a link NSFW.

    - parameter thing: Thing object, to set fullname of a thing.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func setNSFW(mark:Bool, thing:Thing, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
        var path = "/api/unmarknsfw"
        if mark {
            path = "/api/marknsfw"
        }
        let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:path, parameter:["id":thing.name], method:"POST", token:token)
        return handleAsJSONRequest(request, completion:completion)
    }
    
    // MARK: BDT does not cover following methods.
    
    /**
    Get a list of categories in which things are currently saved.
    
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getSavedCategories(completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/saved_categories", method:"GET", token:token)
        return handleAsJSONRequest(request, completion:completion)
    }
    
    /**
    Report a link, comment or message.
    Reporting a thing brings it to the attention of the subreddit's moderators. Reporting a message sends it to a system for admin review.
    For links and comments, the thing is implicitly hidden as well.
    
    - parameter thing: Thing object, to set fullname of a thing.
    - parameter reason: Reason of a string no longer than 100 characters.
    - parameter otherReason: The other reason of a string no longer than 100 characters.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func report(thing:Thing, reason:String, otherReason:String, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
        var parameter = ["api_type":"json"]
        let customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
        if let reason_escaped = reason.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet) {
            parameter["reason"] = reason_escaped
        }
        if let otherReason_escaped = otherReason.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet) {
            parameter["other_reason"] = otherReason_escaped
        }
        parameter["thing_id"] = thing.name
        let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/report", parameter:parameter, method:"POST", token:token)
        return handleRequest(request, completion:completion)
    }
    
    /**
    Submit a link to a subreddit.
    
    - parameter subreddit: The subreddit to which is submitted a link.
    - parameter title: The title of the submission. up to 300 characters long.
    - parameter URL: A valid URL
    - parameter captcha: The user's response to the CAPTCHA challenge
    - parameter captchaIden: The identifier of the CAPTCHA challenge
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func submitLink(subreddit:Subreddit, title:String, URL:String, captcha:String, captchaIden:String, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        let customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
        let escapedTitle = title.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        let escapedURL = URL.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        
        if let escapedTitle = escapedTitle, let escapedURL = escapedURL {
            var parameter:[String:String] = [:]
            parameter["api_type"] = "json"
            parameter["captcha"] = captcha
            parameter["iden"] = captchaIden
            parameter["kind"] = "link"
            parameter["resubmit"] = "true"
            parameter["sendreplies"] = "true"
            
            parameter["sr"] = subreddit.displayName
            parameter["title"] = escapedTitle
            parameter["url"] = escapedURL
            
            let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/submit", parameter:parameter, method:"POST", token:token)
            return handleAsJSONRequest(request, completion:completion)
        }
        return nil
    }
    
    /**
    Submit a text to a subreddit.
    Response JSON is,  {"json":{"data":{"id":"35ljt6","name":"t3_35ljt6","url":"https://www.reddit.com/r/sandboxtest/comments/35ljt6/this_is_test/"},"errors":[]}}
    
    - parameter subreddit: The subreddit to which is submitted a link.
    - parameter title: The title of the submission. up to 300 characters long.
    - parameter text: Raw markdown text
    - parameter captcha: The user's response to the CAPTCHA challenge
    - parameter captchaIden: The identifier of the CAPTCHA challenge
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func submitText(subreddit:Subreddit, title:String, text:String, captcha:String, captchaIden:String, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        let customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
        let escapedTitle = title.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        let escapedText = text.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        
        if let escapedTitle = escapedTitle, let escapedText = escapedText {
            var parameter:[String:String] = [:]
            
            parameter["api_type"] = "json"
            parameter["captcha"] = captcha
            parameter["iden"] = captchaIden
            parameter["kind"] = "self"
            parameter["resubmit"] = "true"
            parameter["sendreplies"] = "true"
            
            parameter["sr"] = subreddit.displayName
            parameter["text"] = escapedText
            parameter["title"] = escapedTitle
            
            let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/submit", parameter:parameter, method:"POST", token:token)
            return handleAsJSONRequest(request, completion:completion)
        }
        return nil
    }
    
    /**
    Retrieve additional comments omitted from a base comment tree. When a comment tree is rendered, the most relevant comments are selected for display first. Remaining comments are stubbed out with "MoreComments" links. This API call is used to retrieve the additional comments represented by those stubs, up to 20 at a time. The two core parameters required are link and children. link is the fullname of the link whose comments are being fetched. children is a comma-delimited list of comment ID36s that need to be fetched. If id is passed, it should be the ID of the MoreComments object this call is replacing. This is needed only for the HTML UI's purposes and is optional otherwise. NOTE: you may only make one request at a time to this API endpoint. Higher concurrency will result in an error being returned.
    
    - parameter children: A comma-delimited list of comment ID36s.
    - parameter link: Thing object from which you get more children.
    - parameter sort: The type of sorting children.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getMoreChildren(children:[String], link:Link, sort:CommentSort, completion:(Result<RedditAny>) -> Void) -> NSURLSessionDataTask? {
        let commaSeparatedChildren = commaSeparatedStringFromList(children)
        let parameter = ["children":commaSeparatedChildren, "link_id":link.name, "sort":sort.type, "api_type":"json"]
        let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/morechildren", parameter:parameter, method:"GET", token:token)
        return handleAsJSONRequest(request, completion:completion)
    }
}