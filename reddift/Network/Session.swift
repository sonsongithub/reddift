//
//  Session.swift
//  reddift
//
//  Created by sonson on 2015/04/14.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
    public typealias CAPTCHAImage = UIImage
#elseif os(OSX)
    import Cocoa
    public typealias CAPTCHAImage = NSImage
#endif

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
	
	/**
	Get the message from the specified box.
	
	:param: messageWhere The box from which you want to get your messages.
	:param: limit The maximum number of comments to return. Default is 100.
	:param: completion The completion handler to call when the load request is complete.
	:returns: Data task which requests search to reddit.com.
	*/
	public func getMessage(messageWhere:MessageWhere, limit:Int = 100, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
		var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/message" + messageWhere.path, method:"GET", token:token)
		return handleRequest(request, completion:completion)
	}
    
    /**
    Gets the identity of the user currently authenticated via OAuth.
    
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
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
	
	/**
	Get the comment tree for a given Link article.
	If supplied, comment is the ID36 of a comment in the comment tree for article. This comment will be the (highlighted) focal point of the returned view and context will be the number of parents shown.
	
	:param: link Link from which comment will be got.
	:param: sort The type of sorting.
	:param: comments If supplied, comment is the ID36 of a comment in the comment tree for article.
	:param: depth The maximum depth of subtrees in the thread. Default is 4.
	:param: limit The maximum number of comments to return. Default is 100.
	:param: completion The completion handler to call when the load request is complete.
	:returns: Data task which requests search to reddit.com.
	*/
	public func getArticles(link:Link, sort:CommentSort, comments:[String]?, depth:Int = 4, limit:Int = 100, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var parameter:[String:String] = ["sort":sort.type, "depth":"\(depth)", "showmore":"True", "limit":"\(limit)"]
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
	
	/**
	Get subreddits the user has a relationship with. The where parameter chooses which subreddits are returned as follows:
	
	- subscriber - subreddits the user is subscribed to
	- contributor - subreddits the user is an approved submitter in
	- moderator - subreddits the user is a moderator of
	
	:param: mine The type of relationship with the user as SubredditsMineWhere.
	:param: paginator Paginator object for paging contents.
	:param: completion The completion handler to call when the load request is complete.
	:returns: Data task which requests search to reddit.com.
	*/
	public func getUserRelatedSubreddit(mine:SubredditsMineWhere, paginator:Paginator?, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:mine.path, parameter:paginator?.parameters(), method:"GET", token:token)
        return handleRequest(request, completion:completion)
    }
	
	/**
	Get Links from all subreddits or user specified subreddit.
	
	:param: paginator Paginator object for paging contents.
	:param: sort The type of sorting a list.
	:param: TimeFilterWithin The type of filtering contents.
	:param: subreddit Subreddit from which Links will be gotten.
	:param: limit The maximum number of comments to return. Default is 25.
	:param: completion The completion handler to call when the load request is complete.
	:returns: Data task which requests search to reddit.com.
	*/
	public func getList(paginator:Paginator, sort:LinkSortBy, timeFilterWithin:TimeFilterWithin, subreddit:Subreddit?, limit:Int = 25, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
		var parameter = ["t":timeFilterWithin.param];
		parameter["limit"] = "\(limit)"
		parameter["show"] = "all"
		// parameter["sr_detail"] = "true"
		parameter.update(paginator.parameters())

		var path = sort.path
        if let subreddit = subreddit {
            path = "/r/\(subreddit.displayName)\(path)"
        }
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:path, parameter:parameter, method:"GET", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseListFromJSON
            completion(result)
        })
        task.resume()
        return task
    }
	
	/**
	Get hot Links from all subreddits or user specified subreddit.
	
	:param: paginator Paginator object for paging contents.
	:param: subreddit Subreddit from which Links will be gotten.
	:param: completion The completion handler to call when the load request is complete.
	:returns: Data task which requests search to reddit.com.
	*/
	public func getHotList(paginator:Paginator, subreddit:Subreddit?, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
		return getNewOrHotList(paginator, subreddit: subreddit, type: "hot", completion: completion)
	}
	
	/**
	Get new Links from all subreddits or user specified subreddit.
	
	:param: paginator Paginator object for paging contents.
	:param: subreddit Subreddit from which Links will be gotten.
	:param: completion The completion handler to call when the load request is complete.
	:returns: Data task which requests search to reddit.com.
	*/
	public func getNewList(paginator:Paginator, subreddit:Subreddit?, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
		return getNewOrHotList(paginator, subreddit: subreddit, type: "new", completion: completion)
	}
	
	/**
	Get hot or new Links from all subreddits or user specified subreddit.
	
	:param: paginator Paginator object for paging contents.
	:param: subreddit Subreddit from which Links will be gotten.
	:param: limit The maximum number of comments to return. Default is 25.
	:param: completion The completion handler to call when the load request is complete.
	:returns: Data task which requests search to reddit.com.
	*/
	public func getNewOrHotList(paginator:Paginator, subreddit:Subreddit?, type:String, limit:Int = 25, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
		var parameter:[String:String] = [:]
		parameter["limit"] = "\(limit)"
		parameter["show"] = "all"
		// parameter["sr_detail"] = "true"
		parameter.update(paginator.parameters())
		
		var path = "/" + type
		if let subreddit = subreddit {
			path = "/r/\(subreddit.displayName)/" + type
		}
		var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:path, parameter:parameter, method:"GET", token:token)
		let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
			let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
			let result = responseResult >>> parseResponse >>> decodeJSON >>> parseListFromJSON
			completion(result)
		})
		task.resume()
		return task
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
	Get Links or Comments that a user liked, saved, commented, hide, diskiked and etc.
	
	:param: username Name of user.
	:param: content The type of user's contents as UserContent.
	:param: paginator Paginator object for paging contents.
	:param: limit The maximum number of comments to return. Default is 25.
	:param: completion The completion handler to call when the load request is complete.
	:returns: Data task which requests search to reddit.com.
	*/
	public func getUserContent(username:String, content:UserContent, sort:UserContentSortBy, timeFilterWithin:TimeFilterWithin, paginator:Paginator, limit:Int = 25, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
		var parameter = ["t":timeFilterWithin.param];
		parameter["limit"] = "\(limit)"
		parameter["show"] = "given"
		parameter["sort"] = sort.param
		// parameter["sr_detail"] = "true"
		parameter.update(paginator.parameters())
		
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/user/" + username + content.path, parameter:parameter, method:"GET", token:token)
        return handleRequest(request, completion:completion)
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
    Search link with query. If subreddit is nil, this method searched links from all of reddit.com.
    
    :param: subreddit Specified subreddit to which you would like to limit your search.
    :param: query The search keywords, must be less than 512 characters.
    :param: paginator Paginator object for paging.
    :param: sort Sort type, specified by SearchSortBy.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getSearch(subreddit:Subreddit?, query:String, paginator:Paginator?, sort:SearchSortBy, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
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
    public func getCAPTCHA(iden:String, completion:(Result<CAPTCHAImage>) -> Void) -> NSURLSessionDataTask? {
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
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/r/" + subreddit.displayName + "/sticky", method:"GET", token:token)
        return handleRequest(request, completion:completion)
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
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseResponseJSONToPostComment
            completion(result)
        })
        task.resume()
        return task
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
    
    /**
    Subscribe to or unsubscribe from a subreddit. The user must have access to the subreddit to be able to subscribe to it.
    
    :param: subreddit Subreddit obect to be subscribed/unsubscribed
    :param: subscribe If you want to subscribe it, set true.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func setSubscribeSubreddit(subreddit:Subreddit, subscribe:Bool, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var parameter:[String:String] = ["sr":subreddit.name]
        parameter["action"] = (subscribe) ? "sub" : "unsub"
        var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/subscribe", parameter:parameter, method:"POST", token:token)
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
