//
//  Session+helper.swift
//  reddift
//
//  Created by sonson on 2015/04/26.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

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
        return .Failure(NSError.errorWithCode(response.statusCode, HttpStatus(response.statusCode).description))
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
    return Result(error:NSError.errorWithCode(2, "Failed to parse JSON object unexpectedly."))
}

func parseThing_t2_JSON(json:JSON) -> Result<JSON> {
    let error = NSError.errorWithCode(2, "Failed to parse t2 JSON.")
    if let object = json >>> JSONObject {
        return resultFromOptional(Parser.parseDataInThing_t2(object), error)
    }
    return resultFromOptional(nil, error)
}

func parseListFromJSON(json: JSON) -> Result<JSON> {
    let object:AnyObject? = Parser.parseJSON(json)
    return resultFromOptional(object, NSError.errorWithCode(2, "Failed to parse JSON object unexpectedly."))
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
    return Result(error:NSError.errorWithCode(2, "Unexepcted data. It's neither true nor false."))
}

/**
Parse simple string response for "/api/needs_captcha"

:param: data Binary data is returned from reddit.

:returns: Result object. If data is "true" or "false", Result object has boolean, otherwise error object.
*/
func decodePNGImage(data: NSData) -> Result<UIImage> {
    let captcha = UIImage(data: data)
    return resultFromOptional(captcha, NSError.errorWithCode(2, "Couldn't open image file as CAPTCHA."))
}

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
    return Result(error:NSError.errorWithCode(2, "Failed to parse iden for CAPTHA."))
}

func filterArticleResponse(json:JSON) -> Result<JSON> {
    if let array = json as? [AnyObject] {
        if array.count == 2 {
            if let result = array[1] as? Listing {
                return Result(value:result)
            }
        }
    }
    return Result(error:NSError.errorWithCode(2, "Failed to parse article JSON object."))
}