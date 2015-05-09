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
    var session:Session? = nil
    func createSession() {
        if let json = self.jsonFromFileName("test_config.json") as? [String:String] {
            if let username = json["username"],
                let password = json["password"],
                let clientID = json["client_id"],
                let secret = json["secret"] {
                    let documentOpenExpectation = self.expectationWithDescription("Test : Getting OAuth2 access token")
                    OAuth2AppOnlyToken.getOAuth2AppOnlyToken(username: username, password: password, clientID: clientID, secret: secret) { (result) -> Void in
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
                    }
                    self.waitForExpectationsWithTimeout(10, handler: nil)
            }
        }
    }
    override func spec() {
    }
}
