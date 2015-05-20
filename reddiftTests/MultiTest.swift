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
    var multi:[Multi] = []
    var newMulti:Multi? = nil
    
    override func spec() {
        beforeEach { () -> () in
            self.createSession()
        }
        
//        describe("New Multi") {
//            it("is created correctly") {
//                self.session?.createMulti("testest2", descriptionMd: "", completion: { (result) -> Void in
//                    switch result {
//                    case let .Failure:
//                        println(result.error!.description)
//                    case let .Success:
//                        self.newMulti = result.value
//                    }
//                })
//                expect(self.newMulti == nil).toEventually(equal(false), timeout: 10, pollInterval: 1)
//            }
//        }
        
        describe("Update Multi") {
            it("is updated correctly") {
                var r = false
//                if let multi = self.newMulti {
//                    multi.subreddits = ["swift"]
                    self.session?.updateMulti(nil, completion: { (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error!.description)
                        case let .Success:
                            println(result.value!)
                            r = true
                        }
                    })
//                }
                expect(r).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
        }
        
        describe("Get user's multi") {
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
                            self.multi += array
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
                self.session?.getNewList(Paginator(), subreddit:self.multi[0], completion: { (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        println(result.value!.description)
                        if let listing = result.value as? Listing {
                            for obj in listing.children {
                                if let link = obj as? Link {
                                }
                            }
                            if let paginator = listing.paginator {
                            }
                        }
                        r = true
                    }
                })
                expect(r).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
        }
    }
}
