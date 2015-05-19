//
//  Session+multis.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Session {
    /**
    Create a new multi. Responds with 409 Conflict if it already exists.
    
    :param: multis Multis object for new multi.
    :param: multipath Path at where a new multi will be created.
    */
    func createMulti(multi:Multi, multiPath:String, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {        
//        var customAllowedSet =  NSCharacterSet.URLQueryAllowedCharacterSet()
//        var escapedSubject = subject.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
//        var escapedText = text.stringByAddingPercentEncodingWithAllowedCharacters(customAllowedSet)
//        
//        if let escapedSubject = escapedSubject, let escapedText = escapedText {
//            var parameter:[String:String] = [:]
//            
//            parameter["api_type"] = "json"
//            parameter["captcha"] = captcha
//            parameter["iden"] = captchaIden
//            
//            parameter["from_sr"] = fromSubreddit.displayName
//            parameter["text"] = escapedText
//            parameter["subject"] = escapedSubject
//            parameter["to"] = to.id
//            
//            var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/submit", parameter:parameter, method:"POST", token:token)
//            return handleAsJSONRequest(request, completion:completion)
//        }
        return nil
    }
    
    /**
    Get specified multi.
    */
    func getMulti(multi:Multi, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:multi.path + ".json", method:"GET", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> parseListFromJSON
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Get users own multis.
    */
    func getMineMulti(completion:(Result<[Multi]>) -> Void) -> NSURLSessionDataTask? {
        var request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/api/multi/mine", method:"GET", token:token)
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData!, response:NSURLResponse!, error:NSError!) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let responseResult = resultFromOptionalError(Response(data: data, urlResponse: response), error)
            let result = responseResult >>> parseResponse >>> decodeJSON >>> Parser.parseDataInJSON_Multi
            completion(result)
        })
        task.resume()
        return task
    }
}