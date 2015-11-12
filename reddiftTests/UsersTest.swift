//
//  UsersTest.swift
//  reddift
//
//  Created by sonson on 2015/06/01.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import XCTest

extension UsersTest {
    func friends() -> [User] {
        var list:[User] = []
        let msg = "Get friends list."
        var isSucceeded:Bool = false
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.getFriend(completion: { (result) -> Void in
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
        }
        catch { XCTFail((error as NSError).description) }
        return list
    }
    
    func makeFriend(username:String) {
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
    }
    
    func makeUnfriend(username:String) {
        do {
            let msg = "Make \(username) unfriend."
            var isSucceeded:Bool = false
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
            }
            catch { XCTFail((error as NSError).description) }
        }
    }
}

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
     1. Save friend list to initialFriends.
     2. Make reddift_test_1 friend.
     3. Make reddift_test_2 friend.
     4. Save friend list to intermediateFriends.
     5. Make reddift_test_1 unfriend.
     6. Save friend list to intermediateFriends2.
     7. Make reddift_test_2 unfriend.
     8. Save friend list to finalFriends.
     9. Compare initialFriends and intermediateFriends.
     10. Compare initialFriends and intermediateFriends2.
     11. Confirm initialFriends is equal to finalFriends.
     */
    func testMakeItFriendAndUnfriend() {
        let username1 = "reddift_test_1"
        let username2 = "reddift_test_2"
        let usernames = [username1, username2]
        
        // 1.
        let initialFriends = friends()
        // 2-3
        usernames.forEach({ makeFriend($0) })
        // 4
        let intermediateFriends = friends()
        // 5
        makeUnfriend(usernames[0])
        // 6
        let intermediateFriends2 = friends()
        // 7
        makeUnfriend(usernames[1])
        // 8
        let finalFriends = friends()
        
        // Create friends' name list for test.
        let initialFriendsNames = initialFriends.map({$0.name})
        let intermediateFriendsNames = intermediateFriends.map({$0.name})
        let intermediateFriendsNames2 = intermediateFriends2.map({$0.name})
        let finalFriendsNames = finalFriends.map({$0.name})
        
        // 9
        XCTAssert(intermediateFriendsNames.hasSameElements(initialFriendsNames + usernames))
        // 10
        XCTAssert(intermediateFriendsNames2.hasSameElements(initialFriendsNames + [username2]))
        // 11
        XCTAssert(finalFriendsNames.hasSameElements(initialFriendsNames))
    }
}
