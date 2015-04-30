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
typealias JSON = AnyObject
typealias JSONDictionary = Dictionary<String, JSON>
typealias JSONArray = Array<JSON>
typealias ThingList = AnyObject

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
        return .Error(NSError(domain: "com.sonson.reddift", code: response.statusCode, userInfo:nil))
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
    return resultFromOptional(jsonOptional, NSError())
}
