//
//  AppDelegate.swift
//  reddift
//
//  Created by sonson on 2015/04/10.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit
import reddift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return OAuth2Authorizer.sharedInstance.receiveRedirect(url, completion:{(result) -> Void in
            switch result {
            case let .Failure:
                println(result.error)
            case let .Success:
                if let token = result.value as OAuth2Token? {
                    token.getProfile({ (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error)
                        case let .Success:
                            if let profile = result.value as? Account {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    OAuth2TokenRepository.saveIntoKeychainToken(token, name:profile.name)
                                })
                            }
                        }
                    })
                }
            }
        })
    }
}

