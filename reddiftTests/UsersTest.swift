//
//  UsersTest.swift
//  reddift
//
//  Created by sonson on 2015/06/01.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import XCTest

class UsersTest: SessionTestSpec {
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
}
