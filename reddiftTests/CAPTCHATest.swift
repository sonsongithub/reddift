//
//  CAPTCHATest.swift
//  reddift
//
//  Created by sonson on 2015/05/07.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import XCTest

class CAPTCHATest: UseSessionTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testNeedsCAPTCHA() {
        let documentOpenExpectation = self.expectationWithDescription("Test : Check needs CAPTCHA")
        session?.checkNeedsCAPTCHA({(result) -> Void in
            switch result {
            case let .Failure:
                XCTFail(result.error!.description)
            case let .Success:
                XCTAssert(result.value != nil, "Unexpected error.")
            }
            documentOpenExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(self.intervalForTimeout, handler: nil)
    }
    
    func testGetIdenCAPTCHA() {
        let documentOpenExpectation = self.expectationWithDescription("Test : Get Iden for CAPTCHA")
        session?.getIdenForNewCAPTCHA({ (result) -> Void in
            switch result {
            case let .Failure:
                XCTFail(result.error!.description)
            case let .Success:
                XCTAssert(result.value != nil, "Unexpected error.")
            }
            documentOpenExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(self.intervalForTimeout, handler: nil)
    }
    
    func testGetImageCAPTCHA() {
        let documentOpenExpectation = self.expectationWithDescription("Test : Get CAPTCHA Image")
        session?.getIdenForNewCAPTCHA({ (result) -> Void in
            switch result {
            case let .Failure:
                XCTFail(result.error!.description)
            case let .Success:
                if let string = result.value {
                    self.session?.getCAPTCHA(string, completion: { (result) -> Void in
                        switch result {
                        case let .Failure:
                            XCTFail(result.error!.description)
                        case let .Success:
                            if let image:CAPTCHAImage = result.value {
                                XCTAssert(image.size.width == 120, "CAPTCHA image does not have expected width.")
                                XCTAssert(image.size.height == 50, "CAPTCHA image does not have expected height.")
                            }
                            else {
                                XCTFail("Unexpected error")
                            }
                        }
                        documentOpenExpectation.fulfill()
                    })
                }
            }
        })
        self.waitForExpectationsWithTimeout(self.intervalForTimeout, handler: nil)
    }
}
