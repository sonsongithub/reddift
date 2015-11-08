//
//  Session+helper.swift
//  reddift
//
//  Created by sonson on 2015/04/26.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
Function to eliminate codes to parse http response object.
This function filters response object to handle errors.
*/
func response2Data(response: Response) -> Result<NSData> {
    let successRange = 200..<300
    if !successRange.contains(response.statusCode) {
        return .Failure(HttpStatus(response.statusCode).error)
    }
    return .Success(response.data)
}

func redditAny2Tuple(redditAny:RedditAny) -> Result<(Listing, Listing)> {
    if let array = redditAny as? [RedditAny] {
        if array.count == 2 {
            if let listing0 = array[0] as? Listing, let listing1 = array[1] as? Listing {
                return Result(value: (listing0, listing1))
            }
        }
    }
    return Result(error: ReddiftError.Malformed.error)
}

func redditAny2Listing(redditAny:RedditAny) -> Result<Listing> {
    if let listing = redditAny as? Listing {
        return Result(value: listing)
    }
    return Result(error: ReddiftError.Malformed.error)
}

/**
Parse binary data to JSON object.

- parameter data: Binary data is returned from reddit.

- returns: Result object. Result object has JSON as [String:AnyObject] or [AnyObject], otherwise error object.
*/
func data2Json(data: NSData) -> Result<JSON> {
    do {
//        print(String(data: data, encoding: NSUTF8StringEncoding)) // for debug
        let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
        return Result(value:json)
    } catch {
        return Result(error: error as NSError)
    }
}

/**
Parse Thing, Listing JSON object.
- parameter data: Binary data is returned from reddit.
- returns: Result object. Result object has any Thing or Listing object, otherwise error object.
*/
func json2RedditAny(json: JSON) -> Result<RedditAny> {
    let object:Any? = Parser.parseJSON(json)
    return resultFromOptional(object, error: ReddiftError.ParseThing.error)
}

/**
Parse simple string response
- parameter data: Binary data is returned from reddit.
- returns: Result object. Result object has String, otherwise error object.
*/
func data2String(data: NSData) -> Result<String> {
    if data.length == 0 {
        return Result(value: "")
    }
    let decoded = NSString(data:data, encoding:NSUTF8StringEncoding)
    if let decoded = decoded as? String {
        return Result(value: decoded)
    }
    return Result(error:ReddiftError.ParseJSON.error)
}

/**
Parse JSON for response to /api/comment.
{"json": {"errors": [], "data": { "things": [] }}}
- parameter json: JSON object, like above sample.
- returns: Result object. When parsing is succeeded, object contains list which consists of Thing.
*/
func json2Comment(json: JSON) -> Result<Comment> {
    if let json = json as? JSONDictionary, let j = json["json"] as? JSONDictionary, let data = j["data"] as? JSONDictionary, let things = data["things"] as? JSONArray {
        // No error?
        if things.count == 1 {
            for thing in things {
                if let thing = thing as? JSONDictionary {
                    let obj:Any? = Parser.parseJSON(thing)
                    if let comment = obj as? Comment {
                        return Result(value: comment)
                    }
                }
            }
        }
    }
    else if let json = json as? JSONDictionary, let j = json["json"] as? JSONDictionary, let errors = j["errors"] as? JSONArray {
        // Error happened.
        for obj in errors {
            if let errorStrings = obj as? [String] {
                return Result(error:NSError.errorWithCode(ReddiftError.ReturnedCommentError.rawValue, errorStrings.joinWithSeparator(",")))
            }
        }
    }
    return Result(error:ReddiftError.ParseCommentError.error)
}
