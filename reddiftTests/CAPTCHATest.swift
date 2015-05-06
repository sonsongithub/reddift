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
                if let error = result.error {
                    XCTFail(error.description)
                }
                else {
                    XCTFail("Uexpected error")
                }
            case let .Success:
                if let needs:Bool = result.value {
                    XCTAssert((self.session != nil), "Could not establish session.")
                }
                else {
                    XCTFail("Error")
                }
            }
            documentOpenExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testGetIdenCAPTCHA() {
        let documentOpenExpectation = self.expectationWithDescription("Test : Get Iden for CAPTCHA")
        session?.getIdenForNewCAPTCHA({ (result) -> Void in
            switch result {
            case let .Failure:
                if let error = result.error {
                    XCTFail(error.description)
                }
                else {
                    XCTFail("Uexpected error")
                }
            case let .Success:
                println(result.value)
            }
            documentOpenExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testGetImageCAPTCHA() {
        let documentOpenExpectation = self.expectationWithDescription("Test : Get CAPTCHA Image")
        session?.getIdenForNewCAPTCHA({ (result) -> Void in
            switch result {
            case let .Failure:
                if let error = result.error {
                    XCTFail(error.description)
                }
                else {
                    XCTFail("Uexpected error")
                }
            case let .Success:
                println(result.value)
                if let string = result.value {
                    self.session?.getCAPTCHA(string, completion: { (result) -> Void in
                        switch result {
                        case let .Failure:
                            if let error = result.error {
                                XCTFail(error.description)
                            }
                            else {
                                XCTFail("Uexpected error")
                            }
                        case let .Success:
                            if let image = result.value {
                                println(image)
                            }
                            else {
                                XCTFail("Uexpected error")
                            }
                        }
                    })
                }

            }
            documentOpenExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
}
