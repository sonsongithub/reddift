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
                            for obj in listing.children {
                                if let obj = obj as? Subreddit {
                                    self.initialList.append(obj)
                                }
                            }
                            self.initialCount = self.initialList.count
                            isSucceeded = (self.initialCount > 0)
                        }
                    }
                    NSThread.sleepForTimeInterval(self.testInterval)
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
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
                    NSThread.sleepForTimeInterval(self.testInterval)
                })
                expect(r).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
    
            it("Check count of current subscribing list is increased by one") {
                var afterSubscribingCount = 0
                self.session?.getUserRelatedSubreddit(.Subscriber, paginator:nil, completion: { (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        if let listing = result.value as? Listing {
                            for obj in listing.children {
                                if let obj = obj as? Subreddit {
                                    self.afterSubscribingList.append(obj)
                                }
                            }
                            afterSubscribingCount = self.afterSubscribingList.count
                        }
                    }
                    NSThread.sleepForTimeInterval(self.testInterval)
                })
                expect(afterSubscribingCount).toEventually(equal(self.initialCount + 1), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
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
                    NSThread.sleepForTimeInterval(self.testInterval)
                })
                expect(r).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Check count of current subscribing list is equal to initial count.") {
                var afterUnsubscribingCount = 0
                self.session?.getUserRelatedSubreddit(.Subscriber, paginator:nil, completion: { (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        if let listing = result.value as? Listing {
                            for obj in listing.children {
                                if let obj = obj as? Subreddit {
                                    self.afterUnsubscribingList.append(obj)
                                }
                            }
                            afterUnsubscribingCount = self.afterUnsubscribingList.count
                        }
                    }
                    NSThread.sleepForTimeInterval(self.testInterval)
                })
                expect(afterUnsubscribingCount).toEventually(equal(self.initialCount), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
        }
    }
    
}
