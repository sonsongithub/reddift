//
//  AppDelegate.swift
//  reddift
//
//  Created by sonson on 2015/04/10.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import reddift

/// Posted when the OAuth2TokenRepository object succeed in saving a token successfully into Keychain.
public let OAuth2TokenRepositoryDidSaveToken            = "OAuth2TokenRepositoryDidSaveToken"
/// Posted when the OAuth2TokenRepository object failed to save a token successfully into Keychain.
public let OAuth2TokenRepositoryDidFailToSaveToken      = "OAuth2TokenRepositoryDidFailToSaveToken"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var fetcher: BackgroundFetch? = nil
    var session: Session? = nil
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        if let name = NSUserDefaults.standardUserDefaults().stringForKey("name") {
            do {
                let token: OAuth2Token = try OAuth2TokenRepository.restoreFromKeychainWithName(name)
                session = Session(token: token)
            } catch { print(error) }
        }
        
        let settings = UIUserNotificationSettings(
            forTypes: [.Badge, .Sound, .Alert],
            categories: nil)
        application.registerUserNotificationSettings(settings);
        
        return true
    }
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        if let session = session {
            let request = try! session.requestForGettingProfile()
            let fetcher = BackgroundFetch(session,
                                      request: request,
                                      taskHandler: { (response, dataURL, error) -> Void in
                                        if let response = response, dataURL = dataURL, data = NSData(contentsOfURL: dataURL) {
                                            if response.statusCode == 200 {
                                                let result = accountByParsingData(data, response: response)
                                                switch result {
                                                case .Success(let account):
                                                    print(account)
                                                    UIApplication.sharedApplication().applicationIconBadgeNumber = account.inboxCount
                                                    completionHandler(.NewData)
                                                    return
                                                case .Failure(let error):
                                                    print(error)
                                                    completionHandler(.Failed)
                                                }
                                            }
                                        } else {
                                            completionHandler(.Failed)
                                        }
            })
            fetcher.resume()
            self.fetcher = fetcher
        }
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return OAuth2Authorizer.sharedInstance.receiveRedirect(url, completion: {(result) -> Void in
            switch result {
            case .Failure(let error):
                print(error)
            case .Success(let token):
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    do {
                        try OAuth2TokenRepository.saveIntoKeychainToken(token, name:token.name)
                        NSNotificationCenter.defaultCenter().postNotificationName(OAuth2TokenRepositoryDidSaveToken, object: nil, userInfo: nil)
                    } catch {
                        NSNotificationCenter.defaultCenter().postNotificationName(OAuth2TokenRepositoryDidFailToSaveToken, object: nil, userInfo: nil)
                        print(error)
                    }
                })
            }
        })
    }
}
