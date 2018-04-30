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
    func checkAllElementsIncludedIn<T: Equatable>(_ array: [T]) -> Bool {
        var result = true
        for obj in self {
            if let obj = obj as? T {
                result = result && (array.index(of: obj) != nil)
            }
        }
        return result
    }
    
    /// check whether self is equal to argument.
    func hasSameElements<T: Equatable>(_ array: [T]) -> Bool {
        if self.count != array.count {
            return false
        }
        return self.checkAllElementsIncludedIn(array)
    }
}

class SessionTestSpec: XCTestCase {
    /// timeout duration for asynchronous test
    let timeoutDuration: TimeInterval = 30
    
    /// polling interval to check a value for asynchronous test
    let pollingInterval: TimeInterval = 1
    
    /// interval between tests for prevent test code from using API over limit rate.
    var testInterval: TimeInterval = 5
    
    /// shared session object
    var session: Session?
    
    override func setUp() {
        super.setUp()
        self.createSession()
    }
    
    override func tearDown() {
        super.tearDown()
        Thread.sleep(forTimeInterval: self.testInterval)
    }
    
    /// get token using application only oauth
    func createSession() {
        if let json = self.jsonFromFileName("test_config.json") as? [String: String] {
            if let username = json["username"],
                let password = json["password"],
                let clientID = json["client_id"],
                let secret = json["secret"] {
                    let documentOpenExpectation = self.expectation(description: "Test : Getting OAuth2 access token")
                    do {
                        try OAuth2AppOnlyToken.getOAuth2AppOnlyToken(username: username, password: password, clientID: clientID, secret: secret, completion: ({ (result) -> Void in
                            switch result {
                            case .failure:
                                XCTFail("Could not get access token from reddit.com.")
                            case .success:
                                if let token = result.value {
                                    self.session = Session(token: token)
                                }
                                XCTAssert((self.session != nil), "Could not establish session.")
                            }
                            documentOpenExpectation.fulfill()
                        }))
                        self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
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
        var isSucceeded = false
        let documentOpenExpectation = self.expectation(description: msg)
        do {
            try self.session?.getFriends(completion: { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let users):
                    list.append(contentsOf: users)
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
        return list
    }
    
    /// Friend specified user
    func makeFriend(_ username: String, note: String) {
        let msg = "Make \(username) friend."
        var isSucceeded = false
        let documentOpenExpectation = self.expectation(description: msg)
        do {
            try self.session?.friend(username, note: note, completion: { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let json):
                    print(json)
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
    }
    
    /// Unfriend specified user
    func makeUnfriend(_ username: String) {
        do {
            let msg = "Make \(username) unfriend."
            var isSucceeded = false
            let documentOpenExpectation = self.expectation(description: msg)
            do {
                try self.session?.unfriend(username, completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success:
//                        print(json)
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
            } catch { XCTFail((error as NSError).description) }
        }
    }
}
