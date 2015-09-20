//
//  MultiTest.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import XCTest

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
    
    func evaluateAddSubredditToMultireddit(subredditDisplayName:String) {
        let msg = "Add subreddits, swift and redditdev, to the new multireddit."
        var addedDisplayName:String? = nil
        let documentOpenExpectation = self.expectationWithDescription(msg)
        if let multi = self.createdMultireddit {
            self.session?.addSubredditToMultireddit(multi, subredditDisplayName:subredditDisplayName, completion:{ (result) -> Void in
                switch result {
                case .Failure:
                    print(result.error!.description)
                case .Success:
                    addedDisplayName = result.value
                }
                XCTAssert(addedDisplayName == subredditDisplayName, msg)
                documentOpenExpectation.fulfill()
            })
        }
        self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
    }
    
    func evaluateMultiredditIsRegistered(nameList:[String]) {
        let msg = "Test whether multireddit is registered"
        let documentOpenExpectation = self.expectationWithDescription(msg)
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
            XCTAssert(count == nameList.count, msg)
            documentOpenExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
    }
    
    func check(result:Result<Listing>, targetSubreddits:[String]) -> Bool {
        var isSucceeded = false
        switch result {
        case .Failure:
            print(result.error!.description)
        case .Success(let listing):
            isSucceeded = true
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
        NSThread.sleepForTimeInterval(self.testInterval)
        return isSucceeded
    }
    
    func evaluateGetList(message:String, subreddit:Multireddit, sort:LinkSortType, timeFilterWithin:TimeFilterWithin) {
        print(message)
        var isSucceeded = false
        let documentOpenExpectation = self.expectationWithDescription(message)
        if let multi = self.createdMultireddit {
            do {
                try self.session?.getList(Paginator(), subreddit: multi, sort:sort, timeFilterWithin: TimeFilterWithin.Week, completion: { (result) -> Void in
                    isSucceeded = self.check(result, targetSubreddits: self.targetSubreddits)
                    XCTAssert(isSucceeded, message)
                    documentOpenExpectation.fulfill()
                })
            }
            catch { XCTFail((error as NSError).description) }
        }
        self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
    }
    
    func testGetInitialMultireditList() {
        do {
            let msg = "Get a initial multireddit list."
            print(msg)
            var isSucceeded:Bool = false
            let documentOpenExpectation = self.expectationWithDescription(msg)
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
                XCTAssert(isSucceeded, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        
        do {
            let msg = "Create a new multireddit."
            print(msg)
            let documentOpenExpectation = self.expectationWithDescription(msg)
            self.session?.createMultireddit(self.nameForCreation, descriptionMd: "", completion: { (result) -> Void in
                switch result {
                case .Failure:
                    print(result.error!.description)
                case .Success:
                    self.createdMultireddit = result.value
                }
                XCTAssert(self.createdMultireddit != nil, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        
        do {
            let msg = "Check count of multireddit after creating a new multireddit."
            print(msg)
            var multiredditCountAfterCreating = 0
            let documentOpenExpectation = self.expectationWithDescription(msg)
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
                XCTAssert(multiredditCountAfterCreating == self.initialMultiredditCount + 1, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            for subreddit in self.targetSubreddits {
                self.evaluateAddSubredditToMultireddit(subreddit)
            }
        }
        
        if let multi = self.createdMultireddit {
            let types:[LinkSortType] = [.Controversial, .Hot, .New, .Top]
            
            for type in types {
                let msg = "Check whether the multireddit does inlcude only swift and redditdev articles, " + type.description
                evaluateGetList(msg, subreddit: multi, sort: type, timeFilterWithin: .Week)
            }
        }
        else {
            XCTFail("Failed, checking whether the multireddit does inlcude only swift and redditdev articles")
        }
        
        
        do {
            let msg = "Update the attribute of new multireddit, except subreddits."
            print(msg)
            var isSucceeded = false
            if var multi = self.createdMultireddit {
                multi.iconName = .Science
                multi.descriptionMd = self.updatedDescription
                let documentOpenExpectation = self.expectationWithDescription(msg)
                self.session?.updateMultireddit(multi, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        if let updatedMultireddit:Multireddit = result.value {
                            XCTAssert(updatedMultireddit.descriptionMd == self.updatedDescription, msg)
                            XCTAssert(updatedMultireddit.iconName.rawValue == MultiredditIconName.Science.rawValue, msg)
                        }
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, msg)
                    documentOpenExpectation.fulfill()
                })
            }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        
        do {
            let msg = "Check the updated description"
            print(msg)
            var isSucceeded = false
            if let multi = self.createdMultireddit {
                let documentOpenExpectation = self.expectationWithDescription(msg)
                self.session?.getMultiredditDescription(multi, completion:{ (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        if let multiredditDescription = result.value as? MultiredditDescription {
                            if multiredditDescription.bodyMd == self.updatedDescription {
                                isSucceeded = true
                            }
                        }

                    }
                    XCTAssert(isSucceeded, msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            else {
                XCTFail(msg)
            }
        }
        
        do {
            let msg = "Copy the created multireddit as copytest."
            print(msg)
            var isSucceeded = false
            if let multi = self.createdMultireddit {
                let documentOpenExpectation = self.expectationWithDescription(msg)
                self.session?.copyMultireddit(multi, newDisplayName:self.nameForCopy, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        self.copiedMultireddit = result.value
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            else {
                XCTFail(msg)
            }
        }
        
        do {
            let msg = "Check count of multireddit after copying the created multireddit."
            print(msg)
            var multiredditCountAfterCopingCreatedOne = 0
            let documentOpenExpectation = self.expectationWithDescription(msg)
            self.session?.getMineMultireddit({ (result) -> Void in
                switch result {
                case .Failure:
                    print(result.error!.description)
                case .Success:
                    if let array = result.value as? [Any] {
                        multiredditCountAfterCopingCreatedOne = array.count
                    }
                }
                XCTAssert(multiredditCountAfterCopingCreatedOne == (self.initialMultiredditCount + 2), msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        
        do {
            let msg = "Get response 409, when renaming the copied multireaddit as existing name"
            print(msg)
            var isSucceeded = false
            if let multi = self.createdMultireddit {
                let documentOpenExpectation = self.expectationWithDescription(msg)
                self.session?.renameMultireddit(multi, newDisplayName: self.nameForCopy, completion:{ (result) -> Void in
                    switch result {
                    case .Failure:
                        if let error:NSError = result.error {
                            isSucceeded = (error.code == 409)
                        }
                    case .Success:
                        print(result.value!)
                    }
                    XCTAssert(isSucceeded, msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            else {
                XCTFail(msg)
            }
        }
        
        do {
            print("Check current multireddit list includes self.nameForCreation and self.nameForCopy")
            self.evaluateMultiredditIsRegistered([self.nameForCreation, self.nameForCopy])
        }
        
        do {
            let msg = "Rename the copied multireaddit"
            print(msg)
            var isSucceeded = false
            if let multi = self.createdMultireddit {
                let documentOpenExpectation = self.expectationWithDescription(msg)
                self.session?.renameMultireddit(multi, newDisplayName: self.nameForRename, completion:{ (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        if let multireddit:Multireddit = result.value {
                            isSucceeded = (multireddit.displayName == self.nameForRename)
                            self.renamedMultireddit = multireddit
                        }
                    }
                    XCTAssert(isSucceeded, msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            else {
                XCTFail(msg)
            }
        }
        
        do {
            let msg = "Check current multireddit list includes self.nameForCreation and self.nameForRename"
            print(msg)
            self.evaluateMultiredditIsRegistered([self.nameForCopy, self.nameForRename])
        }
        
        do {
            let msg = "Delete the copied multireddit."
            print(msg)
            var isSucceeded = false
            if let multi = self.copiedMultireddit {
                let documentOpenExpectation = self.expectationWithDescription(msg)
                self.session?.deleteMultireddit(multi, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            else {
                XCTFail(msg)
            }
        }
        
        do {
            let msg = "Delete the renamed multireddit."
            print(msg)
            var isSucceeded = false
            if let multi = self.renamedMultireddit {
                let documentOpenExpectation = self.expectationWithDescription(msg)
                self.session?.deleteMultireddit(multi, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            else {
                XCTFail(msg)
            }

        }
        
        do {
            let msg = "Check count of multireddit after deleting the created multireddit."
            print(msg)
            var multiredditCountAfterDeletingCreatedOne = 0
            let documentOpenExpectation = self.expectationWithDescription(msg)
            self.session?.getMineMultireddit({ (result) -> Void in
                switch result {
                case .Failure:
                    print(result.error!.description)
                case .Success:
                    if let array = result.value as? [Any]{
                        multiredditCountAfterDeletingCreatedOne = array.count
                    }
                }
                XCTAssert(multiredditCountAfterDeletingCreatedOne == self.initialMultiredditCount, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
    }
}
