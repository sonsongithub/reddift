//
//  Config.swift
//  reddift
//
//  Created by sonson on 2015/04/13.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
Class to manage parameters of reddift.
This class is used as singleton model
*/
class Config {
    var version = "1.0"
    var bundleIdentifier = ""
    var developerName = ""
    var redirectURI = ""
    var clientID = ""
    
    /**
    Singleton model.
    */
    static let sharedInstance = Config()
    
    /**
    Returns User-Agent for API
    */
    var userAgent:String {
        get {
            return "ios:" + bundleIdentifier + ":v" + version + "(by /u/" + developerName + ")"
        }
    }
    
    /**
    Returns scheme of redirect URI.
    */
    var redirectURIScheme:String {
        get {
            if let scheme = NSURL(string:redirectURI)?.scheme {
                return scheme
            }
            else {
                return ""
            }
        }
    }
    
    /**
    Read from info.plist and Config.json file.
    */
    func readFromFile() {
        if let temp = NSBundle.infoValueFromMainBundleForKey("CFBundleShortVersionString") as? String{
            version = temp
        }
        if let temp = NSBundle.infoValueFromMainBundleForKey("CFBundleIdentifier") as? String{
            bundleIdentifier = temp
        }
        if let path = NSBundle.mainBundle().pathForResource("reddift_config", ofType: "json") {
            if let data = NSData(contentsOfFile: path) {
                if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
                    if let temp = json["DeveloperName"] as? String{
                        developerName = temp
                    }
                    if let temp = json["redirect_uri"] as? String{
                        redirectURI = temp
                    }
                    if let temp = json["client_id"] as? String{
                        clientID = temp
                    }
                }
            }
        }
    }
    
    init() {
        self.readFromFile()
    }
}
