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
    
    func testSubscribingSubredditAPI() {
        do {
            let msg = "Get initial subscribing list and count of it."
            print(msg)
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription(msg)
            self.session?.getUserRelatedSubreddit(.Subscriber, paginator:nil, completion: { (result) -> Void in
                switch result {
                case .Failure:
                    print(result.error!.description)
                case .Success:
                    if let listing = result.value as? Listing {
                        for obj in listing.children {
                            if let obj = obj as? Subreddit {
                                self.initialList.append(obj)
                            }
                        }
                        self.initialCount = self.initialList.count
                        isSucceeded = (self.initialCount > 0)
                    }
                }
                XCTAssert(isSucceeded, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        
        do {
            let msg = "Subscribe a new subreddit"
            print(msg)
            var isSucceeded:Bool = false
            let documentOpenExpectation = self.expectationWithDescription(msg)
            self.session?.setSubscribeSubreddit(self.targetSubreedit, subscribe: true, completion: { (result) -> Void in
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
        
        do {
            let msg = "Check count of current subscribing list is increased by one"
            print(msg)
            var afterSubscribingCount = 0
            let documentOpenExpectation = self.expectationWithDescription(msg)
            self.session?.getUserRelatedSubreddit(.Subscriber, paginator:nil, completion: { (result) -> Void in
                switch result {
                case .Failure:
                    print(result.error!.description)
                case .Success:
                    if let listing = result.value as? Listing {
                        for obj in listing.children {
                            if let obj = obj as? Subreddit {
                                self.afterSubscribingList.append(obj)
                            }
                        }
                        afterSubscribingCount = self.afterSubscribingList.count
                    }
                }
                XCTAssert(afterSubscribingCount == self.initialCount + 1, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        
        do {
            let msg = "Unsubscribe last subscribed subreddit"
            print(msg)
            var isSucceeded:Bool = false
            let documentOpenExpectation = self.expectationWithDescription(msg)
            self.session?.setSubscribeSubreddit(self.targetSubreedit, subscribe: false, completion: { (result) -> Void in
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
        
        do {
            let msg = "Check count of current subscribing list is equal to initial count."
            print(msg)
            var afterUnsubscribingCount = 0
            let documentOpenExpectation = self.expectationWithDescription(msg)
            self.session?.getUserRelatedSubreddit(.Subscriber, paginator:nil, completion: { (result) -> Void in
                switch result {
                case .Failure:
                    print(result.error!.description)
                case .Success:
                    if let listing = result.value as? Listing {
                        for obj in listing.children {
                            if let obj = obj as? Subreddit {
                                self.afterUnsubscribingList.append(obj)
                            }
                        }
                        afterUnsubscribingCount = self.afterUnsubscribingList.count
                    }
                }
                XCTAssert(afterUnsubscribingCount == self.initialCount, msg)
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
    }
}
