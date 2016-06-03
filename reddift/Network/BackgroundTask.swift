//
//  BackgroundTask.swift
//  reddift
//
//  Created by sonson on 2016/06/03.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

/// Session class to communicate with reddit.com using OAuth.
public class BackgroundChecker: NSObject, NSURLSessionDelegate {
    let session: Session
    var taskURLSession: NSURLSession? = nil
    var tokenURLSession: NSURLSession? = nil
    var firstTrial: Bool = false
    let handler: ((UIBackgroundFetchResult) -> Void)
    
    public init(_ currentSession: Session, completionHandler: (UIBackgroundFetchResult) -> Void) {
        session = currentSession
        handler = completionHandler
        super.init()
        taskURLSession = NSURLSession(configuration: NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.sonson.reddift.task"), delegate: self, delegateQueue: nil)
        tokenURLSession = NSURLSession(configuration: NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("com.sonson.reddift.token"), delegate: self, delegateQueue: nil)
    }
}