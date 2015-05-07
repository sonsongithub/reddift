//
//  CAPTCHATest.swift
//  reddift
//
//  Created by sonson on 2015/05/07.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import Nimble
import Quick

class CAPTCHATest: SessionTestSpec {
    override func spec() {
        beforeEach { () -> () in
            self.createSession()
        }
        
        describe("CAPTCHA") {
            describe("Needs API response") {
                it("is true or false as Bool") {
                    let documentOpenExpectation = self.expectationWithDescription("")
                    self.session?.checkNeedsCAPTCHA({(result) -> Void in
                        switch result {
                        case let .Failure:
                            XCTFail(result.error!.description)
                        case let .Success:
                            XCTAssert(result.value != nil, "Unexpected error.")
                        }
                        documentOpenExpectation.fulfill()
                    })
                    self.waitForExpectationsWithTimeout(10, handler: nil)
                }
            }
            
            describe("Iden for new CAPTCHA") {
                it("is String") {
                    let documentOpenExpectation = self.expectationWithDescription("")
                    self.session?.getIdenForNewCAPTCHA({ (result) -> Void in
                        switch result {
                        case let .Failure:
                            XCTFail(result.error!.description)
                        case let .Success:
                            XCTAssert(result.value != nil, "Unexpected error.")
                            if let iden = result.value {
                                XCTAssert(iden is String, "Unexpected error.")
                            }
                        }
                        documentOpenExpectation.fulfill()
                    })
                    self.waitForExpectationsWithTimeout(10, handler: nil)
                }
            }
            
            describe("The size of new image generated using Iden") {
                it("is 120x50") {
                    let documentOpenExpectation = self.expectationWithDescription("")
                    self.session?.getIdenForNewCAPTCHA({ (result) -> Void in
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
                    self.waitForExpectationsWithTimeout(10, handler: nil)
                }
            }
        }
    }
}