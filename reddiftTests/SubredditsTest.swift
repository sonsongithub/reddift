//
//  SubredditsTest.swift
//  reddift
//
//  Created by sonson on 2015/05/25.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import XCTest

class SubredditsTest : SessionTestSpec {
    
    var initialList:[Subreddit] = []
    var initialCount = 0
    
    var afterSubscribingList:[Subreddit] = []
    
    var afterUnsubscribingList:[Subreddit] = []
    
    let targetSubreedit = Subreddit(id: "2rdw8")
    
    func userList(subreddit:Subreddit, aboutWhere:SubredditAbout) -> [Thing] {
        var list:[Thing] = []
        let msg = "Get initial subscribing list and count of it."
        var isSucceeded = false
        let documentOpenExpectation = self.expectationWithDescription(msg)
        do {
            try self.session?.about(subreddit, paginator:nil, aboutWhere:aboutWhere, completion: { (result) -> Void in
                switch result {
                case .Failure:
                    print(result.error!.description)
                case .Success(let listing):
                    print(listing)
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        return list
    }
    
    func testAbout() {
        /**
         This endpoint is a listing.
         */
        let subreddit = Subreddit(subreddit: "newsokur")
        userList(subreddit, aboutWhere: .Banned)
        userList(subreddit, aboutWhere: .Muted)
        userList(subreddit, aboutWhere: .Contributors)
        userList(subreddit, aboutWhere: .Moderators)
        userList(subreddit, aboutWhere: .Wikibanned)
        userList(subreddit, aboutWhere: .Wikicontributors)
    }
    
    func testSubscribingSubredditAPI() {
        do {
            let msg = "Get initial subscribing list and count of it."
            print(msg)
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription(msg)
            do {
                try self.session?.getUserRelatedSubreddit(.Subscriber, paginator:nil, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success(let listing):
                        for obj in listing.children {
                            if let obj = obj as? Subreddit {
                                self.initialList.append(obj)
                            }
                        }
                        self.initialCount = self.initialList.count
                        isSucceeded = (self.initialCount > 0)
                    }
                    XCTAssert(isSucceeded, msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            catch { XCTFail((error as NSError).description) }
        }
        
        do {
            let msg = "Subscribe a new subreddit"
            print(msg)
            var isSucceeded:Bool = false
            let documentOpenExpectation = self.expectationWithDescription(msg)
            do {
                try self.session?.setSubscribeSubreddit(self.targetSubreedit, subscribe: true, completion: { (result) -> Void in
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
            catch { XCTFail((error as NSError).description) }
        }
        
        do {
            let msg = "Check count of current subscribing list is increased by one"
            print(msg)
            var afterSubscribingCount = 0
            let documentOpenExpectation = self.expectationWithDescription(msg)
            do {
                try self.session?.getUserRelatedSubreddit(.Subscriber, paginator:nil, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success(let listing):
                        for obj in listing.children {
                            if let obj = obj as? Subreddit {
                                self.afterSubscribingList.append(obj)
                            }
                        }
                        afterSubscribingCount = self.afterSubscribingList.count
                    }
                    XCTAssert(afterSubscribingCount == self.initialCount + 1, msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            catch { XCTFail((error as NSError).description) }
        }
        
        do {
            let msg = "Unsubscribe last subscribed subreddit"
            print(msg)
            var isSucceeded:Bool = false
            let documentOpenExpectation = self.expectationWithDescription(msg)
            do {
                try self.session?.setSubscribeSubreddit(self.targetSubreedit, subscribe: false, completion: { (result) -> Void in
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
            catch { XCTFail((error as NSError).description) }
        }
        
        do {
            let msg = "Check count of current subscribing list is equal to initial count."
            print(msg)
            var afterUnsubscribingCount = 0
            let documentOpenExpectation = self.expectationWithDescription(msg)
            do {
                try self.session?.getUserRelatedSubreddit(.Subscriber, paginator:nil, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success(let listing):
                        for obj in listing.children {
                            if let obj = obj as? Subreddit {
                                self.afterUnsubscribingList.append(obj)
                            }
                        }
                        afterUnsubscribingCount = self.afterUnsubscribingList.count
                    }
                    XCTAssert(afterUnsubscribingCount == self.initialCount, msg)
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            catch { XCTFail((error as NSError).description) }
        }
    }
}
