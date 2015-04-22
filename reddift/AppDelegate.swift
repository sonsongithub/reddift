//
//  AppDelegate.swift
//  reddift
//
//  Created by sonson on 2015/04/10.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return OAuth2Authorizer.sharedInstance.receiveRedirect(url, completion:{(token:OAuth2Token?, error:NSError?) -> Void in
            if let token = token {
                token.profile({ (profile:Account?, error:NSError?) -> Void in
                    if error == nil {
                        if let profile = profile {
                            OAuth2TokenRepository.saveIntoKeychainToken(token, name:profile.name)
                        }
                    }
                })
            }
        })
    }
}

