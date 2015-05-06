//
//  OAuth2AppOnlyTokenTest.swift
//  reddift
//
//  Created by sonson on 2015/05/05.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import XCTest

class OAuth2AppOnlyTokenTest: XCTestCase {
    var username = ""
    var password = ""
    var clientID = ""
    var secret   = ""

    override func setUp() {
        super.setUp()
        if let json = self.jsonFromFileName("test_config.json") as? [String:String] {
            if let username = json["username"],
                let password = json["password"],
                let clientID = json["client_id"],
                let secret = json["secret"] {
                    self.username = username
                    self.password = password
                    self.clientID = clientID
                    self.secret = secret
                    return
            }
        }
        XCTFail("Could not load test_config.json.")
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testGetOAuth2AccessTokenAppOnly() {
        let documentOpenExpectation = self.expectationWithDescription("Test : Getting OAuth2 access token")
        OAuth2AppOnlyToken.getOAuth2AppOnlyToken(username: username, password: password, clientID: clientID, secret: secret) { (result) -> Void in
            switch result {
            case let .Failure:
                XCTFail("Could not get access token from reddit.com.")
            case let .Success:
                println(result.value)
                XCTAssertTrue(true, "A")
            }
            documentOpenExpectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
}
