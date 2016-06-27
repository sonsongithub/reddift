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
func response2Data(from response: Response) -> Result<Data> {
#if _TEST
    if let str = String(data: response.data, encoding: .utf8) { print("response body:\n\(str)") }
#endif
    if !(200..<300 ~= response.statusCode) {
        do {
            let json = try JSONSerialization.jsonObject(with: response.data as Data, options: JSONSerialization.ReadingOptions())
            if let json = json as? JSONDictionary { return .failure(HttpStatus(response.statusCode).error(with: json)) }
        } catch { print(error) }
        if let bodyAsString = String(data: response.data as Data, encoding: String.Encoding.utf8) { return .failure(HttpStatus(response.statusCode).error(with: bodyAsString)) }
        return .failure(HttpStatus(response.statusCode).error)
    }
    return .success(response.data)
}

// MARK: Data -> JSON, String

/**
Parse binary data to JSON object.
Returns Result<Error> object when any error happned.
- parameter data: Binary data is returned from reddit.
- returns: Result object. Result object has JSON as JSONDictionary or [AnyObject], otherwise error object.
*/
func data2Json(from data: Data) -> Result<JSONAny> {
    do {
        if data.count == 0 { return Result(value:[:]) } else {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
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
func data2String(from data: Data) -> Result<String> {
    if data.count == 0 {
        return Result(value: "")
    }
    let decoded = NSString(data:data, encoding:String.Encoding.utf8.rawValue)
    if let decoded = decoded as? String {
        return Result(value: decoded)
    }
    return Result(error:ReddiftError.parseJSON.error)
}

// MARK: JSON -> RedditAny

/**
Parse "more" response.
Returns Result<Error> object when any error happned.
- parameter json: JSON object is returned from reddit.
- returns: Result object. Result object has a list of Thing object, otherwise error object.
*/
func json2CommentAndMore(from json: JSONAny) -> Result<[Thing]> {
    let (list, error) = Parser.parseCommentAndMoreJSON(json)
    if let error = error {
        return Result(error: error)
    }
    return Result(value: list)
}

/**
Function to extract Account object from JSON object.
Returns Result<Error> object when any error happned.
- parameter json: JSON object is returned from reddit.
- returns: Result object. Result object has Account object, otherwise error object.
*/
func json2Account(from json: JSONAny) -> Result<Account> {
    if let object = json as? JSONDictionary {
        return Result(fromOptional: Account(json:object), error: ReddiftError.parseThingT2.error)
    }
    return Result(fromOptional: nil, error: ReddiftError.malformed.error)
}

/**
 Function to extract Preference object from JSON object.
 Returns Result<Error> object when any error happned.
 - parameter data: JSON object is returned from reddit.
 - returns: Result object. Result object has Preference object, otherwise error object.
 */
func json2Preference(from json: JSONAny) -> Result<Preference> {
    if let object = json as? JSONDictionary {
        return Result(value: Preference(json: object))
    }
    return Result(fromOptional: nil, error: ReddiftError.malformed.error)
}

/**
 Parse Thing, Listing JSON object.
 Returns Result<Error> object when any error happned.
 - parameter data: Binary data is returned from reddit.
 - returns: Result object. Result object has any Thing or Listing object, otherwise error object.
 */
func json2RedditAny(from json: JSONAny) -> Result<RedditAny> {
    let object: Any? = Parser.parseJSON(json)
    return Result(fromOptional: object, error: ReddiftError.parseThing.error)
}

/**
 Parse JSON for response to /api/comment.
 Returns Result<Error> object when any error happned.
 {"json": {"errors": [], "data": { "things": [] }}}
 - parameter json: JSON object, like above sample.
 - returns: Result object. When parsing is succeeded, object contains list which consists of Thing.
 */
func json2Comment(from json: JSONAny) -> Result<Comment> {
    if let json = json as? JSONDictionary, let j = json["json"] as? JSONDictionary, let data = j["data"] as? JSONDictionary, let things = data["things"] as? JSONArray {
        // No error?
        if things.count == 1 {
            for thing in things {
                if let thing = thing as? JSONDictionary {
                    let obj: Any? = Parser.parseJSON(thing)
                    if let comment = obj as? Comment {
                        return Result(value: comment)
                    }
                }
            }
        }
    } else if let json = json as? JSONDictionary, let j = json["json"] as? JSONDictionary, let errors = j["errors"] as? JSONArray {
        // Error happened.
        for obj in errors {
            if let errorStrings = obj as? [String] {
                return Result(error:NSError.error(with: ReddiftError.returnedCommentError.rawValue, description: errorStrings.joined(separator: ",")))
            }
        }
    }
    return Result(error:ReddiftError.parseCommentError.error)
}

// MARK: RedditAny -> Objects

func redditAny2Object<T>(from redditAny: RedditAny) -> Result<T> {
    if let obj = redditAny as? T {
        return Result(value: obj)
    }
    return Result(error: ReddiftError.malformed.error)
}

func redditAny2MultiredditArray(from redditAny: RedditAny) -> Result<[Multireddit]> {
    if let array = redditAny as? [Any] {
        return Result(value:array.flatMap({$0 as? Multireddit}))
    }
    return Result(error: ReddiftError.malformed.error)
}

func redditAny2ListingTuple(from redditAny: RedditAny) -> Result<(Listing, Listing)> {
    if let array = redditAny as? [RedditAny] {
        if array.count == 2 {
            if let listing0 = array[0] as? Listing, let listing1 = array[1] as? Listing {
                return Result(value: (listing0, listing1))
            }
        }
    }
    return Result(error: ReddiftError.malformed.error)
}

// MARK: Convert from data and response
public func accountInResult(from data: Data?, response: URLResponse?, error: NSError? = nil) -> Result<Account> {
    return Result(from: Response(data: data, urlResponse: response), optional:nil)
        .flatMap(response2Data)
        .flatMap(data2Json)
        .flatMap(json2Account)
}
