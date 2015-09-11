//
//  AppDelegate.swift
//  reddift
//
//  Created by sonson on 2015/04/10.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import reddift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return OAuth2Authorizer.sharedInstance.receiveRedirect(url, completion:{(result) -> Void in
            switch result {
            case .Failure(let error):
                print(error)
            case .Success(let token):
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    OAuth2TokenRepository.saveIntoKeychainToken(token, name:token.name)
                })
            }
        })
    }
}

