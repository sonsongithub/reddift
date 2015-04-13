//
//  RDFConfig.swift
//  reddift
//
//  Created by sonson on 2015/04/13.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

/**
Class to manage parameters of reddift.
This class is used as singleton model
*/
class RDFConfig {
	var version:String = "";
	var bundleIdentifier:String = "";
	var developerName:String = "";
	var redirectURI:String = "";
	var clientID:String = "";
	
	/**
	Singleton model.
	*/
	class var sharedInstance: RDFConfig {
		struct Static {
			static var onceToken: dispatch_once_t = 0
			static var instance: RDFConfig? = nil
		}
		dispatch_once(&Static.onceToken) {
			Static.instance = RDFConfig()
		}
		return Static.instance!
	}
	
	/**
	Returns User-Agent for API
	*/
	var userAgent:String {
		get {
			return "ios:" + self.bundleIdentifier + ":v" + self.version + "(by /u/" + self.developerName + ")";
		}
	}
	
	/**
	Returns scheme of redirect URI.
	*/
	var redirectURIScheme:String {
		get {
			if let scheme:String = NSURL(string: self.redirectURI)?.scheme as String? {
				return scheme;
			}
			else {
				return "";
			}
		}
	}
	
	/**
	Read from info.plist and RDFConfig.json file.
	*/
	func readFromFile() {
		if let temp = NSBundle.infoValueFromMainBundleForKey("CFBundleShortVersionString") as? String{
			self.version = temp;
		}
		if let temp = NSBundle.infoValueFromMainBundleForKey("CFBundleIdentifier") as? String{
			self.bundleIdentifier = temp;
		}
		if let path:String = NSBundle.mainBundle().pathForResource("RDFConfig", ofType: "json") as String? {
			if let data:NSData = NSData(contentsOfFile: path) {
				if let json:[String:AnyObject] = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
					if let temp = json["DeveloperName"] as? String{
						self.developerName = temp;
					}
					if let temp = json["redirect_uri"] as? String{
						self.redirectURI = temp;
					}
					if let temp = json["client_id"] as? String{
						self.clientID = temp;
					}
				}
			}
		}
	}
	
	init() {
		self.readFromFile();
	}
}
