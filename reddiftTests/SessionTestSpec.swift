//
//  SessionTestSpec.swift
//  reddift
//
//  Created by sonson on 2015/05/08.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import Nimble
import Quick

class SessionTestSpec: QuickSpec {
    /// timeout duration for asynchronous test
    let timeoutDuration:NSTimeInterval = 30
    
    /// polling interval to check a value for asynchronous test
    let pollingInterval:NSTimeInterval = 1
    
    /// interval between tests for prevent test code from using API over limit rate.
    let testInterval:NSTimeInterval = 1
    
    /// shared session object
    var session:Session? = nil
    
    /// get token using application only oauth
    func createSession() {
        if let json = self.jsonFromFileName("test_config.json") as? [String:String] {
            if let username = json["username"],
                let password = json["password"],
                let clientID = json["client_id"],
                let secret = json["secret"] {
                    let documentOpenExpectation = self.expectationWithDescription("Test : Getting OAuth2 access token")
					OAuth2AppOnlyToken.getOAuth2AppOnlyToken(username: username, password: password, clientID: clientID, secret: secret, completion:( { (result) -> Void in
                        switch result {
                        case let .Failure:
                            XCTFail("Could not get access token from reddit.com.")
                        case let .Success:
                            if let token:OAuth2Token = result.value {
                                self.session = Session(token: token)
                            }
                            XCTAssert((self.session != nil), "Could not establish session.")
                        }
                        documentOpenExpectation.fulfill()
                    }))
                    self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
        }
    }
    override func spec() {
    }
}
