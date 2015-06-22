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
#if os(iOS)
import UIKit
#endif

class CAPTCHATest: SessionTestSpec {
    override func spec() {
        beforeEach { () -> () in
            self.createSession()
        }
        
        describe("CAPTCHA") {
            describe("Needs API response") {
                it("is true or false as Bool") {
                    var check_result:Bool? = nil
                    self.session?.checkNeedsCAPTCHA({(result) -> Void in
                        switch result {
                        case .Failure(let error):
                            print(error)
                        case .Success(let check):
                            check_result = check
                        }
                        NSThread.sleepForTimeInterval(self.testInterval)
                    })
                    expect(check_result).toEventuallyNot(equal(nil), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
                }
            }
            
            describe("Iden for new CAPTCHA") {
                it("is String") {
                    var iden:String? = nil
                    self.session?.getIdenForNewCAPTCHA({ (result) -> Void in
                        switch result {
                        case .Failure(let error):
                            print(error.description)
                        case .Success(let identifier):
                            iden = identifier
                        }
                        NSThread.sleepForTimeInterval(self.testInterval)
                    })
                    expect(iden).toEventuallyNot(equal(nil), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
                }
            }
            
            describe("The size of new image generated using Iden") {
                it("is 120x50") {
                #if os(iOS)
                    var size:CGSize? = nil
                #elseif os(OSX)
                    var size:NSSize? = nil
                #endif
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
                            })
                        }
                        NSThread.sleepForTimeInterval(self.testInterval)
                    })
                    expect(size).toEventuallyNot(equal(nil), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
                    if let size = size {
                    #if os(iOS)
                        expect(size).toEventually(equal(CGSize(width: 120, height: 50)), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
                    #elseif os(OSX)
                        expect(size).toEventually(equal(NSSize(width: 120, height: 50)), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
                    #endif
                    }
                }
            }
        }
    }
}