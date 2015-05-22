//
//  MultiTest.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Nimble
import Quick

class MultiredditTest: SessionTestSpec {
    
    var initialMultiredditCount = 0
    
    var createdMultireddit:Multireddit? = nil
    var copiedMultireddit:Multireddit? = nil
    
    let targetSubreddits = ["swift", "redditdev"]
    
    func testAddSubredditToMultireddit(subredditDisplayName:String) {
        let subreddit = Subreddit()
        var addedDisplayName:String? = nil
        if let multi = self.createdMultireddit {
            self.session?.addSubredditToMultireddit(multi, subredditDisplayName:subredditDisplayName, completion:{ (result) -> Void in
                switch result {
                case let .Failure:
                    println(result.error!.description)
                case let .Success:
                    addedDisplayName = result.value
                }
            })
        }
        expect(addedDisplayName).toEventually(equal(subredditDisplayName), timeout: 10, pollInterval: 1)
    }
    
    func check(result:Result<JSON>, targetSubreddits:[String]) -> Bool {
        var isSucceeded = false
        switch result {
        case let .Failure:
            println(result.error!.description)
        case let .Success:
            isSucceeded = true
            if let listing:Listing = result.value as? Listing {
                for obj in listing.children {
                    if let link:Link = obj as? Link {
                        var flag = false
                        for subreddit in targetSubreddits {
                            if link.subreddit != subreddit {
                                flag = true
                            }
                        }
                        if !flag {
                            isSucceeded = false
                        }
                    }
                }
            }
        }
        return isSucceeded
    }
    
    override func spec() {
        beforeEach { () -> () in
            self.createSession()
        }
        
        describe("Test Multireddit.") {
            it("Get a initial multireddit list.") {
                var isSucceeded:Bool = false
                self.session?.getMineMultireddit({ (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        if let array:[Multireddit] = result.value {
                            self.initialMultiredditCount = array.count
                        }
                        isSucceeded = true
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
        
            it("Create a new multireddit.") {
                self.session?.createMultireddit("test", descriptionMd: "", completion: { (result) -> Void in
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
                self.session?.getMineMultireddit({ (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        if let array:[Multireddit] = result.value {
                            multiredditCountAfterCreating = array.count
                        }
                    }
                })
                expect(multiredditCountAfterCreating).toEventually(equal(self.initialMultiredditCount + 1), timeout: 10, pollInterval: 1)
            }
            
            it("Add subreddits, swift and redditdev, to the new multireddit") {
                for subreddit in self.targetSubreddits {
                    self.testAddSubredditToMultireddit(subreddit)
                }
            }
            
            it("Check whether the multireddit does inlcude only swift and redditdev articles, Controversial") {
                var isSucceeded = false
                if let multi = self.createdMultireddit {
                    self.session?.getList(Paginator(), subreddit: multi, integratedSort:.Controversial, timeFilterWithin: TimeFilterWithin.Week, completion: { (result) -> Void in
                        isSucceeded = self.check(result, targetSubreddits: self.targetSubreddits)
                    })
                }
                expect(isSucceeded).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
            
            it("Check whether the multireddit does inlcude only swift and redditdev articles, Hot") {
                var isSucceeded = false
                if let multi = self.createdMultireddit {
                    self.session?.getList(Paginator(), subreddit: multi, integratedSort:.Hot, timeFilterWithin: TimeFilterWithin.Week, completion: { (result) -> Void in
                        isSucceeded = self.check(result, targetSubreddits: self.targetSubreddits)
                    })
                }
                expect(isSucceeded).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
            
            it("Check whether the multireddit does inlcude only swift and redditdev articles, New") {
                var isSucceeded = false
                if let multi = self.createdMultireddit {
                    self.session?.getList(Paginator(), subreddit: multi, integratedSort:.New, timeFilterWithin: TimeFilterWithin.Week, completion: { (result) -> Void in
                        isSucceeded = self.check(result, targetSubreddits: self.targetSubreddits)
                    })
                }
                expect(isSucceeded).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
            
            it("Check whether the multireddit does inlcude only swift and redditdev articles, Top") {
                var isSucceeded = false
                if let multi = self.createdMultireddit {
                    self.session?.getList(Paginator(), subreddit: multi, integratedSort:.Top, timeFilterWithin: TimeFilterWithin.Week, completion: { (result) -> Void in
                        isSucceeded = self.check(result, targetSubreddits: self.targetSubreddits)
                    })
                }
                expect(isSucceeded).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
            
            it("Update the attribute of new multireddit, except subreddits.") {
                var isSucceeded = false
                if let multi = self.createdMultireddit {
                    multi.iconName = .Science
                    multi.descriptionMd = "updated"
                    self.session?.updateMultireddit(multi, completion: { (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error!.description)
                        case let .Success:
                            if let updatedMultireddit:Multireddit = result.value {
                                expect(updatedMultireddit.descriptionMd).to(equal("updated"))
                                expect(updatedMultireddit.iconName.rawValue).to(equal(MultiredditIconName.Science.rawValue))
                            }
                            isSucceeded = true
                        }
                    })
                }
                expect(isSucceeded).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }

            it("Copy the created multireddit as copytest.") {
                var isSucceeded = false
                if let multi = self.createdMultireddit {
                    self.session?.copyMultireddit(multi, newDisplayName: "copytest", completion:{ (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error!.description)
                        case let .Success:
                            if let multireddit:Multireddit = result.value {
                                self.copiedMultireddit = multireddit
                                isSucceeded = true
                            }
                        }
                    })
                }
                expect(isSucceeded).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
            
            it("Check count of multireddit after copying the created multireddit.") {
                var multiredditCountAfterCopingCreatedOne = 0
                self.session?.getMineMultireddit({ (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        if let array:[Multireddit] = result.value {
                            multiredditCountAfterCopingCreatedOne = array.count
                        }
                    }
                })
                expect(multiredditCountAfterCopingCreatedOne).toEventually(equal(self.initialMultiredditCount + 2), timeout: 10, pollInterval: 1)
            }
            
            it("Delete the copied multireddit.") {
                var isSucceeded = false
                if let multi = self.copiedMultireddit {
                    self.session?.deleteMultireddit(multi, completion: { (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error!.description)
                        case let .Success:
                            isSucceeded = true
                        }
                    })
                }
                expect(isSucceeded).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
            
            it("Delete the created multireddit.") {
                var isSucceeded = false
                if let multi = self.createdMultireddit {
                    self.session?.deleteMultireddit(multi, completion: { (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error!.description)
                        case let .Success:
                            isSucceeded = true
                        }
                    })
                }
                expect(isSucceeded).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
            
            it("Check count of multireddit after deleting the created multireddit.") {
                var multiredditCountAfterDeletingCreatedOne = 0
                self.session?.getMineMultireddit({ (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        if let array:[Multireddit] = result.value {
                            multiredditCountAfterDeletingCreatedOne = array.count
                        }
                    }
                })
                expect(multiredditCountAfterDeletingCreatedOne).toEventually(equal(self.initialMultiredditCount), timeout: 10, pollInterval: 1)
            }
        }
    }
}
