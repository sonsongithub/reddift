//
//  MultiTest.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Nimble
import Quick

class MultiTest: SessionTestSpec {
    override func spec() {
        beforeEach { () -> () in
            self.createSession()
        }
        describe("Get mine") {
            it("Fetched current mine multi") {
                var r:Bool = false
                self.session?.getMineMulti({ (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        println(result.value!.description)
                        if let array:[Multi] = result.value {
                            r = true
                            expect(array.count).toEventually(equal(2), timeout: 10, pollInterval: 1)
                        }
                    }
                })
                expect(r).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
        }
        
        describe("Get Multi") {
            it("Fetched specified multi") {
                var r:Bool = false
                self.session?.getMulti("//user/sonson_twit/m/mine", completion: { (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        println(result.value!.description)
                    }
                })
                expect(r).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
        }
    }
}
