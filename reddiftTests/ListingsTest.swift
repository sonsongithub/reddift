//
//  ListingsTest.swift
//  reddift
//
//  Created by sonson on 2015/06/01.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Nimble
import Quick

class ListingsTest: SessionTestSpec {
    override func spec() {
        beforeEach { () -> () in
            self.createSession()
        }
        
        describe("Test to download links.") {
                let sortTypes:[LinkSortType] = [.Controversial, .Top, .Hot, .New]
                let timeFilterTypes:[TimeFilterWithin] = [.Hour, .Day, .Week, .Month, .Year, .All]
                var subreddit = Subreddit(id: "dummy")
                subreddit.displayName = "sandboxtest"
                for sortType in sortTypes {
                    for filter in timeFilterTypes {
                        it("Check whether the list which is obtained with \(sortType.description), \(filter.description) includes only Link object.") {
                            var isSucceeded = false
                            self.session?.getList(Paginator(), subreddit:subreddit, sort:sortType, timeFilterWithin:filter, completion: { (result) in
                                switch result {
                                case let .Failure:
                                    println(result.error)
                                case let .Success:
                                    if let listing = result.value as? Listing {
                                        isSucceeded = (listing.children.count > 0)
                                        for obj in listing.children {
                                            isSucceeded = isSucceeded && (obj is Link)
                                        }
                                    }
                                }
                            })
                            expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
                            NSThread.sleepForTimeInterval(self.testInterval)
                    }
                }
            }
        }
    
        describe("Test to download random links.") {
            it("Check whether the random list includes two Listings.") {
                var isSucceeded = false
                self.session?.getRandom(nil, completion: { (result) in
                    switch result {
                    case let .Failure:
                        println(result.error)
                    case let .Success:
                        if let array = result.value as? [Any] {
                            isSucceeded = (array.count == 2)
                            for obj in array {
                                isSucceeded = isSucceeded && (obj is Listing)
                            }
                            if isSucceeded {
                                if let listing = array[0] as? Listing {
                                    isSucceeded = isSucceeded && (listing.children.count == 1)
                                    isSucceeded = isSucceeded && (listing.children[0] is Link)
                                }
                                if let listing = array[1] as? Listing {
                                    isSucceeded = isSucceeded && (listing.children.count > 0)
                                    for obj in listing.children {
                                        isSucceeded = isSucceeded && (obj is Comment)
                                    }
                                }
                            }
                        }
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
                NSThread.sleepForTimeInterval(self.testInterval)
            }
        }

        describe("Test to download random links among the specified subreddit.") {
            it("Check whether the random list among the specified subreddit includes two Listings when using withoutLink = false.") {
                var isSucceeded = false
                var subreddit = Subreddit(id: "dummy")
                subreddit.displayName = "sandboxtest"
                self.session?.getRandom(subreddit, completion: { (result) in
                    switch result {
                    case let .Failure:
                        println(result.error)
                    case let .Success:
                        if let array = result.value as? [Any] {
                            isSucceeded = (array.count == 2)
                            for obj in array {
                                isSucceeded = isSucceeded && (obj is Listing)
                            }
                            if isSucceeded {
                                if let listing = array[0] as? Listing {
                                    isSucceeded = isSucceeded && (listing.children.count == 1)
                                    isSucceeded = isSucceeded && (listing.children[0] is Link)
                                }
                                if let listing = array[1] as? Listing {
                                    isSucceeded = isSucceeded && (listing.children.count > 0)
                                    for obj in listing.children {
                                        isSucceeded = isSucceeded && (obj is Comment)
                                    }
                                }
                            }
                        }
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
                NSThread.sleepForTimeInterval(self.testInterval)
            }
            
            it("Check whether the random list among the specified subreddit includes two Listings when using withoutLink = true.") {
                var isSucceeded = false
                var subreddit = Subreddit(id: "dummy")
                subreddit.displayName = "sandboxtest"
                self.session?.getRandom(subreddit, withoutLink:true, completion: { (result) in
                    switch result {
                    case let .Failure:
                        println(result.error)
                    case let .Success:
                        if let listing = result.value as? Listing {
                            isSucceeded = true
                            for obj in listing.children {
                                isSucceeded = isSucceeded && (obj is Comment)
                            }
                        }
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
                NSThread.sleepForTimeInterval(self.testInterval)
            }
        }
        
        let sortTypes:[CommentSort] = [.Confidence, .Top, .New, .Hot, .Controversial, .Old, .Random, .Qa]
        for sort in sortTypes {
            describe("Test to download artcles of the link which is selected randomly from redditdev subreddit, \(sort.description)") {
                it("Check whether the aritcles include one Listing when using withoutLink = true.") {
                    var link:Link? = nil
                    var subreddit = Subreddit(id: "dummy")
                    subreddit.displayName = "redditdev"
                    self.session?.getList(Paginator(), subreddit:subreddit, sort:.New, timeFilterWithin:.Week, completion: { (result) in
                        switch result {
                        case let .Failure:
                            println(result.error)
                        case let .Success:
                            if let listing = result.value as? Listing {
                                for obj in listing.children {
                                    if obj is Link {
                                        link = obj as? Link
                                        break
                                    }
                                }
                            }
                        }
                    })
                    expect(link != nil).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
                    
                    var isSucceeded = false
                    if let link = link {
                        self.session?.getArticles(link, sort:sort, withoutLink:true, completion: { (result) -> Void in
                            switch result {
                            case let .Failure:
                                println(result.error)
                            case let .Success:
                                if let listing = result.value as? Listing {
                                    isSucceeded = true
                                    for obj in listing.children {
                                        isSucceeded = isSucceeded && (obj is Comment)
                                    }
                                }
                            }
                        })
                    }
                    expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
                }
                
                it("Check whether the aritcles include one Listing when using withoutLink = false.") {
                    var link:Link? = nil
                    var subreddit = Subreddit(id: "dummy")
                    subreddit.displayName = "redditdev"
                    self.session?.getList(Paginator(), subreddit:subreddit, sort:.New, timeFilterWithin:.Week, completion: { (result) in
                        switch result {
                        case let .Failure:
                            println(result.error)
                        case let .Success:
                            if let listing = result.value as? Listing {
                                for obj in listing.children {
                                    if obj is Link {
                                        link = obj as? Link
                                        break
                                    }
                                }
                            }
                        }
                    })
                    expect(link != nil).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
                    
                    var isSucceeded = false
                    if let link = link {
                        self.session?.getArticles(link, sort: sort, completion: { (result) -> Void in
                            switch result {
                            case let .Failure:
                                println(result.error)
                            case let .Success:
                                if let array = result.value as? [Any] {
                                    isSucceeded = (array.count == 2)
                                    for obj in array {
                                        isSucceeded = isSucceeded && (obj is Listing)
                                    }
                                    if isSucceeded {
                                        if let listing = array[0] as? Listing {
                                            isSucceeded = isSucceeded && (listing.children.count == 1)
                                            isSucceeded = isSucceeded && (listing.children[0] is Link)
                                        }
                                        if let listing = array[1] as? Listing {
                                            isSucceeded = isSucceeded && (listing.children.count > 0)
                                            for obj in listing.children {
                                                isSucceeded = isSucceeded && (obj is Comment)
                                            }
                                        }
                                    }
                                }
                            }
                        })
                    }
                    expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
                }
            }
        }
    }
}
