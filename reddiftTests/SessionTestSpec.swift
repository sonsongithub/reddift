//
//  SessionTestSpec.swift
//  reddift
//
//  Created by sonson on 2015/05/08.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import XCTest

/// following extension for test only
extension Array {
    /// check whether argument includes elements in self.
    func checkAllElementsIncludedIn<T: Equatable>(array: [T]) -> Bool {
        var result = true
        for obj in self {
            result = result && (array.indexOf(obj as! T) != nil)
        }
        return result
    }
    
    /// check whether self is equal to argument.
    func hasSameElements<T: Equatable>(array: [T]) -> Bool {
        if self.count != array.count {
            return false
        }
        return self.checkAllElementsIncludedIn(array)
    }
}

class SessionTestSpec: XCTestCase {
    /// timeout duration for asynchronous test
    let timeoutDuration: NSTimeInterval = 30
    
    /// polling interval to check a value for asynchronous test
    let pollingInterval: NSTimeInterval = 1
    
    /// interval between tests for prevent test code from using API over limit rate.
    let testInterval: NSTimeInterval = 5
    
    /// shared session object
    var session: Session? = nil
    
    override func setUp() {
        super.setUp()
        self.createSession()
    }
    
    override func tearDown() {
        super.tearDown()
        NSThread.sleepForTimeInterval(self.testInterval)
    }
    
    /// get token using application only oauth
    func createSession() {
        if let json = self.jsonFromFileName("test_config.json") as? [String:String] {
            if let username = json["username"],
                let password = json["password"],
                let clientID = json["client_id"],
                let secret = json["secret"] {
                    let documentOpenExpectation = self.expectationWithDescription("Test : Getting OAuth2 access token")
                    do {
                        try OAuth2AppOnlyToken.getOAuth2AppOnlyToken(username: username, password: password, clientID: clientID, secret: secret, completion:({ (result) -> Void in
                            switch result {
                            case .Failure:
                                XCTFail("Could not get access token from reddit.com.")
                            case .Success:
                                if let token: Token = result.value {
                                    self.session = Session(token: token)
                                }
                                XCTAssert((self.session != nil), "Could not establish session.")
                            }
                            documentOpenExpectation.fulfill()
                        }))
                        self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
                    } catch { print(error) }
            }
        }
    }
}

extension SessionTestSpec {
    /// Get friends
    func friends() -> [User] {
        var list: [User] = []
        let msg = "Get friends list."
        var isSucceeded: Bool = false
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.getFriends(completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error)
                case .Success(let users):
                    list.appendContentsOf(users)
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
        return list
    }
    
    /// Friend specified user
    func makeFriend(username: String, note: String) {
        let msg = "Make \(username) friend."
        var isSucceeded: Bool = false
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.friend(username, note: note, completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error)
                case .Success(let json):
                    print(json)
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
    }
    
    /// Unfriend specified user
    func makeUnfriend(username: String) {
        do {
            let msg = "Make \(username) unfriend."
            var isSucceeded: Bool = false
            let documentOpenExpectation = self.expectationWithDescription(msg)
            do {
                try self.session?.unfriend(username, completion: { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error)
                    case .Success(let json):
                        print(json)
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            } catch { XCTFail((error as NSError).description) }
        }
    }
}
