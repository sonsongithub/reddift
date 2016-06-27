//
//  BackgroundFetch.swift
//  reddift
//
//  Created by sonson on 2016/06/03.
//  Copyright © 2016年 sonson. All rights reserved.
//


import UIKit

/// Session class to communicate with reddit.com using OAuth.
public class BackgroundFetch: NSObject, URLSessionDelegate {
    let session: Session
    var taskURLSession: Foundation.URLSession? = nil
    var tokenURLSession: Foundation.URLSession? = nil
    var firstTry: Bool = true
    let taskHandler: ((response: HTTPURLResponse?, dataURL: URL?, error: NSError?) -> Void)
    var request: URLRequest
    
    public init(_ currentSession: Session, request aRequest: URLRequest, taskHandler aTaskHandler: (response: HTTPURLResponse?, dataURL: URL?, error: NSError?) -> Void) {
        session = currentSession
        taskHandler = aTaskHandler
        request = aRequest
        super.init()
        taskURLSession = Foundation.URLSession(configuration: URLSessionConfiguration.background(withIdentifier: "com.sonson.reddift.profile"), delegate: self, delegateQueue: nil)
        tokenURLSession = Foundation.URLSession(configuration: URLSessionConfiguration.background(withIdentifier: "com.sonson.reddift.token"), delegate: self, delegateQueue: nil)
    }
    
    public func resume() {
        guard let taskURLSession = self.taskURLSession else { return }
        taskURLSession.downloadTask(with: request).resume()
    }
    
    func handleTaskResponse(_ response: HTTPURLResponse, didFinishDownloadingToURL: URL, requestForRefreshToken: URLRequest) {
        if response.statusCode == 401 {
            if firstTry {
                if let tokenURLSession = self.tokenURLSession {
                    firstTry = false
                    tokenURLSession.downloadTask(with: requestForRefreshToken).resume()
                }
            } else {
                taskHandler(response: nil, dataURL: nil, error: NSError(domain: "", code: 0, userInfo: nil))
            }
        } else {
            taskHandler(response: response, dataURL: didFinishDownloadingToURL, error: nil)
        }
    }
    
    func handleTokenRefreshResponse(_ response: HTTPURLResponse, didFinishDownloadingToURL: URL, token: OAuth2Token) {
        if response.statusCode == 200 {
            let data = try? Data(contentsOf: didFinishDownloadingToURL)
            let result: Result<JSONDictionary> = Result(from: Response(data: data, urlResponse: response), optional:nil)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(redditAny2Object)
            let result2 = refreshTokenWithJSON(result, token: token)
            switch result2 {
            case .success(let token):
                session.token = token
                request.setOAuth2Token(token)
                resume()
            case .failure(let error):
                taskHandler(response: nil, dataURL: nil, error: error)
            }
        } else {
            taskHandler(response: nil, dataURL: nil, error: NSError(domain: "", code: 0, userInfo: nil))
        }
    }
    
    func URLSession(_ URLSession: Foundation.URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingToURL: URL) {
        guard let response = downloadTask.response as? HTTPURLResponse
            else { return }
        guard let token = session.token as? OAuth2Token
            else { return }
        guard let requestForRefreshToken = token.requestForRefreshing()
            else { return }
        
        if URLSession == tokenURLSession {
            handleTokenRefreshResponse(response, didFinishDownloadingToURL: didFinishDownloadingToURL, token: token)
        } else if URLSession == taskURLSession {
            handleTaskResponse(response, didFinishDownloadingToURL: didFinishDownloadingToURL, requestForRefreshToken:  requestForRefreshToken as URLRequest)
        } else {
            taskHandler(response: nil, dataURL: nil, error: NSError(domain: "", code: 0, userInfo: nil))
        }
    }
    
    func URLSession(_ session: Foundation.URLSession, error: NSError?) {
        taskHandler(response: nil, dataURL: nil, error: error)
    }
}
