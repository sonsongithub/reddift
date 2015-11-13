//
//  AccountTest.swift
//  reddift
//
//  Created by sonson on 2015/11/13.
//  Copyright © 2015年 sonson. All rights reserved.
//

import XCTest

class AccountTest: SessionTestSpec {
    func testGetPreference() {
        guard var preference = getPreference() else { XCTFail("Can not fetch preference."); return }
        
        let patch = Preference(clickgadget: false)
        
        let msg = "Patch preference"
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.patchPreference(patch, completion: { (result) -> Void in
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

extension AccountTest {
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
}