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
public let OAuth2TokenRepositoryDidSaveTokenName = Notification.Name(rawValue: "OAuth2TokenRepositoryDidSaveToken")

/// Posted when the OAuth2TokenRepository object failed to save a token successfully into Keychain.
public let OAuth2TokenRepositoryDidFailToSaveTokenName = Notification.Name(rawValue: "OAuth2TokenRepositoryDidFailToSaveToken")

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var fetcher: BackgroundFetch? = nil
    var session: Session? = nil
    var window: UIWindow?
    
    private func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : Any]?) -> Bool {
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        if let name = UserDefaults.standard.string(forKey: "name") {
            do {
                let token = try OAuth2TokenRepository.token(of: name)
                session = Session(token: token)
            } catch { print(error) }
        }
        
        let settings = UIUserNotificationSettings(
            types: [.badge, .sound, .alert],
            categories: nil)
        application.registerUserNotificationSettings(settings);
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let session = session {
            do {
                let request = try session.requestForGettingProfile()
                let fetcher = BackgroundFetch(current: session,
                                              request: request,
                                              taskHandler: { (response, dataURL, error) -> Void in
                                                if let response = response, let dataURL = dataURL {
                                                    if response.statusCode == HttpStatus.ok.rawValue {
                                                        
                                                        do {
                                                            let data = try Data(contentsOf: dataURL)
                                                            let result = accountInResult(from: data, response: response)
                                                            switch result {
                                                            case .success(let account):
                                                                print(account)
                                                                UIApplication.shared.applicationIconBadgeNumber = account.inboxCount
                                                                self.postLocalNotification("You got \(account.inboxCount) messages.")
                                                                completionHandler(.newData)
                                                                return
                                                            case .failure(let error):
                                                                print(error)
                                                                self.postLocalNotification("\(error)")
                                                                completionHandler(.failed)
                                                            }
                                                        }
                                                        catch {
                                                            
                                                        }
                                                    }
                                                    else {
                                                        self.postLocalNotification("response code \(response.statusCode)")
                                                        completionHandler(.failed)
                                                    }
                                                } else {
                                                    self.postLocalNotification("Error can not parse response and data.")
                                                    completionHandler(.failed)
                                                }
                })
                fetcher.resume()
                self.fetcher = fetcher
            } catch {
                postLocalNotification("\(error)")
                completionHandler(.failed)
            }
        } else {
            postLocalNotification("session is not available.")
            completionHandler(.failed)
        }
    }
    
    func postLocalNotification(_ message: String) {
        let notification = UILocalNotification()
        notification.timeZone = NSTimeZone.default
        notification.alertBody = message
        notification.alertAction = "OK"
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification);
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return OAuth2Authorizer.sharedInstance.receiveRedirect(url, completion: {(result) -> Void in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let token):
                DispatchQueue.main.async(execute: { () -> Void in
                    do {
                        try OAuth2TokenRepository.save(token: token, of: token.name)
                        NotificationCenter.default.post(name: OAuth2TokenRepositoryDidSaveTokenName, object: nil, userInfo: nil)
                    } catch {
                        NotificationCenter.default.post(name: OAuth2TokenRepositoryDidFailToSaveTokenName, object: nil, userInfo: nil)
                        print(error)
                    }
                })
            }
        })
    }
}
