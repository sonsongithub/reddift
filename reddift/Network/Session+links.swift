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
    Retrieve additional comments omitted from a base comment tree. When a comment tree is rendered, the most relevant comments are selected for display first. Remaining comments are stubbed out with "MoreComments" links. This API call is used to retrieve the additional comments represented by those stubs, up to 20 at a time. The two core parameters required are link and children. link is the fullname of the link whose comments are being fetched. children is a comma-delimited list of comment ID36s that need to be fetched. If id is passed, it should be the ID of the MoreComments object this call is replacing. This is needed only for the HTML UI's purposes and is optional otherwise. NOTE: you may only make one request at a time to this API endpoint. Higher concurrency will result in an error being returned.
    
    :param: children A comma-delimited list of comment ID36s.
    :param: link Thing object from which you get more children.
    :param: sort The type of sorting children.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getMoreChildren(children:[String], link:Link, sort:CommentSort, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var commaSeparatedChildren = commaSeparatedStringFromList(children)
        var parameter = ["children":commaSeparatedChildren, "link_id":link.name, "sort":sort.type, "api_type":"json"]
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/morechildren", parameter:parameter, method:"GET", token:token)
        return handleAsJSONRequest(request, completion:completion)
    }
    
    /**
    Submit a new comment or reply to a message, whose parent is the fullname of the thing being replied to.
    Its value changes the kind of object created by this request:
    
    - the fullname of a Link: a top-level comment in that Link's thread.
    - the fullname of a Comment: a comment reply to that comment.
    - the fullname of a Message: a message reply to that message.
    
    Response is JSON whose type is t1 Thing.
    
    :param: text The body of comment, should be the raw markdown body of the comment or message.
    :param: parent Thing is commented or replied to.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func postComment(text:String, parent:Thing, completion:(Result<Comment>) -> Void) -> NSURLSessionDataTask? {
        var parameter:[String:String] = ["thing_id":parent.name, "api_type":"json", "text":text]
        var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/comment", parameter:parameter, method:"POST", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseResponseJSONToPostComment
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Vote specified thing.
    
    :param: direction The type of voting direction as VoteDirection.
    :param: thing Thing will be voted.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func setVote(direction:VoteDirection, thing:Thing, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        let parameter:[String:String] = ["dir":String(direction.rawValue), "id":thing.name]
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/vote", parameter:parameter, method:"POST", token:token)
        return handleAsJSONRequest(request, completion:completion)
    }
    
    /**
    Save a specified content.
    
    :param: save If you want to save the content, set to "true". On the other, if you want to remove the content from saved content, set to "false".
    :param: thing Thing will be saved/unsaved.
    :param: category Name of category into which you want to saved the content
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func setSave(save:Bool, thing:Thing, category:String?, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var parameter:[String:String] = ["id":thing.name]
        if let category = category {
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
    
    :param: save If you want to hide the content, set to "true". On the other, if you want to show the content, set to "false".
    :param: thing Thing will be hide/show.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func setHide(hide:Bool, thing:Thing, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var parameter:[String:String] = ["id":thing.name]
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
    Submit a link to a subreddit.
    
    :param: subreddit The subreddit to which is submitted a link.
    :param: title The title of the submission. up to 300 characters long.
    :param: URL A valid URL
    :param: captcha The user's response to the CAPTCHA challenge
    :param: captchaIden The identifier of the CAPTCHA challenge
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func submitLink(subreddit:Subreddit, title:String, URL:String, captcha:String, captchaIden:String, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
        var escapedTitle = title.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        var escapedURL = URL.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        
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
            
            var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/submit", parameter:parameter, method:"POST", token:token)
            return handleAsJSONRequest(request, completion:completion)
        }
        return nil
    }
    
    /**
    Submit a text to a subreddit.
    Response JSON is,  {"json":{"data":{"id":"35ljt6","name":"t3_35ljt6","url":"https://www.reddit.com/r/sandboxtest/comments/35ljt6/this_is_test/"},"errors":[]}}
    
    :param: subreddit The subreddit to which is submitted a link.
    :param: title The title of the submission. up to 300 characters long.
    :param: text Raw markdown text
    :param: captcha The user's response to the CAPTCHA challenge
    :param: captchaIden The identifier of the CAPTCHA challenge
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func submitText(subreddit:Subreddit, title:String, text:String, captcha:String, captchaIden:String, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
        var escapedTitle = title.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        var escapedText = text.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        
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
            
            var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/submit", parameter:parameter, method:"POST", token:token)
            return handleAsJSONRequest(request, completion:completion)
        }
        return nil
    }
    
    /**
    Return a listing of things specified by their fullnames.
    Only Links, Comments, and Subreddits are allowed.
    
    :param: names Array of contents' fullnames.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getInfo(names:[String], completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var commaSeparatedNameString = commaSeparatedStringFromList(names)
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/info", parameter:["id":commaSeparatedNameString], method:"GET", token:token)
        return handleRequest(request, completion:completion)
    }
    
    /**
    Get a list of categories in which things are currently saved.
    
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getSavedCategories(completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/saved_categories", method:"GET", token:token)
        return handleAsJSONRequest(request, completion:completion)
    }
    
    /**
    Delete a Link or Comment.
    
    :param: thing Thing object to be deleted.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func deleteCommentOrLink(thing:Thing, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var parameter:[String:String] = ["id":thing.name]
        var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/del", parameter:parameter, method:"POST", token:token)
        return handleAsJSONRequest(request, completion:completion)
    }
    
}