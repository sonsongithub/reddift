//
//  RDFOAuth2Authorizer.swift
//  reddift
//
//  Created by sonson on 2015/04/12.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class RDFOAuth2Authorizer {
	private var state:String = "";
	/**
	Singleton model.
	*/
	class var sharedInstance: RDFOAuth2Authorizer {
		struct Static {
			static var onceToken: dispatch_once_t = 0
			static var instance: RDFOAuth2Authorizer? = nil
		}
		dispatch_once(&Static.onceToken) {
			Static.instance = RDFOAuth2Authorizer()
		}
		return Static.instance!
	}
	
	func challengeWithAllScopes() {
		self.challengeWithScopes(["identity", "edit", "flair", "history", "modconfig", "modflair", "modlog", "modposts", "modwiki", "mysubreddits", "privatemessages", "read", "report", "save", "submit", "subscribe", "vote", "wikiedit", "wikiread"]);
	}
	
	func challengeWithScopes(scopes:[String]) {
		var scopeString:String = "";
		for scope in scopes {
			scopeString = scopeString + scope + ","
		}
		var range = Range<String.Index>(start: advance(scopeString.endIndex, -1), end: scopeString.endIndex);
		scopeString.removeRange(range);
		
		let length = 64;
		let mutableData = NSMutableData(length: Int(length))
		if let data = mutableData {
			let result = SecRandomCopyBytes(kSecRandomDefault, length, UnsafeMutablePointer<UInt8>(data.mutableBytes));
			self.state = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed);
			let authorizationURL:NSURL = NSURL(string:"https://www.reddit.com/api/v1/authorize.compact?client_id=" + RDFConfig.sharedInstance.clientID + "&response_type=code&state=" + self.state + "&redirect_uri=" + RDFConfig.sharedInstance.redirectURI + "&duration=permanent&scope=" + scopeString)!;
			UIApplication.sharedApplication().openURL(authorizationURL);
		}
	}
	
	func receiveRedirect(url:NSURL, completion:(token:RDFOAuth2Token?, error:NSError?)->Void) -> Bool{
		var code:String = "";
		var state:String = "";
		if (url.scheme == RDFConfig.sharedInstance.redirectURIScheme) {
			if let components:NSURLComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: true) {
				if let queryItems = components.queryItems as? [NSURLQueryItem] {
					for queryItem in queryItems {
						if (queryItem.name == "code") {
							if let temp = queryItem.value {
								code = temp;
							}
						}
						if (queryItem.name == "state") {
							if let temp = queryItem.value {
								state = temp;
							}
						}
					}
				}
			}
		}
		if (code != "" && state == self.state) {
			println(code);
			println(state);
			self.state = "";
			RDFOAuth2Token.download(code, completion:completion);
			return true;
		}
		return false;
	}
}
