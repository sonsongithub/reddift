//
//  SubredditsTest.swift
//  reddift
//
//  Created by sonson on 2015/05/25.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import XCTest

extension SubredditsTest {
    func subscribingList() -> [Subreddit] {
        var list:[Subreddit] = []
        let msg = "Get own subscribing list."
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.getUserRelatedSubreddit(.Subscriber, paginator:nil, completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error)
                case .Success(let listing):
                    list = listing.children.flatMap({$0 as? Subreddit})
                }
                XCTAssert(list.count > 0, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        return list
    }
    
    func userList(subreddit:Subreddit, aboutWhere:SubredditAbout) -> [User] {
        var list:[User] = []
        let msg = "Get user list and count of it, \(subreddit.name), \(aboutWhere.rawValue)."
        var isSucceeded = false
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.about(subreddit, aboutWhere:aboutWhere, completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    if error.code != 403 { print(error) }
                    // if list is vancat, return error code 400.
                    isSucceeded = (error.code == 403)
                case .Success(let users):
                    list.appendContentsOf(users)
                    isSucceeded = (list.count > 0)
                }
                XCTAssert(isSucceeded, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        return list
    }
}

class SubredditsTest : SessionTestSpec {
    /**
     Test procedure
     1. Get informations of apple subreddit.
     */
    func testGetSubredditSubmitTxt() {
        var submitText:String? = nil
        let subredditName = "apple"
        let msg = "Get submit text of \(subredditName)"
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.getSubmitText(subredditName, completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error)
                case .Success(let obj):
                    submitText = obj
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        XCTAssert(submitText != nil, msg)
    }
    
    /**
     Test procedure
     1. Get informations of apple subreddit.
    */
    func testGetAbountOfSpecifiedSubreddit() {
        let subredditName = "apple"
        var subreddit:Subreddit? = nil
        let msg = "Get informations of \(subredditName)"
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.about(subredditName, completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error)
                case .Success(let obj):
                    subreddit = obj
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        XCTAssert(subreddit != nil, msg)
    }
    
    /**
     Test procedure
     1. Search subreddit by swift
     */
    func testSearchSubredditsByQuery() {
        var subredditNames:[String] = []
        let query = "sift"
        let msg = "Search subreddits by \(query)"
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.searchSubredditsByTopic(query, completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error)
                case .Success(let names):
                    subredditNames.appendContentsOf(names)
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        XCTAssert(subredditNames.count > 0, msg)
    }
    
    /**
     Test procedure
     1. Search subreddit by 日本
     */
    func testSearchSubredditsByJapaneseQuery() {
        var subredditNames:[String] = []
        let query = "日本"
        let msg = "Search subreddits by \(query)"
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.searchSubredditsByTopic(query, completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error)
                case .Success(let names):
                    subredditNames.appendContentsOf(names)
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        XCTAssert(subredditNames.count > 0, msg)
    }
    
    /**
     Test procedure
     1. Iterate following steps for 5 subreddits.
     2. Get banned user list of the specified subreddit.
     3. Get muted user list of the specified subreddit.
     4. Get contribuator list of the specified subreddit.
     5. Get moderator list of the specified subreddit.
     6. Get wiki banned user list of the specified subreddit.
     7. Get wiki contribuator list of the specified subreddit.
     */
    func testGettingUserListAboutSubreddit() {
        ["pics", "youtube", "swift", "newsokur", "funny"].forEach({
            let subreddit = Subreddit(subreddit: $0)
            userList(subreddit, aboutWhere: .Banned)
            userList(subreddit, aboutWhere: .Muted)
            userList(subreddit, aboutWhere: .Contributors)
            userList(subreddit, aboutWhere: .Moderators)
            userList(subreddit, aboutWhere: .Wikibanned)
            userList(subreddit, aboutWhere: .Wikicontributors)
        })
    }
    
    /**
     Test procedure
     1. Get initilai subscribing subredits.
     2. Subscribe specified subreddit whose ID is targetSubreeditID.
     3. Get intermediate subscribing subredits.
     4. UnSsbscribe specified subreddit whose ID is targetSubreeditID.
     5. Get final subscribing subredits.
     6. Check wheter intermediate list and targetSubreeditID is equal to initilai list.
     7. Check wheter final list is equal to initilai list.
     */
    func testSubscribingSubredditAPI() {
        let targetSubreeditID = "2rdw8"
        let targetSubreedit = Subreddit(id: targetSubreeditID)
        
        let initialList = subscribingList()
        
        do {
            let msg = "Subscribe a new subreddit, \(targetSubreedit.id)"
            var isSucceeded:Bool = false
            let documentOpenExpectation = self.expectationWithDescription(msg)
            do {
                try self.session?.setSubscribeSubreddit(targetSubreedit, subscribe: true, completion: { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error)
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
        let intermediateList = subscribingList()
        
        do {
            let msg = "Unsubscribe last subscribed subreddit, \(targetSubreedit.id)"
            var isSucceeded:Bool = false
            let documentOpenExpectation = self.expectationWithDescription(msg)
            do {
                try self.session?.setSubscribeSubreddit(targetSubreedit, subscribe: false, completion: { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error)
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
        let finalList = subscribingList()
        
        // Create ID List for check
        let initialIDList = initialList.map({$0.id})
        let intermediateIDList = intermediateList.map({$0.id})
        let finalIDList = finalList.map({$0.id})
        
        XCTAssert((initialIDList + [targetSubreeditID]).hasSameElements(intermediateIDList))
        XCTAssert(initialIDList.hasSameElements(finalIDList))
    }
}
