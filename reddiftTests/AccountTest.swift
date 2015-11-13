//
//  AccountTest.swift
//  reddift
//
//  Created by sonson on 2015/11/13.
//  Copyright © 2015年 sonson. All rights reserved.
//

import XCTest

class AccountTest: SessionTestSpec {
    /**
     Test procedure
     1. Get current preference.
     2. Save clickgadget value.
     3. Change clickgadget value.
     4. Check whether clickgadget value has been changed.
     5. Change clickgadget value.
     6. Check whether clickgadget value has been restored to default value.
     */
    func testGetAndSetPreference() {
        guard let preference = getPreference() else { XCTFail("Can not fetch preference."); return }
        
        let defaultValue = preference.clickgadget ?? false
        let setValue = !defaultValue
        
        setPreference(Preference(clickgadget: setValue))
        guard let afterPreference1 = getPreference() else { XCTFail("Can not fetch preference."); return }
        XCTAssert(afterPreference1.clickgadget == setValue)
        
        setPreference(Preference(clickgadget: defaultValue))
        guard let afterPreference2 = getPreference() else { XCTFail("Can not fetch preference."); return }
        XCTAssert(afterPreference2.clickgadget == defaultValue)
    }

    func testBlocking() {
        
        do {
            let msg = "Block."
            let documentOpenExpectation = self.expectationWithDescription(msg)
            try self.session?.blockViaInbox("swift", completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error)
                case .Success(let users):
                    print(users)
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        
        do {
            let msg = "Get block list."
            let documentOpenExpectation = self.expectationWithDescription(msg)
            try self.session?.getBlocked(Paginator(), completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error)
                case .Success(let users):
                    print(users)
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        
        do {
            let msg = "Unblock."
            let documentOpenExpectation = self.expectationWithDescription(msg)
            try self.session?.unblockViaInbox("reddift_test_2", completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error)
                case .Success(let users):
                    print(users)
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        
    }
    
    func testGetFriends() {
        let username1 = "reddift_test_1"
        let username2 = "reddift_test_2"
        
        friends()
        
        makeFriend(username1)
        makeFriend(username2)
        
        friends()
        
        
        let msg = "Get friends list."
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.getFriends(completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error)
                case .Success(let users):
                    print(users)
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        
        
        makeUnfriend(username1)
        makeUnfriend(username2)
    }
}

extension AccountTest {
    /// Get own Preference
    func getPreference() -> Preference? {
        var preference:Preference? = nil
        let msg = "Get own preference"
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.getPreference({ (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error)
                case .Success(let value):
                    preference = value
                }
                XCTAssert(preference != nil, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        return preference
    }
    
    /// Update own Preference with specified Preference object.
    func setPreference(preference:Preference) {
        let msg = "Patch preference"
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.patchPreference(preference, completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error)
                case .Success(let value):
                    print(value)
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
    }
}