//
//  Session+helper.swift
//  reddift
//
//  Created by sonson on 2015/04/26.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

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
        return .Failure(HttpStatus(code:response.statusCode).error)
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

func parseThing_t2_JSON(json:JSON) -> Result<JSON> {
    if let object = json >>> JSONObject {
        return resultFromOptional(Parser.parseDataInThing_t2(object), ReddiftError.ParseThingT2.error)
    }
    return resultFromOptional(nil, ReddiftError.ParseThingT2.error)
}

func parseListFromJSON(json: JSON) -> Result<JSON> {
    let object:AnyObject? = Parser.parseJSON(json)
    return resultFromOptional(object, ReddiftError.ParseThing.error)
}

/**
Parse simple string response for "/api/needs_captcha"

:param: data Binary data is returned from reddit.

:returns: Result object. If data is "true" or "false", Result object has boolean, otherwise error object.
*/
func decodeBooleanString(data: NSData) -> Result<Bool> {
    var decoded = NSString(data:data, encoding:NSUTF8StringEncoding)
    if let decoded = decoded {
        if decoded == "true" {
            return Result(value:true)
        }
        else if decoded == "false" {
            return Result(value:false)
        }
    }
    return Result(error:ReddiftError.CheckNeedsCAPTHCA.error)
}


#if os(iOS)
/**
Parse simple string response for "/api/needs_captcha"

:param: data Binary data is returned from reddit.

:returns: Result object. If data is "true" or "false", Result object has boolean, otherwise error object.
*/
func decodePNGImage(data: NSData) -> Result<UIImage> {
    let captcha = UIImage(data: data)
    return resultFromOptional(captcha, ReddiftError.GetCAPTCHAImage.error)
}
#endif

/**
Parse JSON contains "iden" for CAPTHA.

{
"json": {
"data": {
"iden": "<code>"
},
"errors": []
}
}

:param: json JSON object, like above sample.

:returns: Result object. When parsing is succeeded, object contains iden as String.
*/
func parseCAPTCHAIdenJSON(json: JSON) -> Result<String> {
    if let j = json["json"] as? [String:AnyObject] {
        if let data = j["data"] as? [String:AnyObject] {
            if let iden = data["iden"] as? String {
                return Result(value:iden)
            }
        }
    }
    return Result(error:ReddiftError.GetCAPTCHAIden.error)
}

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