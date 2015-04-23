//
//  Session+listings.swift
//  reddift
//
//  Created by sonson on 2015/04/15.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

typealias JSON = AnyObject
typealias JSONDictionary = Dictionary<String, JSON>
typealias JSONArray = Array<JSON>

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


func doit(work:()-> Void) {
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
        work()
    })
}

func ListingObject(object:AnyObject?) -> Listing? {
    return object as? Listing
}

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

infix operator >>> { associativity left precedence 150 }

func >>><A, B>(a: A?, f: A -> B?) -> B? {
    if let x = a {
        return f(x)
    } else {
        return .None
    }
}

struct Response {
    let data:NSData
    let statusCode:Int
    
    init(data: NSData, urlResponse: NSURLResponse) {
        self.data = data
        if let httpResponse = urlResponse as? NSHTTPURLResponse {
            statusCode = httpResponse.statusCode
        }
        else {
            statusCode = 500
        }
    }
}

func >>><A, B>(a: Result<A>, f: A -> Result<B>) -> Result<B> {
    switch a {
    case let .Value(x):     return f(x.value)
    case let .Error(error): return .Error(error)
    }
}

func parseResponse(response: Response) -> Result<NSData> {
    let successRange = 200..<300
    if !contains(successRange, response.statusCode) {
        return .Error(NSError()) // customize the error message to your liking
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

func decodeJSON(data: NSData) -> Result<JSON> {
    var jsonErrorOptional: NSError?
    let jsonOptional: JSON? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &jsonErrorOptional)
    return resultFromOptional(jsonOptional, NSError()) // use the error from NSJSONSerialization or a custom error message
}

extension Session {
    
    func parse(json:JSON) -> Result<JSON> {
        let object:AnyObject? = Parser.parseJSON(json, depth:0)
        return resultFromOptional(object, NSError())
    }

    
    func getList(paginator:Paginator?, sortingType:ListingSortType, subreddit:Subreddit?, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask {
        var parameter:[String:String] = [:]
        
        if let paginator = paginator {
            if paginator.sortingType == sortingType {
                parameter = paginator.parameters()
            }
        }
        
        var path = sortingType.path();
        
        if let subreddit = subreddit {
            path = "/r/\(subreddit.display_name)\(path)"
        }
        
        var URLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:path, parameter:parameter, method:"GET", token:token)
        
        let task = URLSession.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in

            let responseResult = Result(error, Response(data: data, urlResponse: response))
            
            let result = responseResult >>> parseResponse >>> decodeJSON >>> self.parse
            
            completion(result)
        })
        task.resume()
        return task
    }
    
	func linkList(paginator:Paginator?, sortingType:ListingSortType, subreddit:Subreddit?, completion:(object:AnyObject?, error:NSError?)->Void) -> NSURLSessionDataTask {
        var parameter:[String:String] = [:]
        
        if let paginator = paginator {
            if paginator.sortingType == sortingType {
                parameter = paginator.parameters()
            }
        }
        
        var path = sortingType.path();
        
        if let subreddit = subreddit {
            path = "/r/\(subreddit.display_name)\(path)"
        }
        
        var URLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:path, parameter:parameter, method:"GET", token:token)
        
        let task = URLSession.dataTaskWithRequest(URLRequest, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
					completion(object:nil, error: error)
                })
            }
            else {
                if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
					
					var object:AnyObject? = Parser.parseJSON(json, depth:0)
					
                    if object != nil {
						dispatch_async(dispatch_get_main_queue(), { () -> Void in
							completion(object:object, error: error)
						})
                    }
                    else {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
							completion(object:nil, error:NSError.errorWithCode(0, userinfo: ["error":"Can not get any contents expectedly."]))
                        })
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(object:nil, error:NSError.errorWithCode(0, userinfo: ["error":"Can not parse response object."]))
                    })
                }
            }
        })
        task.resume()
        return task
    }
}
