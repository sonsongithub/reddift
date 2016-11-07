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
     1. Get a breakdown of subreddit karma.
     */
    func testGettingBreakdownKarma() {
        do {
            let msg = "Get own karma."
            let documentOpenExpectation = self.expectation(description: msg)
            try self.session?.getKarma({ (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let users):
                    print(users)
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
    }

    /**
    Test procedure
    1. Get own trophies.
    */
    func testGettingOwnTrophies() {
        do {
            let msg = "Get own trophies."
            let documentOpenExpectation = self.expectation(description: msg)
            try self.session?.getTrophies({ (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let trophies):
                    print(trophies)
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
    }
    
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
        guard let _ = getPreference() else { XCTFail("Can not fetch preference."); return }
        
//        // Following test always fails.
//        // https://github.com/sonsongithub/reddift/issues/179
//        let defaultValue = preference.clickgadget ?? false
//        let setValue = !defaultValue
//
//        setPreference(Preference(clickgadget: setValue))
//        guard let afterPreference1 = getPreference() else { XCTFail("Can not fetch preference."); return }
//        XCTAssert(afterPreference1.clickgadget == setValue)
//
//        setPreference(Preference(clickgadget: defaultValue))
//        guard let afterPreference2 = getPreference() else { XCTFail("Can not fetch preference."); return }
//        XCTAssert(afterPreference2.clickgadget == defaultValue)
    }
    
//    // It does not test the following tests because there is not API to unblock the user by user ID(fullname)
//    // How can I write a test code......
//    func testBlocking() {
//        let messageFullname = "t4_4ezyp8"
//        do {
//            let msg = "Block."
//            let documentOpenExpectation = self.expectationWithDescription(msg)
//            try self.session?.blockViaInbox(messageFullname, completion: { (result) -> Void in
//                switch result {
//                case .Failure(let error):
//                    print(error)
//                case .Success(let users):
//                    print(users)
//                }
//                documentOpenExpectation.fulfill()
//            })
//            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
//        }
//        catch { XCTFail((error as NSError).description) }
//        
//        do {
//            let msg = "Get block list."
//            let documentOpenExpectation = self.expectationWithDescription(msg)
//            try self.session?.getBlocked(Paginator(), completion: { (result) -> Void in
//                switch result {
//                case .Failure(let error):
//                    print(error)
//                case .Success(let users):
//                    print(users)
//                }
//                documentOpenExpectation.fulfill()
//            })
//            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
//        }
//        catch { XCTFail((error as NSError).description) }
//        
//        do {
//            let msg = "Unblock."
//            let documentOpenExpectation = self.expectationWithDescription(msg)
//            try self.session?.unblockViaInbox("t2_mfsh8", completion: { (result) -> Void in
//                switch result {
//                case .Failure(let error):
//                    print(error)
//                case .Success(let users):
//                    print(users)
//                }
//                documentOpenExpectation.fulfill()
//            })
//            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
//        }
//        catch { XCTFail((error as NSError).description) }
//    }
}

extension AccountTest {
    /// Get own Preference
    func getPreference() -> Preference? {
        var preference: Preference? = nil
        let msg = "Get own preference"
        let documentOpenExpectation = self.expectation(description: msg)
        do {
            try self.session?.getPreference({ (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let value):
                    preference = value
                }
                XCTAssert(preference != nil, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
        return preference
    }
    
    /// Update own Preference with specified Preference object.
    func setPreference(_ preference: Preference) {
        let msg = "Patch preference"
        let documentOpenExpectation = self.expectation(description: msg)
        do {
            try self.session?.patchPreference(preference, completion: { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let value):
                    print(value)
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
    }
}
