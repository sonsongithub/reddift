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
        var list: [Subreddit] = []
        let msg = "Get own subscribing list."
        let documentOpenExpectation = self.expectation(description: msg)
        do {
            try self.session?.getUserRelatedSubreddit(.subscriber, paginator: Paginator(), completion: { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let listing):
                    list = listing.children.compactMap({$0 as? Subreddit})
                }
                XCTAssert(list.count > 0, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
        return list
    }
    
    @discardableResult
    func userList(_ subreddit: Subreddit, aboutWhere: SubredditAbout) -> [User] {
        var list: [User] = []
        let msg = "Get user list and count of it, \(subreddit.name), \(aboutWhere.rawValue)."
        var isSucceeded = false
        let documentOpenExpectation = self.expectation(description: msg)
        do {
            try self.session?.about(subreddit, aboutWhere: aboutWhere, completion: { (result) -> Void in
                switch result {
                case .failure(let error):
                    if error.code != HttpStatus.forbidden.rawValue { print(error) }
                    // if list is vancat, return error code 400.
                    isSucceeded = (error.code == HttpStatus.forbidden.rawValue)
                case .success(let users):
                    list.append(contentsOf: users)
                    isSucceeded = (list.count > 0)
                }
                XCTAssert(isSucceeded, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
        return list
    }
}

class SubredditsTest: SessionTestSpec {
    /**
     Test procedure
     1. Get recommended subreddits for apple and swift.
     */
    func testRecommendSubreddit() {
        var names: [String] = []
        let srnames = ["apple", "swift"]
        let msg = "Get recommended subreddits for \(srnames.joined(separator: ","))"
        let documentOpenExpectation = self.expectation(description: msg)
        do {
            try self.session?.recommendedSubreddits([], srnames: srnames, completion: { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let obj):
                    names.append(contentsOf: obj)
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
        XCTAssert(names.count > 0, msg)
    }
    
    /**
     Test procedure
     1. Get submit text of apple subreddit.
     */
    func testGetSubredditSubmitTxt() {
        var submitText: String? = nil
        let subredditName = "apple"
        let msg = "Get submit text of \(subredditName)"
        let documentOpenExpectation = self.expectation(description: msg)
        do {
            try self.session?.getSubmitText(subredditName, completion: { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let obj):
                    submitText = obj
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
        XCTAssert(submitText != nil, msg)
    }
    
    /**
     Test procedure
     1. Get informations of apple subreddit.
     */
    func testGetAbountOfSpecifiedSubreddit() {
        let subredditName = "apple"
        var subreddit: Subreddit? = nil
        let msg = "Get informations of \(subredditName)"
        let documentOpenExpectation = self.expectation(description: msg)
        do {
            try self.session?.about(subredditName, completion: { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let obj):
                    subreddit = obj
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
        XCTAssert(subreddit != nil, msg)
    }
    
    /**
     Test procedure
    */
    func testSearchSubreddit() {
        var subreddits: [Subreddit] = []
        let query = "apple"
        let msg = "Search subreddit used of \(query)"
        let documentOpenExpectation = self.expectation(description: msg)
        do {
            try self.session?.getSubredditSearch(query, paginator: Paginator(), completion: { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let listing):
                    subreddits.append(contentsOf: listing.children.compactMap({$0 as? Subreddit}))
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
        XCTAssert(subreddits.count > 0, msg)
//        subreddits.forEach {print($0.title)}
    }
    
    /**
     Test procedure
     1. Search subreddit names.
    */
    func testSearchSubredditNames() {
        var names: [String] = []
        let query = "apple"
        let msg = "Search subreddit name used of \(query)"
        let documentOpenExpectation = self.expectation(description: msg)
        do {
            try self.session?.searchRedditNames(query, completion: { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let obj):
                    names.append(contentsOf: obj)
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
        XCTAssert(names.count > 0, msg)
    }
    
    /**
     Test procedure
     1. Search subreddit by swift
     */
//    func testSearchSubredditsByQuery() {
//        var subredditNames: [String] = []
//        let query = "apple"
//        let msg = "Search subreddits by \(query)"
//        let documentOpenExpectation = self.expectation(description: msg)
//        do {
//            try self.session?.searchSubredditsByTopic(query, completion: { (result) -> Void in
//                switch result {
//                case .failure(let error):
//                    print(error)
//                case .success(let names):
//                    subredditNames.append(contentsOf: names)
//                }
//                documentOpenExpectation.fulfill()
//            })
//            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
//        } catch { XCTFail((error as NSError).description) }
//        XCTAssert(subredditNames.count > 0, msg)
//    }
    
    /**
     Test procedure
     1. Search subreddit by 日本
     */
//    func testSearchSubredditsByJapaneseQuery() {
//        var subredditNames: [String] = []
//        let query = "日本"
//        let msg = "Search subreddits by \(query)"
//        let documentOpenExpectation = self.expectation(description: msg)
//        do {
//            try self.session?.searchSubredditsByTopic(query, completion: { (result) -> Void in
//                switch result {
//                case .failure(let error):
//                    print(error)
//                case .success(let names):
//                    subredditNames.append(contentsOf: names)
//                }
//                documentOpenExpectation.fulfill()
//            })
//            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
//        } catch { XCTFail((error as NSError).description) }
//        XCTAssert(subredditNames.count > 0, msg)
//    }
    
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
            userList(subreddit, aboutWhere: .banned)
            userList(subreddit, aboutWhere: .muted)
            userList(subreddit, aboutWhere: .contributors)
            userList(subreddit, aboutWhere: .moderators)
            userList(subreddit, aboutWhere: .wikibanned)
            userList(subreddit, aboutWhere: .wikicontributors)
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
            var isSucceeded = false
            let documentOpenExpectation = self.expectation(description: msg)
            do {
                try self.session?.setSubscribeSubreddit(targetSubreedit, subscribe: true, completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
            } catch { XCTFail((error as NSError).description) }
        }
        let intermediateList = subscribingList()
        
        do {
            let msg = "Unsubscribe last subscribed subreddit, \(targetSubreedit.id)"
            var isSucceeded = false
            let documentOpenExpectation = self.expectation(description: msg)
            do {
                try self.session?.setSubscribeSubreddit(targetSubreedit, subscribe: false, completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
            } catch { XCTFail((error as NSError).description) }
        }
        let finalList = subscribingList()
        
        // Create ID List for check
        let initialIDList = initialList.map({$0.id})
        let intermediateIDList = intermediateList.map({$0.id})
        let finalIDList = finalList.map({$0.id})
        
        XCTAssert((initialIDList + [targetSubreeditID]).hasSameElements(intermediateIDList))
        XCTAssert(initialIDList.hasSameElements(finalIDList))
    }
    
//    func testToGetSticky() {
//        print("Test to get the stickied content of the specified Subreddit")
//        let targetSubreedit = Subreddit(subreddit: "idolgazou")
//        
//        do {
//            let msg = ""
//            var isSucceeded = false
//            let documentOpenExpectation = self.expectation(description: msg)
//            do {
//                try self.session?.getSticky(targetSubreedit, completion: { (result) in
//                    switch result {
//                    case .failure(let error):
//                        print(error)
//                    case .success(let obj):
//                        print(obj)
//                    }
//                    XCTAssert(isSucceeded, msg)
//                    documentOpenExpectation.fulfill()
//                })
//                self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
//            } catch { XCTFail((error as NSError).description) }
//        }
//    }
}
