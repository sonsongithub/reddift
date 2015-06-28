//
//  MultiTest.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Nimble
import Quick

class MultiredditTest: SessionTestSpec2 {
    
    var initialMultiredditCount = 0
    
    var createdMultireddit:Multireddit? = nil
    var copiedMultireddit:Multireddit? = nil
    var renamedMultireddit:Multireddit? = nil
    
    let targetSubreddits = ["swift", "redditdev"]
    let nameForCreation = "testmultireddit"
    let nameForCopy = "copytest"
    let nameForRename = "renametest"
    let updatedDescription = "updated description"
    
    func evaluateAddSubredditToMultireddit(subredditDisplayName:String) {
        var addedDisplayName:String? = nil
        let documentOpenExpectation = self.expectationWithDescription("Add subreddits, swift and redditdev, to the new multireddit.")
        if let multi = self.createdMultireddit {
            self.session?.addSubredditToMultireddit(multi, subredditDisplayName:subredditDisplayName, completion:{ (result) -> Void in
                switch result {
                case .Failure:
                    print(result.error!.description)
                case .Success:
                    addedDisplayName = result.value
                }
                XCTAssert(addedDisplayName == subredditDisplayName, "Add subreddits, swift and redditdev, to the new multireddit.")
                documentOpenExpectation.fulfill()
            })
        }
        self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
    }
    
    func evaluateMultiredditIsRegistered(nameList:[String]) {
        let documentOpenExpectation = self.expectationWithDescription("Test whether multireddit is registered")
        self.session?.getMineMultireddit({ (result) -> Void in
            var count = 0
            switch result {
            case .Failure:
                print(result.error!.description)
            case .Success:
                if let array = result.value as? [Any] {
                    for multireddit in array {
                        if let multireddit = multireddit as? Multireddit {
                            for name in nameList {
                                if multireddit.name == name {
                                    count = count + 1
                                    break
                                }
                            }
                        }
                    }
                }
            }
            XCTAssert(count == nameList.count, "Test whether multireddit is registered")
            documentOpenExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
    }
    
    func check(result:Result<RedditAny>, targetSubreddits:[String]) -> Bool {
        var isSucceeded = false
        switch result {
        case .Failure:
            print(result.error!.description)
        case .Success:
            isSucceeded = true
            if let listing = result.value as? Listing {
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
    
    func testGetInitialMultireditList() {
        do {
            var isSucceeded:Bool = false
            let documentOpenExpectation = self.expectationWithDescription("Get a initial multireddit list.")
            self.session?.getMineMultireddit({ (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let array):
                    if let array = array as? [Any] {
                        self.initialMultiredditCount = array.count
                    }
                    isSucceeded = true
                }
                XCTAssert(isSucceeded,"")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        
        do {
            let documentOpenExpectation = self.expectationWithDescription("Create a new multireddit.")
            self.session?.createMultireddit(self.nameForCreation, descriptionMd: "", completion: { (result) -> Void in
                switch result {
                case .Failure:
                    print(result.error!.description)
                case .Success:
                    self.createdMultireddit = result.value
                }
                XCTAssert(self.createdMultireddit != nil)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        
        do {
            var multiredditCountAfterCreating = 0
            let documentOpenExpectation = self.expectationWithDescription("Check count of multireddit after creating a new multireddit.")
            self.session?.getMineMultireddit({ (result) -> Void in
                switch result {
                case .Failure:
                    print(result.error!.description)
                case .Success:
                    var checkType = false
                    if let array = result.value as? [Any] {
                        checkType = true
                        for obj in array {
                            if !(obj is Multireddit) {
                                checkType = false
                            }
                        }
                        multiredditCountAfterCreating = array.count
                    }
                    XCTAssert(checkType)
                }
                XCTAssert(multiredditCountAfterCreating == self.initialMultiredditCount + 1)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        
        do {
            for subreddit in self.targetSubreddits {
                self.evaluateAddSubredditToMultireddit(subreddit)
            }
        }
    }
    
            
            
            
            
            
            
            
            
            
//            it("Check whether the multireddit does inlcude only swift and redditdev articles, Controversial") {
//                var isSucceeded = false
//                if let multi = self.createdMultireddit {
//                    self.session?.getList(Paginator(), subreddit: multi, sort:LinkSortType.Controversial, timeFilterWithin: TimeFilterWithin.Week, completion: { (result) -> Void in
//                        isSucceeded = self.check(result, targetSubreddits: self.targetSubreddits)
//                    })
//                }
//                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
//            }
//            
//            it("Check whether the multireddit does inlcude only swift and redditdev articles, Hot") {
//                var isSucceeded = false
//                if let multi = self.createdMultireddit {
//                    self.session?.getList(Paginator(), subreddit: multi, sort:.Hot, timeFilterWithin: TimeFilterWithin.Week, completion: { (result) -> Void in
//                        isSucceeded = self.check(result, targetSubreddits: self.targetSubreddits)
//                    })
//                }
//                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
//            }
//            
//            it("Check whether the multireddit does inlcude only swift and redditdev articles, New") {
//                var isSucceeded = false
//                if let multi = self.createdMultireddit {
//                    self.session?.getList(Paginator(), subreddit: multi, sort:.New, timeFilterWithin: TimeFilterWithin.Week, completion: { (result) -> Void in
//                        isSucceeded = self.check(result, targetSubreddits: self.targetSubreddits)
//                    })
//                }
//                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
//            }
//            
//            it("Check whether the multireddit does inlcude only swift and redditdev articles, Top") {
//                var isSucceeded = false
//                if let multi = self.createdMultireddit {
//                    self.session?.getList(Paginator(), subreddit: multi, sort:.Top, timeFilterWithin: TimeFilterWithin.Week, completion: { (result) -> Void in
//                        isSucceeded = self.check(result, targetSubreddits: self.targetSubreddits)
//                    })
//                }
//                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
//            }
            
//            it("Update the attribute of new multireddit, except subreddits.") {
//                var isSucceeded = false
//                if var multi = self.createdMultireddit {
//                    multi.iconName = .Science
//                    multi.descriptionMd = self.updatedDescription
//                    self.session?.updateMultireddit(multi, completion: { (result) -> Void in
//                        switch result {
//                        case .Failure:
//                            print(result.error!.description)
//                        case .Success:
//                            if let updatedMultireddit:Multireddit = result.value {
//                                expect(updatedMultireddit.descriptionMd).to(equal(self.updatedDescription))
//                                expect(updatedMultireddit.iconName.rawValue).to(equal(MultiredditIconName.Science.rawValue))
//                            }
//                            isSucceeded = true
//                        }
//                        NSThread.sleepForTimeInterval(self.testInterval)
//                    })
//                }
//                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
//            }
//            
//            it("Check the updated description") {
//                var isSucceeded = false
//                if let multi = self.createdMultireddit {
//                    self.session?.getMultiredditDescription(multi, completion:{ (result) -> Void in
//                        switch result {
//                        case .Failure:
//                            print(result.error!.description)
//                        case .Success:
//                            if let multiredditDescription = result.value as? MultiredditDescription {
//                                if multiredditDescription.bodyMd == self.updatedDescription {
//                                    isSucceeded = true
//                                }
//                            }
//                            
//                        }
//                        NSThread.sleepForTimeInterval(self.testInterval)
//                    })
//                }
//                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
//            }
//            
//            it("Copy the created multireddit as copytest.") {
//                var isSucceeded = false
//                if let multi = self.createdMultireddit {
//                    self.session?.copyMultireddit(multi, newDisplayName:self.nameForCopy, completion: { (result) -> Void in
//                        switch result {
//                        case .Failure:
//                            print(result.error!.description)
//                        case .Success:
//                            self.copiedMultireddit = result.value
//                            isSucceeded = true
//                        }
//                        NSThread.sleepForTimeInterval(self.testInterval)
//                    })
//                }
//                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
//            }
//            
//            it("Check count of multireddit after copying the created multireddit.") {
//                var multiredditCountAfterCopingCreatedOne = 0
//                self.session?.getMineMultireddit({ (result) -> Void in
//                    switch result {
//                    case .Failure:
//                        print(result.error!.description)
//                    case .Success:
//                        if let array = result.value as? [Any] {
//                            multiredditCountAfterCopingCreatedOne = array.count
//                        }
//                    }
//                    NSThread.sleepForTimeInterval(self.testInterval)
//                })
//                expect(multiredditCountAfterCopingCreatedOne).toEventually(equal(self.initialMultiredditCount + 2), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
//            }
//            
//            it("Get response 409, when renaming the copied multireaddit as existing name") {
//                var isSucceeded = false
//                if let multi = self.createdMultireddit {
//                    self.session?.renameMultireddit(multi, newDisplayName: self.nameForCopy, completion:{ (result) -> Void in
//                        switch result {
//                        case .Failure:
//                            if let error:NSError = result.error {
//                                isSucceeded = (error.code == 409)
//                            }
//                        case .Success:
//                            print(result.value!)
//                        }
//                        NSThread.sleepForTimeInterval(self.testInterval)
//                    })
//                }
//                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
//            }
//            
//            it("Check current multireddit list includes self.nameForCreation and self.nameForCopy") {
//                self.testMultiredditIsRegistered([self.nameForCreation, self.nameForCopy])
//            }
//            
//            it("Rename the copied multireaddit") {
//                var isSucceeded = false
//                if let multi = self.createdMultireddit {
//                    self.session?.renameMultireddit(multi, newDisplayName: self.nameForRename, completion:{ (result) -> Void in
//                        switch result {
//                        case .Failure:
//                            print(result.error!.description)
//                        case .Success:
//                            if let multireddit:Multireddit = result.value {
//                                isSucceeded = (multireddit.displayName == self.nameForRename)
//                                self.renamedMultireddit = multireddit
//                            }
//                        }
//                        NSThread.sleepForTimeInterval(self.testInterval)
//                    })
//                }
//                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
//            }
//            
//            it("Check current multireddit list includes self.nameForCreation and self.nameForRename") {
//                self.testMultiredditIsRegistered([self.nameForCopy, self.nameForRename])
//            }
//            
//            it("Delete the copied multireddit.") {
//                var isSucceeded = false
//                if let multi = self.copiedMultireddit {
//                    self.session?.deleteMultireddit(multi, completion: { (result) -> Void in
//                        switch result {
//                        case .Failure:
//                            print(result.error!.description)
//                        case .Success:
//                            isSucceeded = true
//                        }
//                        NSThread.sleepForTimeInterval(self.testInterval)
//                    })
//                }
//                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
//            }
//            
//            it("Delete the renamed multireddit.") {
//                var isSucceeded = false
//                if let multi = self.renamedMultireddit {
//                    self.session?.deleteMultireddit(multi, completion: { (result) -> Void in
//                        switch result {
//                        case .Failure:
//                            print(result.error!.description)
//                        case .Success:
//                            isSucceeded = true
//                        }
//                        NSThread.sleepForTimeInterval(self.testInterval)
//                    })
//                }
//                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
//            }
//            
//            it("Check count of multireddit after deleting the created multireddit.") {
//                var multiredditCountAfterDeletingCreatedOne = 0
//                self.session?.getMineMultireddit({ (result) -> Void in
//                    switch result {
//                    case .Failure:
//                        print(result.error!.description)
//                    case .Success:
//                        if let array = result.value as? [Any]{
//                            multiredditCountAfterDeletingCreatedOne = array.count
//                        }
//                    }
//                    NSThread.sleepForTimeInterval(self.testInterval)
//                })
//                expect(multiredditCountAfterDeletingCreatedOne).toEventually(equal(self.initialMultiredditCount), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
//            }
//        }
//    }
}
