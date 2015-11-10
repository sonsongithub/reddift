//
//  MultiTest.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import XCTest

extension Array {
    func checkAllElementsIncludedIn<T : Equatable>(array:[T]) -> Bool {
        var result = true
        for obj in self {
            result = result && (array.indexOf(obj as! T) != nil)
        }
        return result
    }
}

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
    let updatedDescription2 = "updated description2"
    
    func evaluateAddSubredditToMultireddit(subredditDisplayName:String) {
        let msg = "Add subreddits, swift and redditdev, to the new multireddit."
        var addedDisplayName:String? = nil
        let documentOpenExpectation = self.expectationWithDescription(msg)
        if let multi = self.createdMultireddit {
            do {
                try self.session?.addSubredditToMultireddit(multi, subredditDisplayName:subredditDisplayName, completion:{ (result) -> Void in
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
            catch { XCTFail((error as NSError).description) }
        }
        self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
    }
    
    func getMineMultireddit() -> [Multireddit] {
        var list:[Multireddit] = []
        let documentOpenExpectation = self.expectationWithDescription("getMineMultireddit")
        do {
            try self.session?.getMineMultireddit({ (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let multireddits):
                    list.appendContentsOf(multireddits)
                }
                XCTAssert(list.count > 0, "getMineMultireddit")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        return list
    }
    
    func evaluateMultiredditIsRegistered(nameList:[String]) {
        let msg = "Test whether multireddit is registered"
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.getMineMultireddit({ (result) -> Void in
                var count = 0
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let multireddits):
                    for multireddit in multireddits {
                        for name in nameList {
                            if multireddit.name == name {
                                count = count + 1
                                break
                            }
                        }
                    }
                }
                XCTAssert(count == nameList.count, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
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
    
    func testGetPublicMultiredditList() {
        do {
            let msg = "Get sonson_twit's public multireddit list and check whether the list includes specified subreddits."
            print(msg)
            var isSucceeded:Bool = false
            let documentOpenExpectation = self.expectationWithDescription(msg)
            do {
                try self.session?.getPublicMultiredditOfUsername("sonson_twit", completion: { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error.description)
                    case .Success(let multireddits):
                        isSucceeded = true
                        let downloadedList = multireddits.map({$0.name})
                        ["mine", "english", "public_test"].forEach({
                            isSucceeded = isSucceeded && (downloadedList.indexOf($0) != nil)
                        })
                    }
                    XCTAssert(isSucceeded, msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            catch { XCTFail((error as NSError).description) }
        }
    }
    
    func getNumberOfMultireddits() -> Int {
        var getNumberOfMultireddits = 0
        let msg = "Get a initial multireddit list."
        print(msg)
        var isSucceeded:Bool = false
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.getMineMultireddit({ (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let multireddits):
                    getNumberOfMultireddits = multireddits.count
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        return getNumberOfMultireddits
    }
    
    func createMultireddit(name:String) -> Multireddit? {
        var createdMultireddit:Multireddit? = nil
        let msg = "Create a new multireddit."
        print(msg)
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.createMultireddit(self.nameForCreation, descriptionMd: "", completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let multireddit):
                    createdMultireddit = multireddit
                }
                XCTAssert(createdMultireddit != nil, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        return createdMultireddit
    }
    
    func deleteMultireddit(multireddit:Multireddit) {
        let msg = "Delete the copied multireddit."
        print(msg)
        var isSucceeded = false
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.deleteMultireddit(multireddit, completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success:
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
    }
    
    func testCreateAndDeleteMultireddit() {
        let nameForCreation = "testmultireddit"
        let initialNumberOfMultireddits = getNumberOfMultireddits()
        let multireddit = createMultireddit(nameForCreation)
        let numberOfMultiredditsAfterCreating = getNumberOfMultireddits()
        XCTAssert(numberOfMultiredditsAfterCreating == initialNumberOfMultireddits + 1)
        if let multireddit = multireddit {
            deleteMultireddit(multireddit)
        }
        let numberOfMultiredditsAfterDeleting = getNumberOfMultireddits()
        XCTAssert(numberOfMultiredditsAfterDeleting == initialNumberOfMultireddits)
    }
    
    func testRenameMultireddit() {
        let nameForCreation = "testmultireddit"
        let nameForRename = "renametest"
        guard let multireddit = createMultireddit(nameForCreation) else { XCTFail("Error"); return }
        let msg = "Rename a multireaddit"
        print(msg)
        var isSucceeded = false
        var renamedMultireddit:Multireddit? = nil
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.renameMultireddit(multireddit, newDisplayName: nameForRename, completion:{ (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let multireddit):
                    renamedMultireddit = multireddit
                    isSucceeded = (multireddit.displayName == nameForRename)
                }
                XCTAssert(isSucceeded, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        
        let currentMultiredditNameList = getMineMultireddit().map({$0.displayName})
        [nameForRename].checkAllElementsIncludedIn(currentMultiredditNameList)
        
        if let renamedMultireddit = renamedMultireddit {
            deleteMultireddit(renamedMultireddit)
        }
        else { XCTFail("Error") }
    }
    
    func testCopyMultireddit() {
        let nameForCreation = "testmultireddit"
        let nameForCopy = "copiedtest"
        guard let multireddit = createMultireddit(nameForCreation) else { XCTFail("Error"); return }
        let msg = "Rename a multireaddit"
        print(msg)
        var isSucceeded = false
        var renamedMultireddit:Multireddit? = nil
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.copyMultireddit(multireddit, newDisplayName: nameForCopy, completion:{ (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let multireddit):
                    renamedMultireddit = multireddit
                    isSucceeded = (multireddit.displayName == nameForCopy)
                }
                XCTAssert(isSucceeded, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        
        let currentMultiredditNameList = getMineMultireddit().map({$0.displayName})
        [nameForCopy].checkAllElementsIncludedIn(currentMultiredditNameList)
        
        if let renamedMultireddit = renamedMultireddit {
            deleteMultireddit(renamedMultireddit)
        }
        else { XCTFail("Error") }
    }
    
    func testPutMultiredditDescription() {
    }
   
    func testUpdateMultiredditDescription() {
    }
    
    func testAddAndRemoveSubredditFromMultireddit() {
    }
    
    
    func testGetInitialMultiredditList() {
        do {
            let msg = "Get a initial multireddit list."
            print(msg)
            var isSucceeded:Bool = false
            let documentOpenExpectation = self.expectationWithDescription(msg)
            do {
                try self.session?.getMineMultireddit({ (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error.description)
                    case .Success(let multireddits):
                        self.initialMultiredditCount = multireddits.count
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            catch { XCTFail((error as NSError).description) }
        }
        
        do {
            let msg = "Create a new multireddit."
            print(msg)
            let documentOpenExpectation = self.expectationWithDescription(msg)
            do {
                try self.session?.createMultireddit(self.nameForCreation, descriptionMd: "", completion: { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error.description)
                    case .Success(let multireddit):
                        self.createdMultireddit = multireddit
                    }
                    XCTAssert(self.createdMultireddit != nil, msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            catch { XCTFail((error as NSError).description) }
        }
        
        do {
            let msg = "Check count of multireddit after creating a new multireddit."
            print(msg)
            var multiredditCountAfterCreating = 0
            let documentOpenExpectation = self.expectationWithDescription(msg)
            do {
                try self.session?.getMineMultireddit({ (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error.description)
                    case .Success(let multireddits):
                        multiredditCountAfterCreating = multireddits.count
                    }
                    XCTAssert(multiredditCountAfterCreating == self.initialMultiredditCount + 1, msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
                for subreddit in self.targetSubreddits {
                    self.evaluateAddSubredditToMultireddit(subreddit)
                }
            }
            catch { XCTFail((error as NSError).description) }
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
                do {
                    try self.session?.updateMultireddit(multi, completion: { (result) -> Void in
                        switch result {
                        case .Failure(let error):
                            print(error.description)
                        case .Success(let updatedMultireddit):
                            XCTAssert(updatedMultireddit.descriptionMd == self.updatedDescription, msg)
                            XCTAssert(updatedMultireddit.iconName.rawValue == MultiredditIconName.Science.rawValue, msg)
                            isSucceeded = true
                        }
                        XCTAssert(isSucceeded, msg)
                        documentOpenExpectation.fulfill()
                    })
                }
                catch { XCTFail((error as NSError).description) }
            }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        
        do {
            let msg = "Check the updated description by updateMultireddit"
            print(msg)
            var isSucceeded = false
            if let multi = self.createdMultireddit {
                let documentOpenExpectation = self.expectationWithDescription(msg)
                do {
                    try self.session?.getMultiredditDescription(multi, completion:{ (result) -> Void in
                        switch result {
                        case .Failure(let error):
                            print(error.description)
                        case .Success(let multiredditDescription):
                            if multiredditDescription.bodyMd == self.updatedDescription {
                                isSucceeded = true
                            }
                        }
                        XCTAssert(isSucceeded, msg)
                        documentOpenExpectation.fulfill()
                    })
                    self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
                }
                catch { XCTFail((error as NSError).description) }
            }
            else {
                XCTFail(msg)
            }
        }
        
        do {
            let msg = "Update the description of multireddit by putMultiredditDescription"
            print(msg)
            var isSucceeded = false
            if let multi = self.createdMultireddit {
                let documentOpenExpectation = self.expectationWithDescription(msg)
                do {
                    try self.session?.putMultiredditDescription(multi, description: self.updatedDescription2, completion:{ (result) -> Void in
                        switch result {
                        case .Failure(let error):
                            print(error.description)
                        case .Success(let multiredditDescription):
                            if multiredditDescription.bodyMd == self.updatedDescription2 {
                                isSucceeded = true
                            }
                        }
                        XCTAssert(isSucceeded, msg)
                        documentOpenExpectation.fulfill()
                    })
                    self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
                }
                catch { XCTFail((error as NSError).description) }
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
                do {
                    try self.session?.copyMultireddit(multi, newDisplayName:self.nameForCopy, completion: { (result) -> Void in
                        switch result {
                        case .Failure(let error):
                            print(error.description)
                        case .Success(let multireddit):
                            self.copiedMultireddit = multireddit
                            isSucceeded = true
                        }
                        XCTAssert(isSucceeded, msg)
                        documentOpenExpectation.fulfill()
                    })
                    self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
                }
                catch { XCTFail((error as NSError).description) }
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
            do {
                try self.session?.getMineMultireddit({ (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error.description)
                    case .Success(let multireddits):
                        multiredditCountAfterCopingCreatedOne = multireddits.count
                    }
                    XCTAssert(multiredditCountAfterCopingCreatedOne == (self.initialMultiredditCount + 2), msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            catch { XCTFail((error as NSError).description) }
        }
        
        do {
            let msg = "Get response 409, when renaming the copied multireaddit as existing name"
            print(msg)
            var isSucceeded = false
            if let multi = self.createdMultireddit {
                let documentOpenExpectation = self.expectationWithDescription(msg)
                do {
                    try self.session?.renameMultireddit(multi, newDisplayName: self.nameForCopy, completion:{ (result) -> Void in
                        switch result {
                        case .Failure(let error):
                            isSucceeded = (error.code == 409)
                        case .Success(let multireddit):
                            print(multireddit)
                        }
                        XCTAssert(isSucceeded, msg)
                        documentOpenExpectation.fulfill()
                    })
                    self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
                }
                catch { XCTFail((error as NSError).description) }
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
                do {
                    try self.session?.renameMultireddit(multi, newDisplayName: self.nameForRename, completion:{ (result) -> Void in
                        switch result {
                        case .Failure(let error):
                            print(error.description)
                        case .Success(let multireddit):
                            isSucceeded = (multireddit.displayName == self.nameForRename)
                            self.renamedMultireddit = multireddit
                        }
                        XCTAssert(isSucceeded, msg)
                        documentOpenExpectation.fulfill()
                    })
                    self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
                }
                catch { XCTFail((error as NSError).description) }
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
                do {
                    try self.session?.deleteMultireddit(multi, completion: { (result) -> Void in
                        switch result {
                        case .Failure(let error):
                            print(error.description)
                        case .Success:
                            isSucceeded = true
                        }
                        XCTAssert(isSucceeded, msg)
                        documentOpenExpectation.fulfill()
                    })
                    self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
                }
                catch { XCTFail((error as NSError).description) }
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
                do {
                    try self.session?.deleteMultireddit(multi, completion: { (result) -> Void in
                        switch result {
                        case .Failure(let error):
                            print(error.description)
                        case .Success:
                            isSucceeded = true
                        }
                        XCTAssert(isSucceeded, msg)
                        documentOpenExpectation.fulfill()
                    })
                    self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
                }
                catch { XCTFail((error as NSError).description) }
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
            do {
                try self.session?.getMineMultireddit({ (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error.description)
                    case .Success(let multireddits):
                        multiredditCountAfterDeletingCreatedOne = multireddits.count
                    }
                    XCTAssert(multiredditCountAfterDeletingCreatedOne == self.initialMultiredditCount, msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            catch { XCTFail((error as NSError).description) }
        }
    }
}
