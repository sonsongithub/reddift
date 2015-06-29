//
//  CAPTCHATest.swift
//  reddift
//
//  Created by sonson on 2015/05/07.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import XCTest

#if os(iOS)
    import UIKit
#endif

class CAPTCHATest: SessionTestSpec2 {

    func testCheckWhetherCAPTCHAIsNeededOrNot() {
        let msg = "is true or false as Bool"
        print(msg)
        var check_result:Bool? = nil
        let documentOpenExpectation = self.expectationWithDescription(msg)
        self.session?.checkNeedsCAPTCHA({(result) -> Void in
            switch result {
            case .Failure(let error):
                print(error)
            case .Success(let check):
                check_result = check
            }
            XCTAssert(check_result != nil, msg)
            documentOpenExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
    }
    
    func testGetIdenForNewCAPTCHA() {
        let msg = "is String"
        print(msg)
        var iden:String? = nil
        let documentOpenExpectation = self.expectationWithDescription(msg)
        self.session?.getIdenForNewCAPTCHA({ (result) -> Void in
            switch result {
            case .Failure(let error):
                print(error.description)
            case .Success(let identifier):
                iden = identifier
            }
            XCTAssert(iden != nil, msg)
            documentOpenExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
    }
    
    func testSizeOfNewImageGeneratedUsingIden() {
        let msg = "is 120x50"
        print(msg)
#if os(iOS)
        var size:CGSize? = nil
#elseif os(OSX)
        var size:NSSize? = nil
#endif
        let documentOpenExpectation = self.expectationWithDescription(msg)
        self.session?.getIdenForNewCAPTCHA({ (result) -> Void in
            switch result {
            case .Failure(let error):
                print(error.description)
            case .Success(let string):
                self.session?.getCAPTCHA(string, completion: { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error.description)
                    case .Success(let image):
                        size = image.size
                    }
                    documentOpenExpectation.fulfill()
                })
            }
        })
        self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        
        if let size = size {
#if os(iOS)
            XCTAssert(size == CGSize(width: 120, height: 50), msg)
#elseif os(OSX)
            XCTAssert(size == NSSize(width: 120, height: 50), msg)
#endif
        }
        else {
            XCTFail(msg)
        }
    }
    
}