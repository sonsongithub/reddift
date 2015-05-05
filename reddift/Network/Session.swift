//
//  Session.swift
//  reddift
//
//  Created by sonson on 2015/04/14.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

/**
The type of users' contents for "/user/username/where" method.
*/
public enum UserContent {
    case Overview
    case Submitted
    case Comments
    case Liked
    case Disliked
    case Hidden
    case Saved
    case Gilded
    
    var path:String {
        get {
            switch self{
            case .Overview:
                return "/overview"
            case .Submitted:
                return "/submitted"
            case .Comments:
                return "/comments"
            case .Liked:
                return "/liked"
            case .Disliked:
                return "/disliked"
            case .Hidden:
                return "/hidden"
            case .Saved:
                return "/saved"
            case .Gilded:
                return "/glided"
            }
        }
    }
}

/**
type alias for JSON object
*/
public typealias JSON = AnyObject
public typealias JSONDictionary = Dictionary<String, JSON>
public typealias JSONArray = Array<JSON>
public typealias ThingList = AnyObject

public func JSONString(object: JSON?) -> String? {
    return object as? String
}

public func JSONInt(object: JSON?) -> Int? {
    return object as? Int
}

public func JSONObject(object: JSON?) -> JSONDictionary? {
    return object as? JSONDictionary
}

public func JSONObjectArray(object: JSON?) -> JSONArray? {
    return object as? JSONArray
}

public class Session {
    public let token:OAuth2Token
    static let baseURL = "https://oauth.reddit.com"
    let URLSession:NSURLSession
    
    var x_ratelimit_reset = 0
    var x_ratelimit_used = 0
    var x_ratelimit_remaining = 0
    
    public init(token:OAuth2Token) {
        self.token = token
        self.URLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }
    
    func updateRateLimitWithURLResponse(response:NSURLResponse) {
        if let httpResponse:NSHTTPURLResponse = response as? NSHTTPURLResponse {
            if let temp = httpResponse.allHeaderFields["x-ratelimit-reset"] as? Int {
                x_ratelimit_reset = temp
            }
            if let temp = httpResponse.allHeaderFields["x-ratelimit-used"] as? Int {
                x_ratelimit_used = temp
            }
            if let temp = httpResponse.allHeaderFields["x-ratelimit-remaining"] as? Int {
                x_ratelimit_remaining = temp
            }
        }
    }
    
    func handleRequest(request:NSMutableURLRequest, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseListFromJSON
            completion(result)
        })
        task.resume()
        return task
    }
    
    func handleAsJSONRequest(request:NSMutableURLRequest, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON
            completion(result)
        })
        task.resume()
        return task
    }
	
	public func getMessage(messageWhere:MessageWhere, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
		var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/message" + messageWhere.path, method:"GET", token:token)
		return handleRequest(request, completion:completion)
	}
    
    public func getProfile(completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/v1/me", method:"GET", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseThing_t2_JSON
            completion(result)
        })
        task.resume()
        return task
    }
    
    public func getArticles(link:Link, sort:CommentSort, comments:[String]?, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var parameter:[String:String] = ["sort":sort.type, "depth":"4", "showmore":"True", "limit":"100"]
        if let comments = comments {
            var commaSeparatedIDString = commaSeparatedStringFromList(comments)
            parameter["comment"] = commaSeparatedIDString
        }
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/comments/" + link.id, parameter:parameter, method:"GET", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseListFromJSON >>> filterArticleResponse
            
            completion(result)
        })
        task.resume()
        return task
    }
    
    public func getSubscribingSubreddit(paginator:Paginator?, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:SubredditsMineWhere.Subscriber.path, parameter:paginator?.parameters(), method:"GET", token:token)
        return handleRequest(request, completion:completion)
    }
    
    public func getList(paginator:Paginator?, sort:LinkSort, subreddit:Subreddit?, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        if paginator == nil {
            return nil
        }
        var path = sort.path
        if let subreddit = subreddit {
            path = "/r/\(subreddit.display_name)\(path)"
        }
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:path, parameter:paginator?.parameters(), method:"GET", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseListFromJSON
            completion(result)
        })
        task.resume()
        return task
    }
    
    public func getUser(username:String, content:UserContent, paginator:Paginator?, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/user/" + username + content.path, method:"GET", token:token)
        return handleRequest(request, completion:completion)
    }
    
    public func getInfo(names:[String], completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var commaSeparatedNameString = commaSeparatedStringFromList(names)
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/info", parameter:["id":commaSeparatedNameString], method:"GET", token:token)
        return handleRequest(request, completion:completion)
    }
    
    public func getInfo(name:String, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        return getInfo([name], completion: completion)
    }
    
    public func getSavedCategories(completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/saved_categories", method:"GET", token:token)
        return handleAsJSONRequest(request, completion:completion)
    }
    
    public func getMoreChildren(children:[String], link:Link, sort:CommentSort, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var commaSeparatedChildren = commaSeparatedStringFromList(children)
        var parameter = ["children":commaSeparatedChildren, "link_id":link.name, "sort":sort.type, "api_type":"json"]
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/morechildren", parameter:parameter, method:"GET", token:token)
        return handleAsJSONRequest(request, completion:completion)
    }
    
    /**
    Search link with query. If subreddit is nil, this method searched links from all of reddit.com.
    
    :param: subreddit Specified subreddit to which you would like to limit your search.
    :param: query The search keywords, must be less than 512 characters.
    :param: paginator Paginator object for paging.
    :param: sort Sort type, specified by SearchSort.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getSearch(subreddit:Subreddit?, query:String, paginator:Paginator?, sort:SearchSort, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
        var escapedString = query.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        if let escapedString = escapedString {
            if count(escapedString) > 512 {
                return nil
            }
            var parameter = ["q":escapedString, "sort":sort.path]
            
            if let paginator = paginator {
                for (key, value) in paginator.parameters() {
                    parameter[key] = value
                }
            }
            if let subreddit = subreddit {
                var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:subreddit.url + "search", parameter:parameter, method:"GET", token:token)
                return handleRequest(request, completion:completion)
            }
            else {
                var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/search", parameter:parameter, method:"GET", token:token)
                return handleRequest(request, completion:completion)
            }
        }
        return nil
    }
    
    /**
    The Serendipity content.
    But this endpoints return invalid redirect URL...
    I don't know how this URL should be handled....
    
    :param: subreddit Specified subreddit to which you would like to get random link
    :returns: Data task which requests search to reddit.com.
    */
    public func getRandom(subreddit:Subreddit?, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        if let subreddit = subreddit {
            var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:subreddit.url + "/random", method:"GET", token:token)
            return handleAsJSONRequest(request, completion:completion)
        }
        else {
            var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/random", method:"GET", token:token)
            return handleAsJSONRequest(request, completion:completion)
        }
    }
    
    /**
    Search subreddits by title and description.
    
    :param: query The search keywords, must be less than 512 characters.
    :param: paginator Paginator object for paging.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getSubredditSearch(query:String, paginator:Paginator?, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
        var escapedString = query.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
        if let escapedString = escapedString {
            if count(escapedString) > 512 {
                return nil
            }
            var parameter:[String:String] = ["q":escapedString]
            
            if let paginator = paginator {
                for (key, value) in paginator.parameters() {
                    parameter[key] = value
                }
            }
            var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/subreddits/search", parameter:parameter, method:"GET", token:token)
            return handleRequest(request, completion:completion)
        }
        return nil
    }
    
    /**
    Get all subreddits.
    
    :param: subredditsWhere Chooses the order in which the subreddits are displayed among SubredditsWhere.
    :param: paginator Paginator object for paging.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getSubreddit(subredditWhere:SubredditsWhere, paginator:Paginator?, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var parameter:[String:String] = [:]
        if let paginator = paginator {
            for (key, value) in paginator.parameters() {
                parameter[key] = value
            }
        }
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:subredditWhere.path, parameter:parameter, method:"GET", token:token)
        return handleRequest(request, completion:completion)
    }
    
    /**
    Check whether CAPTCHAs are needed for API methods that define the "captcha" and "iden" parameters.
    
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func checkNeedsCAPTCHA(completion:(Result<Bool>) -> Void) -> NSURLSessionDataTask? {
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/needs_captcha", method:"GET", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeBooleanString
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Responds with an iden of a new CAPTCHA.
    Use this endpoint if a user cannot read a given CAPTCHA, and wishes to receive a new CAPTCHA.
    To request the CAPTCHA image for an iden, use /captcha/iden.

    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getIdenForNewCAPTCHA(completion:(Result<String>) -> Void) -> NSURLSessionDataTask? {
        let parameter:[String:String] = ["api_type":"json"]
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/new_captcha", parameter:parameter, method:"POST", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseCAPTCHAIdenJSON
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Request a CAPTCHA image given an iden.
    An iden is given as the captcha field with a BAD_CAPTCHA error, you should use this endpoint if you get a BAD_CAPTCHA error response.
    Responds with a 120x50 image/png which should be displayed to the user.
    The user's response to the CAPTCHA should be sent as captcha along with your request.
    To request a new CAPTCHA, Session.getIdenForNewCAPTCHA.
    
    :param: iden Code to get a new CAPTCHA. Use Session.getIdenForNewCAPTCHA.
    :returns: Data task which requests search to reddit.com.
    */
    public func getCAPTCHA(iden:String, completion:(Result<UIImage>) -> Void) -> NSURLSessionDataTask? {
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/captcha/" + iden, method:"GET", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodePNGImage
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    DOES NOT WORK... WHY?
    */
    public func getSticky(subreddit:Subreddit, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/r/" + subreddit.display_name + "/sticky", method:"GET", token:token)
        return handleRequest(request, completion:completion)
    }

    public func setVote(direction:Int, thing:Thing, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        let parameter:[String:String] = ["dir":String(direction), "id":thing.name]
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/vote", parameter:parameter, method:"POST", token:token)
        return handleAsJSONRequest(request, completion:completion)
    }
    
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
    
    
}
