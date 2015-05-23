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
    var renamedMultireddit:Multireddit? = nil
    
    let targetSubreddits = ["swift", "redditdev"]
    let nameForCreation = "testmultireddit"
    let nameForCopy = "copytest"
    let nameForRename = "renametest"
    let updatedDescription = "updated description"
    
    func testAddSubredditToMultireddit(subredditDisplayName:String) {
        var addedDisplayName:String? = nil
        if let multi = self.createdMultireddit {
            self.session?.addSubredditToMultireddit(multi, subredditDisplayName:subredditDisplayName, completion:{ (result) -> Void in
                switch result {
                case let .Failure:
                    println(result.error!.description)
                case let .Success:
                    addedDisplayName = result.value
                }
                NSThread.sleepForTimeInterval(self.testInterval)
            })
        }
        expect(addedDisplayName).toEventually(equal(subredditDisplayName), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
    }
    
    func testMultiredditIsRegistered(nameList:[String]) {
        var count = 0
        self.session?.getMineMultireddit({ (result) -> Void in
            switch result {
            case let .Failure:
                println(result.error!.description)
            case let .Success:
                if let array = result.value as? [Multireddit] {
                    for multireddit in array {
                        for name in nameList {
                            if multireddit.name == name {
                                count = count + 1
                                break
                            }
                        }
                    }
                }
            }
            NSThread.sleepForTimeInterval(self.testInterval)
        })
        expect(count).toEventually(equal(nameList.count), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
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
        NSThread.sleepForTimeInterval(self.testInterval)
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
                        if let array = result.value as? [Multireddit] {
                            self.initialMultiredditCount = array.count
                        }
                        isSucceeded = true
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
        
            it("Create a new multireddit.") {
                self.session?.createMultireddit(self.nameForCreation, descriptionMd: "", completion: { (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        self.createdMultireddit = result.value
                    }
                })
                expect(self.createdMultireddit == nil).toEventually(equal(false), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Check count of multireddit after creating a new multireddit.") {
                var multiredditCountAfterCreating = 0
                self.session?.getMineMultireddit({ (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        if let array = result.value as? [Multireddit] {
                            multiredditCountAfterCreating = array.count
                        }
                    }
                    NSThread.sleepForTimeInterval(self.testInterval)
                })
                expect(multiredditCountAfterCreating).toEventually(equal(self.initialMultiredditCount + 1), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
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
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Check whether the multireddit does inlcude only swift and redditdev articles, Hot") {
                var isSucceeded = false
                if let multi = self.createdMultireddit {
                    self.session?.getList(Paginator(), subreddit: multi, integratedSort:.Hot, timeFilterWithin: TimeFilterWithin.Week, completion: { (result) -> Void in
                        isSucceeded = self.check(result, targetSubreddits: self.targetSubreddits)
                    })
                }
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Check whether the multireddit does inlcude only swift and redditdev articles, New") {
                var isSucceeded = false
                if let multi = self.createdMultireddit {
                    self.session?.getList(Paginator(), subreddit: multi, integratedSort:.New, timeFilterWithin: TimeFilterWithin.Week, completion: { (result) -> Void in
                        isSucceeded = self.check(result, targetSubreddits: self.targetSubreddits)
                    })
                }
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Check whether the multireddit does inlcude only swift and redditdev articles, Top") {
                var isSucceeded = false
                if let multi = self.createdMultireddit {
                    self.session?.getList(Paginator(), subreddit: multi, integratedSort:.Top, timeFilterWithin: TimeFilterWithin.Week, completion: { (result) -> Void in
                        isSucceeded = self.check(result, targetSubreddits: self.targetSubreddits)
                    })
                }
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Update the attribute of new multireddit, except subreddits.") {
                var isSucceeded = false
                if let multi = self.createdMultireddit {
                    multi.iconName = .Science
                    multi.descriptionMd = self.updatedDescription
                    self.session?.updateMultireddit(multi, completion: { (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error!.description)
                        case let .Success:
                            if let updatedMultireddit:Multireddit = result.value {
                                expect(updatedMultireddit.descriptionMd).to(equal(self.updatedDescription))
                                expect(updatedMultireddit.iconName.rawValue).to(equal(MultiredditIconName.Science.rawValue))
                            }
                            isSucceeded = true
                        }
                        NSThread.sleepForTimeInterval(self.testInterval)
                    })
                }
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Check the updated description") {
                var isSucceeded = false
                if let multi = self.createdMultireddit {
                    self.session?.getMultiredditDescription(multi, completion:{ (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error!.description)
                        case let .Success:
                            println(result.value!)
                            if let multiredditDescription = result.value as? MultiredditDescription {
                                if multiredditDescription.bodyMd == self.updatedDescription {
                                    isSucceeded = true
                                }
                            }
                            
                        }
                        NSThread.sleepForTimeInterval(self.testInterval)
                    })
                }
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Copy the created multireddit as copytest.") {
                var isSucceeded = false
                if let multi = self.createdMultireddit {
                    self.session?.copyMultireddit(multi, newDisplayName:self.nameForCopy, completion: { (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error!.description)
                        case let .Success:
                            self.copiedMultireddit = result.value
                            isSucceeded = true
                        }
                        NSThread.sleepForTimeInterval(self.testInterval)
                    })
                }
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Check count of multireddit after copying the created multireddit.") {
                var multiredditCountAfterCopingCreatedOne = 0
                self.session?.getMineMultireddit({ (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        if let array = result.value as? [Multireddit] {
                            multiredditCountAfterCopingCreatedOne = array.count
                        }
                    }
                    NSThread.sleepForTimeInterval(self.testInterval)
                })
                expect(multiredditCountAfterCopingCreatedOne).toEventually(equal(self.initialMultiredditCount + 2), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Get response 409, when renaming the copied multireaddit as existing name") {
                var isSucceeded = false
                if let multi = self.createdMultireddit {
                    self.session?.renameMultireddit(multi, newDisplayName: self.nameForCopy, completion:{ (result) -> Void in
                        switch result {
                        case let .Failure:
                            if let error:NSError = result.error {
                                isSucceeded = (error.code == 409)
                            }
                        case let .Success:
                            println(result.value!)
                        }
                        NSThread.sleepForTimeInterval(self.testInterval)
                    })
                }
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Check current multireddit list includes self.nameForCreation and self.nameForCopy") {
                self.testMultiredditIsRegistered([self.nameForCreation, self.nameForCopy])
            }
            
            it("Rename the copied multireaddit") {
                var isSucceeded = false
                if let multi = self.createdMultireddit {
                    self.session?.renameMultireddit(multi, newDisplayName: self.nameForRename, completion:{ (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error!.description)
                        case let .Success:
                            if let multireddit:Multireddit = result.value {
                                isSucceeded = (multireddit.displayName == self.nameForRename)
                                self.renamedMultireddit = multireddit
                            }
                        }
                        NSThread.sleepForTimeInterval(self.testInterval)
                    })
                }
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Check current multireddit list includes self.nameForCreation and self.nameForRename") {
                self.testMultiredditIsRegistered([self.nameForCopy, self.nameForRename])
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
                        NSThread.sleepForTimeInterval(self.testInterval)
                    })
                }
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Delete the renamed multireddit.") {
                var isSucceeded = false
                if let multi = self.renamedMultireddit {
                    self.session?.deleteMultireddit(multi, completion: { (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error!.description)
                        case let .Success:
                            isSucceeded = true
                        }
                        NSThread.sleepForTimeInterval(self.testInterval)
                    })
                }
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Check count of multireddit after deleting the created multireddit.") {
                var multiredditCountAfterDeletingCreatedOne = 0
                self.session?.getMineMultireddit({ (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        if let array = result.value as? [Multireddit]{
                            multiredditCountAfterDeletingCreatedOne = array.count
                        }
                    }
                    NSThread.sleepForTimeInterval(self.testInterval)
                })
                expect(multiredditCountAfterDeletingCreatedOne).toEventually(equal(self.initialMultiredditCount), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
        }
    }
}
