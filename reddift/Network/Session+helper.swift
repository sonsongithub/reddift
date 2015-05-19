//
//  Session+helper.swift
//  reddift
//
//  Created by sonson on 2015/04/26.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

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
        return .Failure(HttpStatus(response.statusCode).error)
    }
    return .Success(Box(response.data))
}

func decodeJSON(data: NSData) -> Result<JSON> {
    var jsonErrorOptional: NSError?
    let jsonOptional: JSON? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &jsonErrorOptional)
    if let jsonError = jsonErrorOptional {
        return Result(error: jsonError)
    }
    if let json:JSON = jsonOptional {
        return Result(value:json)
    }
    return Result(error:ReddiftError.ParseJSON.error)
}

func parseListFromJSON(json: JSON) -> Result<JSON> {
    let object:AnyObject? = Parser.parseJSON(json)
    return resultFromOptional(object, ReddiftError.ParseThing.error)
}

/**
Parse JSON for response to /api/comment.
{"json": {"errors": [], "data": { "things": [] }}}

:param: json JSON object, like above sample.
:returns: Result object. When parsing is succeeded, object contains list which consists of Thing.
*/
func parseResponseJSONToPostComment(json: JSON) -> Result<Comment> {
    if let j = json["json"] as? JSONDictionary {
        if let data = j["data"] as? JSONDictionary {
            if let things = data["things"] as? JSONArray {
                if things.count == 1 {
                    for thing in things {
                        if let thing = thing as? [String:AnyObject] {
                            let obj:AnyObject? = Parser.parseJSON(thing)
                            if let comment = obj as? Comment {
                                return Result(value: comment)
                            }
                        }
                    }
                }
            }
        }
    }
    return Result(error:NSError.errorWithCode(10, "Could not parse response JSON to post a comment."))
}

/**
Extract Listing object which includes Comments from JSON for articles.

:param: json JSON object is obtained from reddit.com.
:returns: List consists of Comment objects.
*/
func filterArticleResponse(json:JSON) -> Result<JSON> {
    if let array = json as? [AnyObject] {
        if array.count == 2 {
            if let result = array[1] as? Listing {
                return Result(value:result)
            }
        }
    }
    return Result(error:ReddiftError.ParseListingArticles.error)
}