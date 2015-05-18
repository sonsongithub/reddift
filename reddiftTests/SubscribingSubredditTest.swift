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
    var subscribedList:[Subreddit] = []
    var unsubscribedList:[Subreddit] = []
    let targetSubreedit = Subreddit(id: "2rdw8", kind: "t5")

    override func spec() {
        beforeEach { () -> () in
            self.createSession()
        }
            describe("Test subscribing a subreddit API.") {
                it("Get initial subscribing list, to initialList") {
                    var r:Bool = false
					self.session?.getUserRelatedSubreddit(.Subscriber, paginator:nil, completion: { (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error!.description)
                        case let .Success:
                            if let listing = result.value as? Listing {
                                if let children = listing.children as? [Subreddit] {
                                    self.initialList = children
                                }
                            }
                            r = true
                        }
                    })
                    expect(r).toEventually(equal(true), timeout: 10, pollInterval: 1)
                }
            
                it("Subscribenew subreddit") {
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
        
                it("subscribedList.count is one more than initialList.count") {
                    var r:Bool = false
                    self.session?.getUserRelatedSubreddit(.Subscriber, paginator:nil, completion: { (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error!.description)
                        case let .Success:
                            if let listing = result.value as? Listing {
                                if let children = listing.children as? [Subreddit] {
                                    self.subscribedList = children
                                }
                            }
                            r = true
                        }
                    })
                    expect(r).toEventually(equal(true), timeout: 10, pollInterval: 1)
                    expect(self.initialList.count + 1).toEventually(equal(self.subscribedList.count), timeout: 10, pollInterval: 1)
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
        
                it("unsubscribedList.count is equal to initialList.count") {
                    var r:Bool = false
                    self.session?.getUserRelatedSubreddit(.Subscriber, paginator:nil, completion: { (result) -> Void in
                        switch result {
                        case let .Failure:
                            println(result.error!.description)
                        case let .Success:
                            if let listing = result.value as? Listing {
                                if let children = listing.children as? [Subreddit] {
                                    self.unsubscribedList = children
                                }
                            }
                            r = true
                        }
                    })
                    expect(r).toEventually(equal(true), timeout: 10, pollInterval: 1)
                    expect(self.initialList.count).toEventually(equal(self.unsubscribedList.count), timeout: 10, pollInterval: 1)
                }
            }
        }
    
}
