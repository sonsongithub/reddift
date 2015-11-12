//
//  UsersTest.swift
//  reddift
//
//  Created by sonson on 2015/06/01.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import XCTest

class UsersTest: SessionTestSpec {
    
    /**
     Test procedure
     1. Get notifications.
     */
    func testGetNotifications() {
        let msg = "Get notifications for me."
        var isSucceeded:Bool = false
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.getNotifications(.New, completion: { (result) -> Void in
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
        }
        catch { XCTFail((error as NSError).description) }
    }
    
    /**
     Test procedure
     1. Make reddift_test_1 friend.
     2. Make reddift_test_1 unfriend.
     */
    func testMakeItFriendAndUnfriend() {
        let username = "reddift_test_1"
        let msg = "Make \(username) friend."
        var isSucceeded:Bool = false
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.friend(username, note: "", completion: { (result) -> Void in
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
        }
        catch { XCTFail((error as NSError).description) }
        
        do {
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.friend(username, note: "aaa", completion: { (result) -> Void in
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
        }
        catch { XCTFail((error as NSError).description) }
        }
        
        do {
            let msg = "Make \(username) unfriend."
            var isSucceeded:Bool = false
            let documentOpenExpectation = self.expectationWithDescription(msg)
            do {
                try self.session?.unfriend("reddift_test_1", completion: { (result) -> Void in
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
            }
            catch { XCTFail((error as NSError).description) }
        }
    }
}
