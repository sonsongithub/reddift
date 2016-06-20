//
//  Session+CAPTCHA.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
    public typealias CAPTCHAImage = UIImage
#elseif os(OSX)
    import Cocoa
    public typealias CAPTCHAImage = NSImage
#endif

/**
Parse simple string response for "/api/needs_captcha"

- parameter data: Binary data is returned from reddit.

- returns: Result object. If data is "true" or "false", Result object has boolean, otherwise error object.
*/
func data2Bool(data: NSData) -> Result<Bool> {
    let decoded = NSString(data:data as Data, encoding:String.Encoding.utf8.rawValue)
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

- parameter data: Binary data is returned from reddit.

- returns: Result object. If data is "true" or "false", Result object has boolean, otherwise error object.
*/
func data2Image(data: NSData) -> Result<CAPTCHAImage> {
#if os(iOS) || os(tvOS)
    let captcha = UIImage(data: data as Data)
#elseif os(OSX)
    let captcha = NSImage(data: data)
#endif
    return resultFromOptional(optional: captcha, error: ReddiftError.GetCAPTCHAImage.error)
}

/**
Parse JSON contains "iden" for CAPTHA.
{"json": {"data": {"iden": "<code>"},"errors": []}}

- parameter json: JSON object, like above sample.
- returns: Result object. When parsing is succeeded, object contains iden as String.
*/
func idenJSON2String(json: JSON) -> Result<String> {
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
    
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func checkNeedsCAPTCHA(completion:(Result<Bool>) -> Void) throws -> URLSessionDataTask {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/needs_captcha", method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Bool)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Responds with an iden of a new CAPTCHA.
    Use this endpoint if a user cannot read a given CAPTCHA, and wishes to receive a new CAPTCHA.
    To request the CAPTCHA image for an iden, use /captcha/iden.
    
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getIdenForNewCAPTCHA(completion:(Result<String>) -> Void) throws -> URLSessionDataTask {
        let parameter:[String:String] = ["api_type":"json"]
		guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/api/new_captcha", parameter:parameter, method:"POST", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Json)
                .flatMap(transform: idenJSON2String)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Request a CAPTCHA image for given an iden.
    An iden is given as the captcha field with a BAD_CAPTCHA error, you should use this endpoint if you get a BAD_CAPTCHA error response.
    Responds with a 120x50 image/png which should be displayed to the user.
    The user's response to the CAPTCHA should be sent as captcha along with your request.
    To request a new CAPTCHA, Session.getIdenForNewCAPTCHA.
    
    - parameter iden: Code to get a new CAPTCHA. Use Session.getIdenForNewCAPTCHA.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getCAPTCHA(iden:String, completion:(Result<CAPTCHAImage>) -> Void) throws -> URLSessionDataTask {
		guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL: baseURL, path:"/captcha/" + iden, method:"GET", token:token)
            else { throw ReddiftError.URLError.error }
        let task = URLSession.shared().dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response: response)
            let result = resultFromOptionalError(value: Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(transform: response2Data)
                .flatMap(transform: data2Image)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Request a CAPTCHA image
    Responds with a 120x50 image/png which should be displayed to the user.
    The user's response to the CAPTCHA should be sent as captcha along with your request.
    
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getCAPTCHA(completion:(Result<CAPTCHAImage>) -> Void) throws -> Void {
        do {
            try getIdenForNewCAPTCHA { (result) -> Void in
                switch result {
                case .Failure(let error):
                    completion(Result(error: error))
                case .Success(let iden):
                    do {
                        try self.getCAPTCHA(iden: iden, completion:completion)
                    }
                    catch { completion(Result(error: error as NSError)) }
                }
            }
        }
        catch { completion(Result(error: error as NSError)) }
    }
}
