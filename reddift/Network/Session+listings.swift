//
//  Session+listings.swift
//  reddift
//
//  Created by sonson on 2015/04/15.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

/**
type alias for JSON object
*/
typealias JSON = AnyObject
typealias JSONDictionary = Dictionary<String, JSON>
typealias JSONArray = Array<JSON>

func JSONString(object: JSON?) -> String? {
	return object as? String
}

func JSONInt(object: JSON?) -> Int? {
	return object as? Int
}

func JSONObject(object: JSON?) -> JSONDictionary? {
	return object as? JSONDictionary
}

func JSONObjectArray(object: JSON?) -> JSONArray? {
	return object as? JSONArray
}

final class Box<A> {
    let value: A
    init(_ value: A) {
        self.value = value
    }
}

enum Result<A> {
    case Error(NSError)
    case Value(Box<A>)
    
    init(_ error: NSError?, _ value: A) {
        if let err = error {
            self = .Error(err)
        }
        else {
            self = .Value(Box(value))
        }
    }
}

infix operator >>> { associativity left precedence 150 }

func >>><A, B>(a: A?, f: A -> B?) -> B? {
    if let x = a {
        return f(x)
    } else {
        return .None
    }
}

func >>><A, B>(a: Result<A>, f: A -> Result<B>) -> Result<B> {
    switch a {
    case let .Value(x):     return f(x.value)
    case let .Error(error): return .Error(error)
    }
}

/**
Object to eliminate codes to parse http response object.
*/
struct Response {
	let data:NSData
	let statusCode:Int
	
	init(data: NSData!, urlResponse: NSURLResponse!) {
		if let data = data {
			self.data = data
		}
		else {
			self.data = NSData()
		}
		if let httpResponse = urlResponse as? NSHTTPURLResponse {
			statusCode = httpResponse.statusCode
		}
		else {
			statusCode = 500
		}
	}
}

/**
Function to eliminate codes to parse http response object.
This function filters response object to handle errors.
*/
func parseResponse(response: Response) -> Result<NSData> {
    let successRange = 200..<300
    if !contains(successRange, response.statusCode) {
        return .Error(NSError())
    }
    return .Value(Box(response.data))
}

func resultFromOptional<A>(optional: A?, error: NSError) -> Result<A> {
    if let a = optional {
        return .Value(Box(a))
    } else {
        return .Error(error)
    }
}

func parseJSON(json:JSON) -> Result<JSON> {
	let object:AnyObject? = Parser.parseJSON(json, depth:0)
	return resultFromOptional(object, NSError())
}

func parseThing_t2_JSON(json:JSON) -> Result<JSON> {
    if let object = json >>> JSONObject {
        return resultFromOptional(Parser.parseDataInThing_t2(object), NSError())
    }
    return resultFromOptional(nil, NSError())
}

func decodeJSON(data: NSData) -> Result<JSON> {
    var jsonErrorOptional: NSError?
    let jsonOptional: JSON? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &jsonErrorOptional)
    return resultFromOptional(jsonOptional, NSError())
}

extension Session {
    
    func handleRequest(request:NSMutableURLRequest, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            let responseResult = Result(error, Response(data: data, urlResponse: response))
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseJSON
            completion(result)
        })
        task.resume()
        return task
    }
    
    func getArticles(paginator:Paginator?, link:Link, sort:CommentSort, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        if paginator == nil {
            return nil
        }
        var parameter:[String:String] = ["sort":sort.type, "depth":"2"]
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"comments/" + link.id, parameter:parameter, method:"GET", token:token)
        return handleRequest(request, completion:completion)
    }
    
    func getSubscribingSubreddit(paginator:Paginator?, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:SubredditsWhere.Subscriber.path, parameter:paginator?.parameters(), method:"GET", token:token)
        return handleRequest(request, completion:completion)
    }
    
    func getList(paginator:Paginator?, sort:LinkSort, subreddit:Subreddit?, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        if paginator == nil {
            return nil
        }
		var path = sort.path
        if let subreddit = subreddit {
            path = "/r/\(subreddit.display_name)\(path)"
        }
		var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:path, parameter:paginator?.parameters(), method:"GET", token:token)
        return handleRequest(request, completion:completion)
    }
}
