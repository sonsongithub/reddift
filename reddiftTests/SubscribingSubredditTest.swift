//
//  SubscribingSubredditTest.swift
//  reddift
//
//  Created by sonson on 2015/05/09.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Nimble
import Quick

class SubscribingSubredditTest: SessionTestSpec {
    
    var initialList:[Subreddit] = []
    var initialCount = 0
    
    var afterSubscribingList:[Subreddit] = []
    
    var afterUnsubscribingList:[Subreddit] = []
    
    let targetSubreedit = Subreddit(id: "2rdw8", kind: "t5")

    override func spec() {
        beforeEach { () -> () in
            self.createSession()
        }
        describe("Test subscribing a subreddit API.") {
            it("Get initial subscribing list and count of it.") {
                var isSucceeded = false
                self.session?.getUserRelatedSubreddit(.Subscriber, paginator:nil, completion: { (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        if let listing = result.value as? Listing {
                            if let children = listing.children as? [Subreddit] {
                                self.initialList = children
                                self.initialCount = self.initialList.count
                                isSucceeded = (self.initialCount > 0)
                            }
                        }
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
        
            it("Subscribe a new subreddit") {
                var r:Bool = false
                self.session?.setSubscribeSubreddit(self.targetSubreedit, subscribe: true, completion: { (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        r = true
                    }
                })
                expect(r).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
    
            it("Check count of current subscribing list is increased by one") {
                var afterSubscribingCount = 0
                self.session?.getUserRelatedSubreddit(.Subscriber, paginator:nil, completion: { (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        if let listing = result.value as? Listing {
                            if let children = listing.children as? [Subreddit] {
                                self.afterSubscribingList = children
                                afterSubscribingCount = self.afterSubscribingList.count
                            }
                        }
                    }
                })
                expect(afterSubscribingCount).toEventually(equal(self.initialCount + 1), timeout: 10, pollInterval: 1)
            }
        
            it("Unsubscribe last subscribed subreddit") {
                var r:Bool = false
                self.session?.setSubscribeSubreddit(self.targetSubreedit, subscribe: false, completion: { (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        r = true
                    }
                })
                expect(r).toEventually(equal(true), timeout: 10, pollInterval: 1)
            }
            
            it("Check count of current subscribing list is equal to initial count.") {
                var afterUnsubscribingCount = 0
                self.session?.getUserRelatedSubreddit(.Subscriber, paginator:nil, completion: { (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        if let listing = result.value as? Listing {
                            if let children = listing.children as? [Subreddit] {
                                self.afterUnsubscribingList = children
                                afterUnsubscribingCount = self.afterUnsubscribingList.count
                            }
                        }
                    }
                })
                expect(afterUnsubscribingCount).toEventually(equal(self.initialCount), timeout: 10, pollInterval: 1)
            }
        }
    }
    
}
