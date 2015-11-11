//
//  MultiTest.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import XCTest

/// following extension for test only
private extension Array {
    func checkAllElementsIncludedIn<T : Equatable>(array:[T]) -> Bool {
        var result = true
        for obj in self {
            result = result && (array.indexOf(obj as! T) != nil)
        }
        return result
    }
    
    func hasSameElements<T : Equatable>(array:[T]) -> Bool {
        if self.count != array.count {
            return false
        }
        return self.checkAllElementsIncludedIn(array)
    }
}

extension MultiredditTest {
    func getOwnMultireddit() -> [Multireddit] {
        let msg = "Get own multireddit list."
        print(msg)
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
    
    func createMultireddit(name:String) -> Multireddit? {
        var createdMultireddit:Multireddit? = nil
        let msg = "Create a new multireddit."
        print(msg)
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.createMultireddit(name, descriptionMd: "", completion: { (result) -> Void in
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
        let msg = "Delete the multireddit, \(multireddit.name)"
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

    func addSubredditToMultireddit(subredditDisplayName:String, multireddit:Multireddit) {
        let msg = "Add subreddit, \(subredditDisplayName) to multireddit, \(multireddit.name)."
        print(msg)
        var isSucceeded:Bool = false
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.addSubredditToMultireddit(multireddit, subredditDisplayName: subredditDisplayName, completion: { (result) -> Void in
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
}

class MultiredditTest: SessionTestSpec {
    var createdMultireddit:Multireddit? = nil
    var copiedMultireddit:Multireddit? = nil
    var renamedMultireddit:Multireddit? = nil
    let defaultMultiredditName = "testmultireddit"
    var defaultMultiredditCount = 0
    
    override func setUp() {
        super.setUp()
        self.defaultMultiredditCount = getOwnMultireddit().count
        self.createdMultireddit = createMultireddit(defaultMultiredditName)
    }
    
    override func tearDown() {
        super.tearDown()
        if let multireddit = self.createdMultireddit {
            deleteMultireddit(multireddit)
            self.createdMultireddit = nil
        }
        if let multireddit = self.renamedMultireddit {
            deleteMultireddit(multireddit)
            self.renamedMultireddit = nil
        }
        if let multireddit = self.copiedMultireddit {
            deleteMultireddit(multireddit)
            self.copiedMultireddit = nil
        }
        XCTAssert(self.defaultMultiredditCount == getOwnMultireddit().count)
    }
    
    func testCreateAndDeleteMultireddit() {
        XCTAssert(self.defaultMultiredditCount + 1 == getOwnMultireddit().count)
    }
    
    func testRenameMultireddit() {
        let nameForRename = "nameForRename"
        let msg = "Test renaming a multireddit."
        print(msg)
        var isSucceeded = false
        guard let multireddit = self.createdMultireddit else { XCTFail("Error"); return }
        
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.renameMultireddit(multireddit, newDisplayName: nameForRename, completion:{ (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let multireddit):
                    self.renamedMultireddit = multireddit
                    self.createdMultireddit = nil
                    isSucceeded = (multireddit.displayName == nameForRename)
                }
                XCTAssert(isSucceeded, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }

        let currentMultiredditNameList = getOwnMultireddit().map({$0.displayName})
        XCTAssert([nameForRename].checkAllElementsIncludedIn(currentMultiredditNameList), "error")
    }
    
    func testCopyMultireddit() {
        let nameForCopy = "copiedtest"
        guard let multireddit = self.createdMultireddit else { XCTFail("Error"); return }
        let msg = "Test copy a multireddit."
        print(msg)
        var isSucceeded = false
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.copyMultireddit(multireddit, newDisplayName: nameForCopy, completion:{ (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let multireddit):
                    self.copiedMultireddit = multireddit
                    isSucceeded = (multireddit.displayName == nameForCopy)
                }
                XCTAssert(isSucceeded, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }

        XCTAssert(self.defaultMultiredditCount + 2 == getOwnMultireddit().count)

        let currentMultiredditNameList = getOwnMultireddit().map({$0.displayName})
        XCTAssert([nameForCopy].checkAllElementsIncludedIn(currentMultiredditNameList), "error")
    }
    
    
    func testRenameMultiredditError() {
        let nameForCopy = "copiedtest"
        guard let multireddit = self.createdMultireddit else { XCTFail("Error"); return }
        let msg = "Test renaming a multireddit with the existing name."
        print(msg)
        var isSucceeded = false
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.copyMultireddit(multireddit, newDisplayName: nameForCopy, completion:{ (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let multireddit):
                    self.copiedMultireddit = multireddit
                    isSucceeded = (multireddit.displayName == nameForCopy)
                }
                XCTAssert(isSucceeded, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        
        XCTAssert(self.defaultMultiredditCount + 2 == getOwnMultireddit().count)
        
        let currentMultiredditNameList = getOwnMultireddit().map({$0.displayName})
        XCTAssert([nameForCopy].checkAllElementsIncludedIn(currentMultiredditNameList), "error")
        
        do {
            let errorMessage = "Could not get response 409, when renaming the copied multireaddit as existing name."
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription(errorMessage)
            do {
                try self.session?.renameMultireddit(multireddit, newDisplayName: nameForCopy, completion:{ (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        isSucceeded = (error.code == 409)
                    case .Success(let multireddit):
                        print(multireddit)
                        self.renamedMultireddit = multireddit
                    }
                    XCTAssert(isSucceeded, errorMessage)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            catch { XCTFail((error as NSError).description) }
        }

    }
    
    func testPutMultiredditDescription() {
        let updatedDescription = "updated description"
        guard let multireddit = self.createdMultireddit else { XCTFail("Error"); return }
        let msg = "Test putting a new description to the multireddit, using 'putMultiredditDescription'."
        print(msg)
        var isSucceeded = false
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.putMultiredditDescription(multireddit, description: updatedDescription, completion:{ (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let multiredditDescription):
                    if multiredditDescription.bodyMd == updatedDescription {
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
    
    func testUpdateMultiredditDescription() {
        let updatedDescription = "updated description"
        
        guard var multireddit = self.createdMultireddit else { XCTFail("Error"); return }
        
        let msg = "Test updating a new description to the multireddit, using 'updateMultireddit'."
        print(msg)
        var isSucceeded = false
        multireddit.iconName = .Science
        multireddit.descriptionMd = updatedDescription
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.updateMultireddit(multireddit, completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let updatedMultireddit):
                    XCTAssert(updatedMultireddit.descriptionMd == updatedDescription, msg)
                    XCTAssert(updatedMultireddit.iconName.rawValue == MultiredditIconName.Science.rawValue, msg)
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
    }

    func testGetAndConfirmPublicMultiredditList() {
        do {
            let msg = "Test getting sonson_twit's public multireddit list and check whether the list includes specified subreddits."
            var isSucceeded:Bool = false
            let documentOpenExpectation = self.expectationWithDescription(msg)
            do {
                try self.session?.getPublicMultiredditOfUsername("sonson_twit", completion: { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error.description)
                    case .Success(let multireddits):
                        isSucceeded = true
                        let publicMultiredditNameList = multireddits.map({$0.name})
                        ["mine", "english", "public_test"].forEach({
                            isSucceeded = isSucceeded && (publicMultiredditNameList.indexOf($0) != nil)
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
    
    func testAddSubredditFromMultireddit() {
        let targetSubreddits = ["swift", "redditdev"]
        guard let multireddit = self.createdMultireddit else { XCTFail("Error"); return }
        
        addSubredditToMultireddit(targetSubreddits[0], multireddit: multireddit)
        addSubredditToMultireddit(targetSubreddits[1], multireddit: multireddit)
        
        var candidates = getOwnMultireddit().filter({$0.name == multireddit.name})
        if candidates.count == 0 { XCTFail("Error"); return }
        let updatedMultireddit = candidates[0]
        XCTAssert(updatedMultireddit.subreddits.hasSameElements(targetSubreddits), "error")
    }
    
    func testAddSubredditFromMultiredditErrorCase() {
        let targetSubreddits = ["swift"]
        guard let multireddit = self.createdMultireddit else { XCTFail("Error"); return }
        
        addSubredditToMultireddit(targetSubreddits[0], multireddit: multireddit)
        
        let msg = "Test adding an inavaialbe subreddit to the multireddit."
        var isSucceeded:Bool = false
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.addSubredditToMultireddit(multireddit, subredditDisplayName: "ahfuhaofhaeiufaheihihfiuawe", completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    isSucceeded = (error.code == 400)
                case .Success:
                    print("OK...?")
                }
                XCTAssert(isSucceeded, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        
        var candidates = getOwnMultireddit().filter({$0.name == multireddit.name})
        if candidates.count == 0 { XCTFail("Error"); return }
        let updatedMultireddit = candidates[0]
        XCTAssert(updatedMultireddit.subreddits.hasSameElements(targetSubreddits), "error")
    }
    
    func testAddAndRemoveSubredditForMultireddit() {
        let targetSubreddits = ["swift", "redditdev"]
        guard let multireddit = self.createdMultireddit else { XCTFail("Error"); return }
        
        addSubredditToMultireddit(targetSubreddits[0], multireddit: multireddit)
        addSubredditToMultireddit(targetSubreddits[1], multireddit: multireddit)
        
        do {
            let msg = "Test adding and deleting an subreddit for the multireddit."
            print(msg)
            var isSucceeded:Bool = false
            let documentOpenExpectation = self.expectationWithDescription(msg)
            do {
                try self.session?.removeSubredditFromMultireddit(multireddit, subredditDisplayName: targetSubreddits[1], completion: { (result) -> Void in
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
        
        var candidates = getOwnMultireddit().filter({$0.name == multireddit.name})
        if candidates.count == 0 { XCTFail("Error"); return }
        let updatedMultireddit = candidates[0]
        XCTAssert(updatedMultireddit.subreddits.hasSameElements(["swift"]), "error")
    }
    
    func testAddAndRemoveSubredditForMultiredditErrorCase() {
        let targetSubreddits = ["swift", "redditdev"]
        guard let multireddit = self.createdMultireddit else { XCTFail("Error"); return }
        
        addSubredditToMultireddit(targetSubreddits[0], multireddit: multireddit)
        addSubredditToMultireddit(targetSubreddits[1], multireddit: multireddit)
        
        do {
            let msg = "Test adding and deleting an subreddit for the multireddit."
            print(msg)
            var isSucceeded:Bool = false
            let documentOpenExpectation = self.expectationWithDescription(msg)
            do {
                try self.session?.removeSubredditFromMultireddit(multireddit, subredditDisplayName: "ahfuhaofhaeiufaheihihfiuawe", completion: { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        isSucceeded = (error.code == 400)
                    case .Success:
                        print("OK...?")
                    }
                    XCTAssert(isSucceeded, msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            catch { XCTFail((error as NSError).description) }
        }
        
        var candidates = getOwnMultireddit().filter({$0.name == multireddit.name})
        if candidates.count == 0 { XCTFail("Error"); return }
        let updatedMultireddit = candidates[0]
        XCTAssert(updatedMultireddit.subreddits.hasSameElements(targetSubreddits), "error")
    }
}
