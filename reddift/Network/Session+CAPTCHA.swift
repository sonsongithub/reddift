//
//  Session+CAPTCHA.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
    public typealias CAPTCHAImage = UIImage
    #elseif os(OSX)
    import Cocoa
    public typealias CAPTCHAImage = NSImage
#endif

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

/**
Parse simple string response for "/api/needs_captcha"

:param: data Binary data is returned from reddit.

:returns: Result object. If data is "true" or "false", Result object has boolean, otherwise error object.
*/
func decodePNGImage(data: NSData) -> Result<CAPTCHAImage> {
    #if os(iOS)
        let captcha = UIImage(data: data)
        #elseif os(OSX)
        let captcha = NSImage(data: data)
    #endif
    return resultFromOptional(captcha, ReddiftError.GetCAPTCHAImage.error)
}

/**
Parse JSON contains "iden" for CAPTHA.
{"json": {"data": {"iden": "<code>"},"errors": []}}

:param: json JSON object, like above sample.
:returns: Result object. When parsing is succeeded, object contains iden as String.
*/
func parseCAPTCHAIdenJSON(json: JSON) -> Result<String> {
    if let json = json as? JSONDictionary {
        if let j = json["json"] as? JSONDictionary {
            if let data = j["data"] as? JSONDictionary {
                if let iden = data["iden"] as? String {
                    return Result(value:iden)
                }
            }
        }
    }
    return Result(error:ReddiftError.GetCAPTCHAIden.error)
}

extension Session {
    /**
    Check whether CAPTCHAs are needed for API methods that define the "captcha" and "iden" parameters.
    
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func checkNeedsCAPTCHA(completion:(Result<Bool>) -> Void) -> NSURLSessionDataTask? {
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/needs_captcha", method:"GET", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            data.writeToFile("/Users/sonson/Desktop/api_needs_captcha.json", atomically: false)
            self.updateRateLimitWithURLResponse(response)
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeBooleanString
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Responds with an iden of a new CAPTCHA.
    Use this endpoint if a user cannot read a given CAPTCHA, and wishes to receive a new CAPTCHA.
    To request the CAPTCHA image for an iden, use /captcha/iden.
    
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getIdenForNewCAPTCHA(completion:(Result<String>) -> Void) -> NSURLSessionDataTask? {
        let parameter:[String:String] = ["api_type":"json"]
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/new_captcha", parameter:parameter, method:"POST", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseCAPTCHAIdenJSON
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Request a CAPTCHA image given an iden.
    An iden is given as the captcha field with a BAD_CAPTCHA error, you should use this endpoint if you get a BAD_CAPTCHA error response.
    Responds with a 120x50 image/png which should be displayed to the user.
    The user's response to the CAPTCHA should be sent as captcha along with your request.
    To request a new CAPTCHA, Session.getIdenForNewCAPTCHA.
    
    :param: iden Code to get a new CAPTCHA. Use Session.getIdenForNewCAPTCHA.
    :returns: Data task which requests search to reddit.com.
    */
    public func getCAPTCHA(iden:String, completion:(Result<CAPTCHAImage>) -> Void) -> NSURLSessionDataTask? {
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/captcha/" + iden, method:"GET", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodePNGImage
            completion(result)
        })
        task.resume()
        return task
    }
    
}