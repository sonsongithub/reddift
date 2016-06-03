//
//  BackgroundInboxChecker.swift
//  reddift
//
//  Created by sonson on 2016/06/01.
//  Copyright © 2016年 sonson. All rights reserved.
//

import UIKit
//
///// Session class to communicate with reddit.com using OAuth.
//public class BackgroundInboxChecker: NSObject, NSURLSessionDelegate {
//    let session: Session
//    var taskURLSession: NSURLSession? = nil
//    var tokenURLSession: NSURLSession? = nil
//    var firstTry: Bool = true
//    let completionHandler: ((UIBackgroundFetchResult) -> Void)
//    let taskHandler: ((response: NSHTTPURLResponse, dataURL: NSURL) -> UIBackgroundFetchResult)
//    let request: NSURLRequest
//    
//    public init(_ currentSession: Session, completionHandler aCompletionHandler: (UIBackgroundFetchResult) -> Void, request aRequest: NSURLRequest, taskHandler aTaskHandler: (response: NSHTTPURLResponse, dataURL: NSURL) -> UIBackgroundFetchResult) {
//        session = currentSession
//        completionHandler = aCompletionHandler
//        taskHandler = aTaskHandler
//        request = aRequest
//        super.init()
//        taskURLSession = NSURLSession(configuration: NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.sonson.reddift.profile"), delegate: self, delegateQueue: nil)
//        tokenURLSession = NSURLSession(configuration: NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.sonson.reddift.token"), delegate: self, delegateQueue: nil)
//    }
//    
//    public func resume() {
//        guard let taskURLSession = self.taskURLSession else { return }
//        taskURLSession.downloadTaskWithRequest(request).resume()
//    }
//    
//    public func check() {
//    }
//    
//    func handleTaskResponse(response: NSHTTPURLResponse, didFinishDownloadingToURL: NSURL, requestForRefreshToken: NSURLRequest) {
//        if response.statusCode == 401 {
//            if firstTry {
//                if let tokenURLSession = self.tokenURLSession {
//                    firstTry = false
//                    tokenURLSession.downloadTaskWithRequest(requestForRefreshToken).resume()
//                }
//            } else {
//                // error
//                completionHandler(.Failed)
//            }
//        } else {
//            taskHandler(response: response, dataURL: didFinishDownloadingToURL)
//        }
////        } else if response.statusCode == 200 {
////            let data = NSData(contentsOfURL: didFinishDownloadingToURL)
////            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:nil)
////                .flatMap(response2Data)
////                .flatMap(data2Json)
////                .flatMap(json2Account)
////            switch result {
////            case .Success(let account):
////                print(account)
////                UIApplication.sharedApplication().applicationIconBadgeNumber = account.inboxCount
////                handler(.NewData)
////            case .Failure(let error):
////                print(error)
////                handler(.Failed)
////            }
////        }
//    }
//    
//    func handleTokenRefreshResponse(response: NSHTTPURLResponse, didFinishDownloadingToURL: NSURL, token: OAuth2Token) {
//        if response.statusCode == 200 {
//            let data = NSData(contentsOfURL: didFinishDownloadingToURL)
//            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:nil)
//                .flatMap(response2Data)
//                .flatMap(data2Json)
//                .flatMap({(json: JSON) -> Result<[String:AnyObject]> in
//                    if let json = json as? [String:AnyObject] {
//                        return Result(value: json)
//                    }
//                    return Result(error: ReddiftError.Malformed.error)
//                })
//            switch result {
//            case .Success(let json):
//                var newJSON = json
//                newJSON["name"] = token.name
//                newJSON["refresh_token"] = token.refreshToken
//                switch OAuth2Token.tokenWithJSON(newJSON) {
//                case .Success(let token):
//                    session.token = token
//                    resume()
//
//                case .Failure(let error):
//                    print(error)
//                    handler(.Failed)
//                }
//            case .Failure(let error):
//                print(error)
//                handler(.Failed)
//            }
//        } else {
//            handler(.Failed)
//        }
//    }
//    
//    func URLSession(URLSession: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL: NSURL) {
//        guard let response = downloadTask.response as? NSHTTPURLResponse
//            else { return }
//        guard let token = session.token as? OAuth2Token
//            else { return }
//        guard let requestForRefreshToken = token.requestForRefreshing()
//            else { return }
//        
//        if URLSession == tokenURLSession {
//            handleTokenRefreshResponse(response, didFinishDownloadingToURL: didFinishDownloadingToURL, token: token)
//        } else if URLSession == taskURLSession {
//            handleTaskResponse(response, didFinishDownloadingToURL: didFinishDownloadingToURL, requestForRefreshToken:  requestForRefreshToken)
//        }
////        print(downloadTask.response)
////        if URLSession == profileURLSession {
////            if let response = downloadTask.response as? NSHTTPURLResponse {
////                if response.statusCode == 401 {
////                    if !again {
////                        if let token = session.token as? OAuth2Token, tokenURLSession = self.tokenURLSession {
////                            again = true
////                            guard let request = token.requestForRefreshing() else { return }
////                            let task = tokenURLSession.downloadTaskWithRequest(request)
////                            task.resume()
////                        }
////                    } else {
////                        handler(.Failed)
////                    }
////                } else if response.statusCode == 200 {
////                    let data = NSData(contentsOfURL: didFinishDownloadingToURL)
////                    let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:nil)
////                        .flatMap(response2Data)
////                        .flatMap(data2Json)
////                        .flatMap(json2Account)
////                    switch result {
////                    case .Success(let account):
////                        print(account)
////                        UIApplication.sharedApplication().applicationIconBadgeNumber = account.inboxCount
////                        handler(.NewData)
////                    case .Failure(let error):
////                        print(error)
////                        handler(.Failed)
////                    }
////                }
////            }
////        } else if URLSession == tokenURLSession {
////            if let response = downloadTask.response as? NSHTTPURLResponse, token = session.token {
////                if response.statusCode == 200 {
////                    let data = NSData(contentsOfURL: didFinishDownloadingToURL)
////                    let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:nil)
////                        .flatMap(response2Data)
////                        .flatMap(data2Json)
////                        .flatMap({(json: JSON) -> Result<[String:AnyObject]> in
////                            if let json = json as? [String:AnyObject] {
////                                return Result(value: json)
////                            }
////                            return Result(error: ReddiftError.Malformed.error)
////                        })
////                    switch result {
////                    case .Success(let json):
////                        var newJSON = json
////                        newJSON["name"] = token.name
////                        newJSON["refresh_token"] = token.refreshToken
////                        switch OAuth2Token.tokenWithJSON(newJSON) {
////                        case .Success(let token):
////                            session.token = token
////                            guard let profileURLSession = self.profileURLSession else { return }
////                            do {
////                                again = true
////                                let request = try session.requestForGettingProfile()
////                                let task = profileURLSession.downloadTaskWithRequest(request)
////                                task.resume()
////                            } catch {
////                                print(error)
////                                handler(.Failed)
////                            }
////
////                        case .Failure(let error):
////                            print(error)
////                            handler(.Failed)
////                        }
////                    case .Failure(let error):
////                        print(error)
////                        handler(.Failed)
////                    }
////                } else {
////                    handler(.Failed)
////                }
////            }
////        }
//    }
//    
//    func URLSession(session: NSURLSession, error: NSError?) {
//        completionHandler(.Failed)
//    }
//    
//    public func URLSessionDidFinishEventsForBackgroundURLSession(session: NSURLSession) {
//    }
//}
