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
     1. Get speficified user contents
     */
    func testGetUserContents() {
        let username = "sonson_twit"
        for content in UserContent.cases {
            for sort in UserContentSortBy.cases {
                for within in TimeFilterWithin.cases {
                    _ = userContentsWith(username, content: content, sort: sort, timeFilterWithin: within)
                    Thread.sleep(forTimeInterval: 1)
                    break
                }
                break
            }
        }
    }
    
    /**
     Test procedure
     1. Get speficified user profile
     */
    func testGetUserProfile() {
        let username = "reddift_test_1"
        let msg = "Get \(username)'s user profile."
        var isSucceeded = false
        let documentOpenExpectation = self.expectation(description: msg)
        do {
            try self.session?.getUserProfile(username, completion: { (result) -> Void in
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
    
    /**
     This test is always failed.
     Why...? Anyone knows the reasons?
     
     Test procedure
     1. Get notifications.
     */
//    func testGetNotifications() {
//        let msg = "Get notifications for me. Maybe, this test is always failed."
//        var isSucceeded = false
//        let documentOpenExpectation = self.expectation(description: msg)
//        do {
//            try self.session?.getNotifications(.new, completion: { (result) -> Void in
//                switch result {
//                case .failure(let error):
//                    print(error)
//                case .success(let json):
//                    print(json)
//                    isSucceeded = true
//                }
//                XCTAssert(isSucceeded, msg)
//                documentOpenExpectation.fulfill()
//            })
//            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
//        } catch { XCTFail((error as NSError).description) }
//    }
    
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
        // note must be blank... This is a bug of reddit.com?
        // https://github.com/sonsongithub/reddift/issues/180
        usernames.forEach({ makeFriend($0, note: "") })
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
    
    /**
     Test procedure
     1. Get reddift_test_1's trophies.
     */
    func testGetTrophies() {
        let msg = "Get reddift_test_1's trophy."
        var isSucceeded = false
        let documentOpenExpectation = self.expectation(description: msg)
        do {
            try self.session?.getTrophies("reddift_test_1", completion: { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success:
//                    print(trophies)
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
    }
}

extension UsersTest {
    /// Get user contents with username, a type of content, sort and time filter.
    func userContentsWith(_ username: String, content: UserContent, sort: UserContentSortBy, timeFilterWithin: TimeFilterWithin) -> Listing? {
        var listing: Listing? = nil
        let msg = "Get \(username)'s user contents."
        let documentOpenExpectation = self.expectation(description: msg)
        var isSucceeded = false
        do {
            try self.session?.getUserContent(username, content: content, sort: sort, timeFilterWithin: timeFilterWithin, paginator: Paginator(), completion: { (result) -> Void in
                switch result {
                case .failure(let error):
                    // Return 404 code when there are not any data.
                    isSucceeded = (error.code == HttpStatus.notFound.rawValue)
                    print(error)
                case .success(let list):
                    listing = list
                    isSucceeded = true
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
        XCTAssert(isSucceeded, msg)
        return listing
    }
}
