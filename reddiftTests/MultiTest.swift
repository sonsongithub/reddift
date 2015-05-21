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
    var copiedMulti:Multi? = nil
    
    var initialList:[Multi] = []
    var secondList:[Multi] = []
    
    override func spec() {
        beforeEach { () -> () in
            self.createSession()
        }
        
        describe("Get Initial Multi list") {
            var r:Bool = false
            it("Fetched multi list into initialList") {
                self.session?.getMineMulti({ (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        println(result.value!.description)
                        if let array:[Multi] = result.value {
                            self.initialList += array
                        }
                        r = true
                    }
                })
                expect(r).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
        }
        
        describe("New Multi") {
            it("is created correctly") {
                self.session?.createMulti("test", descriptionMd: "", completion: { (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        self.newMulti = result.value
                    }
                })
                expect(self.newMulti == nil).toEventually(equal(false), timeout: 10, pollInterval: 1)
            }
        }
        
        describe("Get Second Multi list") {
            it("Fetched multi list into secondList, secondList must has one more Multi than initialList.") {
                var r:Bool = false
                self.session?.getMineMulti({ (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        println(result.value!.description)
                        if let array:[Multi] = result.value {
                            self.secondList += array
                        }
                        r = true
                    }
                })
                expect(r).toEventually(equal(true), timeout: 10, pollInterval: 1)
                expect(self.secondList.count).to(equal(self.initialList.count + 1))
            }
        }
        
        describe("Update Multi") {
            it("is updated correctly") {
                var r = false
                if let multi = self.newMulti {
                    multi.subreddits = ["swift"]
                    self.session?.updateMulti(multi, completion: { (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error!.description)
                        case let .Success:
                            println(result.value!)
                            r = true
                        }
                    })
                }
                expect(r).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
        }
        
        describe("Copy Multi") {
            it("is copied correctly") {
                var r = false
                if let multi = self.newMulti {
                    self.session?.copyMulti(multi, newDisplayName:"hoge", completion: { (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error!.description)
                        case let .Success:
                            self.copiedMulti = result.value
                            r = true
                        }
                    })
                }
                expect(self.copiedMulti != nil).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
        }
        
        describe("Delete added Multi") {
            it("is deleted correctly") {
                var r = false
                if let multi = self.newMulti {
                    self.session?.deleteMulti(multi, completion: { (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error!.description)
                        case let .Success:
                            println(result.value!)
                            r = true
                        }
                    })
                }
                expect(r).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
        }
        
        describe("Delete copied Multi") {
            it("is deleted correctly") {
                var r = false
                if let multi = self.copiedMulti {
                    self.session?.deleteMulti(multi, completion: { (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error!.description)
                        case let .Success:
                            println(result.value!)
                            r = true
                        }
                    })
                }
                expect(r).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
        }
        
//        describe("Get user's multi") {
//            it("Fetched current mine multi") {
//                var r:Bool = false
//                self.session?.getMineMulti({ (result) -> Void in
//                    switch result {
//                    case let .Failure:
//                        println(result.error!.description)
//                    case let .Success:
//                        println(result.value!.description)
//                        if let array:[Multi] = result.value {
//                            r = true
//                            self.multi += array
//                            expect(array.count).toEventually(equal(2), timeout: 10, pollInterval: 1)
//                        }
//                    }
//                })
//                expect(r).toEventually(equal(true), timeout: 10, pollInterval: 1)
//            }
//        }
//        
//        describe("Get Multi") {
//            it("Fetched specified multi") {
//                var r:Bool = false
//                self.session?.getNewList(Paginator(), subreddit:self.multi[0], completion: { (result) -> Void in
//                    switch result {
//                    case let .Failure:
//                        println(result.error!.description)
//                    case let .Success:
//                        println(result.value!.description)
////                        if let listing = result.value as? Listing {
////                            for obj in listing.children {
////                                if let link = obj as? Link {
////                                }
////                            }
////                            if let paginator = listing.paginator {
////                            }
////                        }
//                        r = true
//                    }
//                })
//                expect(r).toEventually(equal(true), timeout: 10, pollInterval: 1)
//            }
//        }
    }
}
