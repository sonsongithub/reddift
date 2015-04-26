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
        return OAuth2Authorizer.sharedInstance.receiveRedirect(url, completion:{(result) -> Void in
            switch result {
            case let .Error(error):
                println(error.code)
            case let .Value(box):
                let token = box.value
                token.getProfile({ (result) -> Void in
                    switch result {
                    case let .Error(error):
                        println(error.code)
                    case let .Value(box):
                        if let profile = box.value as? Account {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                OAuth2TokenRepository.saveIntoKeychainToken(token, name:profile.name)
                            })
                        }
                    }
                })
            }
        })
    }
}

