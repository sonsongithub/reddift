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
        return .Failure(NSError(domain: "com.sonson.reddift", code: response.statusCode, userInfo:nil))
    }
    return .Success(Box(response.data))
}

func decodeJSON(data: NSData) -> Result<JSON> {
    var jsonErrorOptional: NSError?
    let jsonOptional: JSON? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &jsonErrorOptional)
    if let jsonError = jsonErrorOptional {
        return resultFromOptional(jsonOptional, jsonError)
    }
    return resultFromOptional(jsonOptional, NSError(domain: "com.sonson.reddift", code: 2, userInfo: ["description":"Failed to parse JSON object unexpectedly."]))
}

func parseThing_t2_JSON(json:JSON) -> Result<JSON> {
    let error = NSError(domain: "com.sonson.reddift", code: 1, userInfo: ["description":"Failed to parse t2 JSON."])
    if let object = json >>> JSONObject {
        return resultFromOptional(Parser.parseDataInThing_t2(object), error)
    }
    return resultFromOptional(nil, error)
}

func parseListFromJSON(json: JSON) -> Result<JSON> {
    let object:AnyObject? = Parser.parseJSON(json)
    return resultFromOptional(object, NSError(domain: "com.sonson.reddift", code: 1, userInfo: ["description":"Failed to parse JSON of reddit style."]))
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
    return Result(error:NSError(domain: "com.sonson.reddift", code: 1, userInfo:nil))
}

/**
Parse simple string response for "/api/needs_captcha"

:param: data Binary data is returned from reddit.

:returns: Result object. If data is "true" or "false", Result object has boolean, otherwise error object.
*/
func decodePNGImage(data: NSData) -> Result<UIImage> {
    let captcha = UIImage(data: data)
    return resultFromOptional(captcha, NSError(domain: "com.sonson.reddift", code: 1, userInfo: ["description":"Couldn't open image file as CAPTCHA."]))
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
                return resultFromOptional(iden, NSError(domain: "com.sonson.reddift", code: 1, userInfo: ["description":"Failed to parse JSON of reddit style."]))
            }
        }
    }
    return Result(error:NSError(domain: "com.sonson.reddift", code: 1, userInfo: ["description":"Failed to parse JSON of reddit style."]))
}

func filterArticleResponse(json:JSON) -> Result<JSON> {
    let error = NSError(domain: "com.sonson.reddift", code: 1, userInfo: ["description":"Failed to parse article JSON object."])
    if let array = json as? [AnyObject] {
        if array.count == 2 {
            if let result = array[1] as? Listing {
                return resultFromOptional(result, error)
            }
        }
    }
    return Result(error:error)
}