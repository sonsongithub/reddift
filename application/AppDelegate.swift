//
//  AppDelegate.swift
//  reddift
//
//  Created by sonson on 2015/09/01.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import reddift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ImageCache {
    var session: Session?
    var window: UIWindow?
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // handle redirect URL from reddit.com
        return OAuth2Authorizer.sharedInstance.receiveRedirect(url as URL, completion: {(result) -> Void in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let token):
                DispatchQueue.main.async(execute: { () -> Void in
                    do {
                        try OAuth2TokenRepository.save(token: token, of: token.name)
                        NotificationCenter.default.post(name: OAuth2TokenRepositoryDidSaveTokenName, object: nil, userInfo: nil)
                    } catch { print(error) }
                })
            }
        })
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // handle redirect URL from reddit.com
        return OAuth2Authorizer.sharedInstance.receiveRedirect(url as URL, completion: {(result) -> Void in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let token):
                DispatchQueue.main.async(execute: { () -> Void in
                    do {
                        try OAuth2TokenRepository.save(token: token, of: token.name)
                        NotificationCenter.default.post(name: OAuth2TokenRepositoryDidSaveTokenName, object: nil, userInfo: nil)
                    } catch { print(error) }
                })
            }
        })
    }
    
    func refreshSession() {
        // refresh current session token
        do {
            try self.session?.refreshToken({ (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let token):
                    DispatchQueue.main.async(execute: { () -> Void in
                        print(token)
                        NotificationCenter.default.post(name: OAuth2TokenRepositoryDidSaveTokenName, object: nil, userInfo: nil)
                    })
                }
            })
        } catch { print(error) }
    }

    func reloadSession() {
        // reddit username is save NSUserDefaults using "currentName" key.
        // create an authenticated or anonymous session object
        if let currentName = UserDefaults.standard.object(forKey: "currentName") as? String {
            do {
                let token = try OAuth2TokenRepository.token(of: currentName)
                self.session = Session(token: token)
                self.refreshSession()
            } catch { print(error) }
        } else {
            self.session = Session()
        }
        
        NotificationCenter.default.post(name: OAuth2TokenRepositoryDidUpdateTokenName, object: nil, userInfo: nil)
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        self.reloadSession()
//        deleteAllThumbnails()
//        deleteAllCaches()
        DispatchQueue.global(qos: .default).async {
            let html = ""
            do {
                if let data = html.data(using: .unicode) {
                    let attr = try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                    print(attr)
                }
            } catch {
            }
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.refreshSession()
    }
}

extension UIApplication {
    static func appDelegate() -> AppDelegate? {
        if let obj = self.shared.delegate as? AppDelegate {
            return obj
        }
        return nil
    }
}
