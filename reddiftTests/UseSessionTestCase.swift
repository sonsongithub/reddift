//
//  UseSessionTestCase.swift
//  reddift
//
//  Created by sonson on 2015/05/07.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import XCTest

class UseSessionTestCase: XCTestCase {
    var session:Session! = nil

    override func setUp() {
        super.setUp()
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
                            println(result.value)
                            if let token:OAuth2Token = result.value {
                                self.session = Session(token: token)
                            }
                        }
                        documentOpenExpectation.fulfill()
                    }
                    self.waitForExpectationsWithTimeout(10, handler: nil)
                    XCTAssert((self.session != nil), "Could not establish session.")
                    return
            }
        }
        XCTFail("Could not load test_config.json.")
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
