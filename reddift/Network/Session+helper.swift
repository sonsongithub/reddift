//
//  Session+helper.swift
//  reddift
//
//  Created by sonson on 2015/04/26.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

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

public final class Box<A> {
    public let value: A
    public init(_ value: A) {
        self.value = value
    }
}

public enum Result<A> {
    case Error(NSError)
    case Value(Box<A>)
    
    public init(_ error: NSError?, _ value: A) {
        if let err = error {
            self = .Error(err)
        }
        else {
            self = .Value(Box(value))
        }
    }
}

infix operator >>> { associativity left precedence 150 }

public func >>><A, B>(a: A?, f: A -> B?) -> B? {
    if let x = a {
        return f(x)
    } else {
        return .None
    }
}

public func >>><A, B>(a: Result<A>, f: A -> Result<B>) -> Result<B> {
    switch a {
    case let .Value(x):     return f(x.value)
    case let .Error(error): return .Error(error)
    }
}

/**
Object to eliminate codes to parse http response object.
*/
public struct Response {
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
public func parseResponse(response: Response) -> Result<NSData> {
    let successRange = 200..<300
    if !contains(successRange, response.statusCode) {
        return .Error(NSError(domain: "com.sonson.reddift", code: response.statusCode, userInfo:nil))
    }
    return .Value(Box(response.data))
}

public func resultFromOptional<A>(optional: A?, error: NSError) -> Result<A> {
    if let a = optional {
        return .Value(Box(a))
    } else {
        return .Error(error)
    }
}

public func decodeJSON(data: NSData) -> Result<JSON> {
    var jsonErrorOptional: NSError?
    let jsonOptional: JSON? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &jsonErrorOptional)
    if let jsonError = jsonErrorOptional {
        return resultFromOptional(jsonOptional, jsonError)
    }
    return resultFromOptional(jsonOptional, NSError(domain: "com.sonson.reddift", code: 2, userInfo: ["description":"Failed to parse JSON object unexpectedly."]))
}
