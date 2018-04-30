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

class CAPTCHATest: SessionTestSpec {

    // now, CAPTCHA API does not work.....?
//    func testCheckWhetherCAPTCHAIsNeededOrNot() {
//        let msg = "is true or false as Bool"
//        print(msg)
//        var check_result: Bool? = nil
//        let documentOpenExpectation = self.expectation(description: msg)
//        do {
//            try self.session?.checkNeedsCAPTCHA({(result) -> Void in
//                switch result {
//                case .failure(let error):
//                    print(error)
//                case .success(let check):
//                    check_result = check
//                }
//                XCTAssert(check_result != nil, msg)
//                documentOpenExpectation.fulfill()
//            })
//        } catch { XCTFail((error as NSError).description) }
//        self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
//    }
    
    // now, CAPTCHA API does not work.....?
//    func testGetIdenForNewCAPTCHA() {
//        let msg = "is String"
//        print(msg)
//        var iden: String? = nil
//        let documentOpenExpectation = self.expectation(description: msg)
//        do {
//            try self.session?.getIdenForNewCAPTCHA({ (result) -> Void in
//                switch result {
//                case .failure(let error):
//                    print(error.description)
//                case .success(let identifier):
//                    iden = identifier
//                }
//                XCTAssert(iden != nil, msg)
//                documentOpenExpectation.fulfill()
//            })
//        } catch { XCTFail((error as NSError).description) }
//        self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
//    }
    
    // now, CAPTCHA API does not work.....?
//    func testSizeOfNewImageGeneratedUsingIden() {
//        let msg = "is 120x50" 
//        print(msg)
//#if os(iOS) || os(tvOS)
//        var size: CGSize? = nil
//#elseif os(macOS)
//        var size: NSSize? = nil
//#endif
//        let documentOpenExpectation = self.expectation(description: msg)
//        do {
//            try self.session?.getIdenForNewCAPTCHA({ (result) -> Void in
//                switch result {
//                case .failure(let error):
//                    print(error.description)
//                case .success(let string):
//                    try! self.session?.getCAPTCHA(string, completion: { (result) -> Void in
//                        switch result {
//                        case .failure(let error):
//                            print(error.description)
//                        case .success(let image):
//                            size = image.size
//                        }
//                        documentOpenExpectation.fulfill()
//                    })
//                }
//            })
//        } catch { XCTFail((error as NSError).description) }
//        self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
//        
//        if let size = size {
//#if os(iOS)
//            XCTAssert(size == CGSize(width: 120, height: 50), msg)
//#elseif os(macOS)
//            XCTAssert(size == NSSize(width: 120, height: 50), msg)
//#endif
//        } else {
//            XCTFail(msg)
//        }
//    }
    
}
