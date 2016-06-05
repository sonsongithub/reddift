//
//  BackgroundFetch.swift
//  reddift
//
//  Created by sonson on 2016/06/03.
//  Copyright © 2016年 sonson. All rights reserved.
//


import UIKit

public func parseAccount(data: NSData, response: NSURLResponse) -> Result<Account> {
    return resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:nil)
        .flatMap(response2Data)
        .flatMap(data2Json)
        .flatMap(json2Account)
}

/// Session class to communicate with reddit.com using OAuth.
public class BackgroundFetch: NSObject, NSURLSessionDelegate {
    let session: Session
    var taskURLSession: NSURLSession? = nil
    var tokenURLSession: NSURLSession? = nil
    var firstTry: Bool = true
    let taskHandler: ((response: NSHTTPURLResponse?, dataURL: NSURL?, error: NSError?) -> Void)
    var request: NSURLRequest
    
    public init(_ currentSession: Session, request aRequest: NSURLRequest, taskHandler aTaskHandler: (response: NSHTTPURLResponse?, dataURL: NSURL?, error: NSError?) -> Void) {
        session = currentSession
        taskHandler = aTaskHandler
        request = aRequest
        super.init()
        taskURLSession = NSURLSession(configuration: NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.sonson.reddift.profile"), delegate: self, delegateQueue: nil)
        tokenURLSession = NSURLSession(configuration: NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.sonson.reddift.token"), delegate: self, delegateQueue: nil)
    }
    
    public func resume() {
        guard let taskURLSession = self.taskURLSession else { return }
        taskURLSession.downloadTaskWithRequest(request).resume()
    }
    
    func handleTaskResponse(response: NSHTTPURLResponse, didFinishDownloadingToURL: NSURL, requestForRefreshToken: NSURLRequest) {
        if response.statusCode == 401 {
            if firstTry {
                if let tokenURLSession = self.tokenURLSession {
                    firstTry = false
                    tokenURLSession.downloadTaskWithRequest(requestForRefreshToken).resume()
                }
            } else {
                taskHandler(response: nil, dataURL: nil, error: NSError(domain: "", code: 0, userInfo: nil))
            }
        } else {
            taskHandler(response: response, dataURL: didFinishDownloadingToURL, error: nil)
        }
    }
    
    func handleTokenRefreshResponse(response: NSHTTPURLResponse, didFinishDownloadingToURL: NSURL, token: OAuth2Token) {
        if response.statusCode == 200 {
            let data = NSData(contentsOfURL: didFinishDownloadingToURL)
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:nil)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap({(json: JSON) -> Result<[String:AnyObject]> in
                    if let json = json as? [String:AnyObject] {
                        return Result(value: json)
                    }
                    return Result(error: ReddiftError.Malformed.error)
                })
            let result2 = refreshTokenWithJSON(result, token: token)
            switch result2 {
            case .Success(let token):
                session.token = token
                request = request.updateWithOAuth2Token(token)
                resume()
            case .Failure(let error):
                taskHandler(response: nil, dataURL: nil, error: error)
            }
        } else {
            taskHandler(response: nil, dataURL: nil, error: NSError(domain: "", code: 0, userInfo: nil))
        }
    }
    
    func URLSession(URLSession: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL: NSURL) {
        guard let response = downloadTask.response as? NSHTTPURLResponse
            else { return }
        guard let token = session.token as? OAuth2Token
            else { return }
        guard let requestForRefreshToken = token.requestForRefreshing()
            else { return }
        
        if URLSession == tokenURLSession {
            handleTokenRefreshResponse(response, didFinishDownloadingToURL: didFinishDownloadingToURL, token: token)
        } else if URLSession == taskURLSession {
            handleTaskResponse(response, didFinishDownloadingToURL: didFinishDownloadingToURL, requestForRefreshToken:  requestForRefreshToken)
        } else {
            taskHandler(response: nil, dataURL: nil, error: NSError(domain: "", code: 0, userInfo: nil))
        }
    }
    
    func URLSession(session: NSURLSession, error: NSError?) {
        taskHandler(response: nil, dataURL: nil, error: error)
    }
}
