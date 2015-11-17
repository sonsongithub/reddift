//
//  Session+helper.swift
//  reddift
//
//  Created by sonson on 2015/04/26.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

// MARK: Response -> Data

/**
Function to eliminate codes to parse http response object.
This function filters response object to handle errors.
Returns Result<Error> object when any error happned.
*/
func response2Data(response: Response) -> Result<NSData> {
#if _TEST
    if let str = String(data: response.data, encoding: NSUTF8StringEncoding) { print("response body:\n\(str)") }
#endif
    if !(200..<300 ~= response.statusCode) {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(response.data, options: NSJSONReadingOptions())
            if let json = json as? [String:AnyObject] { return .Failure(HttpStatus(response.statusCode).errorWithJSON(json)) }
        }
        catch { print(error) }
        if let bodyAsString = String(data: response.data, encoding: NSUTF8StringEncoding) { return .Failure(HttpStatus(response.statusCode).errorWithString(bodyAsString)) }
        return .Failure(HttpStatus(response.statusCode).error)
    }
    return .Success(response.data)
}

// MARK: Data -> JSON, String

/**
Parse binary data to JSON object.
Returns Result<Error> object when any error happned.
- parameter data: Binary data is returned from reddit.
- returns: Result object. Result object has JSON as [String:AnyObject] or [AnyObject], otherwise error object.
*/
func data2Json(data: NSData) -> Result<JSON> {
    do {
        if data.length == 0 { return Result(value:[:]) }
        else {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
            return Result(value:json)
        }
    } catch {
        return Result(error: error as NSError)
    }
}

/**
 Parse simple string response.
 Returns Result<Error> object when any error happned.
 Returns vacant JSON object when binary data size is 0.
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

// MARK: JSON -> RedditAny

/**
Function to extract Account object from JSON object.
Returns Result<Error> object when any error happned.
- parameter data: JSON object is returned from reddit.
- returns: Result object. Result object has Account object, otherwise error object.
*/
func json2Account(json:JSON) -> Result<Account> {
    if let object = json as? JSONDictionary {
        return resultFromOptional(Account(data:object), error: ReddiftError.ParseThingT2.error)
    }
    return resultFromOptional(nil, error: ReddiftError.Malformed.error)
}

/**
 Function to extract Preference object from JSON object.
 Returns Result<Error> object when any error happned.
 - parameter data: JSON object is returned from reddit.
 - returns: Result object. Result object has Preference object, otherwise error object.
 */
func json2Preference(json:JSON) -> Result<Preference> {
    if let object = json as? JSONDictionary {
        return Result(value: Preference(json: object))
    }
    return resultFromOptional(nil, error: ReddiftError.Malformed.error)
}

/**
 Parse Thing, Listing JSON object.
 Returns Result<Error> object when any error happned.
 - parameter data: Binary data is returned from reddit.
 - returns: Result object. Result object has any Thing or Listing object, otherwise error object.
 */
func json2RedditAny(json: JSON) -> Result<RedditAny> {
    let object:Any? = Parser.parseJSON(json)
    return resultFromOptional(object, error: ReddiftError.ParseThing.error)
}

/**
 Parse JSON for response to /api/comment.
 Returns Result<Error> object when any error happned.
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


/**
 Parse JSON for response to /api/subreddits_by_topic
 Returns Result<Error> object when any error happned.
 - parameter json: JSON object, like above sample.
 - returns: Result object. When parsing is succeeded, object contains subreddit name list as [String].
 */
func json2SubredditNameList(json: JSON) -> Result<[String]> {
    if let array = json as? [[String:String]] {
        return Result(value: array.flatMap({$0["name"]}))
    }
    return Result(error:ReddiftError.ParseCommentError.error)
}

// MARK: RedditAny -> Objects

func redditAny2Object<T>(redditAny:RedditAny) -> Result<T> {
    if let obj = redditAny as? T {
        return Result(value: obj)
    }
    return Result(error: ReddiftError.Malformed.error)
}

func redditAny2Object(redditAny:RedditAny) -> Result<[Multireddit]> {
    if let array = redditAny as? [Any] {
        return Result(value:array.flatMap({$0 as? Multireddit}))
    }
    return Result(error: ReddiftError.Malformed.error)
}


func redditAny2Object(redditAny:RedditAny) -> Result<(Listing, Listing)> {
    if let array = redditAny as? [RedditAny] {
        if array.count == 2 {
            if let listing0 = array[0] as? Listing, let listing1 = array[1] as? Listing {
                return Result(value: (listing0, listing1))
            }
        }
    }
    return Result(error: ReddiftError.Malformed.error)
}
