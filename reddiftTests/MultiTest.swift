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
    
    var initialMultiredditCount = 0
    
    var createdMultireddit:Multi? = nil
    var copiedMultireddit:Multi? = nil
    
    
    override func spec() {
        beforeEach { () -> () in
            self.createSession()
        }
        
        describe("Test Multireddit.") {
            it("Get a initial multireddit list.") {
                var r:Bool = false
                self.session?.getMineMulti({ (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        println(result.value!.description)
                        if let array:[Multi] = result.value {
                            self.initialMultiredditCount = array.count
                        }
                        r = true
                    }
                })
                expect(r).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
        
            it("Create a new multireddit.") {
                self.session?.createMulti("test", descriptionMd: "", completion: { (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        self.createdMultireddit = result.value
                    }
                })
                expect(self.createdMultireddit == nil).toEventually(equal(false), timeout: 10, pollInterval: 1)
            }
            
            it("Check count of multireddit after creating a new multireddit.") {
                var multiredditCountAfterCreating = 0
                self.session?.getMineMulti({ (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        println(result.value!.description)
                        if let array:[Multi] = result.value {
                            multiredditCountAfterCreating = array.count
                        }
                    }
                })
                expect(multiredditCountAfterCreating).toEventually(equal(self.initialMultiredditCount + 1), timeout: 10, pollInterval: 1)
            }
            
            it("Update the attribute of new multireddit, except subreddits.") {
                var r = false
                if let multi = self.createdMultireddit {
                    multi.iconName = .Science
                    multi.descriptionMd = "updated"
                    self.session?.updateMulti(multi, completion: { (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error!.description)
                        case let .Success:
                            println(result.value!)
                            
                            if let updatedMultireddit:Multi = result.value {
                                expect(updatedMultireddit.descriptionMd).to(equal("updated"))
                                expect(updatedMultireddit.iconName.rawValue).to(equal(MultiIconName.Science.rawValue))
                            }
                            r = true
                        }
                    })
                }
                expect(r).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
            
            it("Copy the created multireddit as copytest.") {
                var r = false
                if let multi = self.createdMultireddit {
                    self.session?.copyMulti(multi, newDisplayName: "copytest", completion:{ (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error!.description)
                        case let .Success:
                            if let multireddit:Multi = result.value {
                                self.copiedMultireddit = multireddit
                                println(self.copiedMultireddit)
                                r = true
                            }
                        }
                    })
                }
                expect(r).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
            
            it("Check count of multireddit after copying the created multireddit.") {
                var multiredditCountAfterCopingCreatedOne = 0
                self.session?.getMineMulti({ (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        println(result.value!.description)
                        if let array:[Multi] = result.value {
                            multiredditCountAfterCopingCreatedOne = array.count
                        }
                    }
                })
                expect(multiredditCountAfterCopingCreatedOne).toEventually(equal(self.initialMultiredditCount + 2), timeout: 10, pollInterval: 1)
            }
            
            it("Delete the copied multireddit.") {
                var r = false
                if let multi = self.copiedMultireddit {
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
            
            it("Delete the created multireddit.") {
                var r = false
                if let multi = self.createdMultireddit {
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
            
            it("Check count of multireddit after deleting the created multireddit.") {
                var multiredditCountAfterDeletingCreatedOne = 0
                self.session?.getMineMulti({ (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        println(result.value!.description)
                        if let array:[Multi] = result.value {
                            multiredditCountAfterDeletingCreatedOne = array.count
                        }
                    }
                })
                expect(multiredditCountAfterDeletingCreatedOne).toEventually(equal(self.initialMultiredditCount), timeout: 10, pollInterval: 1)
            }
        }
    }
}
