//
//  ListingsTest.swift
//  reddift
//
//  Created by sonson on 2015/06/01.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import XCTest

class ListingsTest: SessionTestSpec {
    
    let localTestTimeInterval = Double(5)

    func testDownloadLinks() {
        let sortTypes: [LinkSortType] = [.controversial, .top, .hot, .new]
        let timeFilterTypes: [TimeFilterWithin] = [.hour, .day, .week, .month, .year, .all]
        let subreddit = Subreddit(subreddit: "sandboxtest")
        for sortType in sortTypes {
            for filter in timeFilterTypes {

                Thread.sleep(forTimeInterval: localTestTimeInterval)

                print("Check whether the list which is obtained with \(sortType.description), \(filter.description) includes only Link object.")
                let documentOpenExpectation = self.expectation(description: "Check whether the list which is obtained with \(sortType.description), \(filter.description) includes only Link object.")
                var isSucceeded = false
                do {
                    try self.session?.getList(Paginator(), subreddit: subreddit, sort: sortType, timeFilterWithin: filter, completion: { (result) in
                        switch result {
                        case .failure(let error):
                            print(error)
                        case .success(let listing):
                            isSucceeded = (listing.children.count >= 0)
                            for obj in listing.children {
                                isSucceeded = isSucceeded && (obj is Link)
                            }
                        }
                        XCTAssert(isSucceeded, "Check whether the list which is obtained with \(sortType.description), \(filter.description) includes only Link object.")
                        documentOpenExpectation.fulfill()
                    })
                    self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
                } catch { XCTFail((error as NSError).description) }
            }
        }
    }
    
    /**
     Check whether the random list includes two Listings. Why this test is always failed...?
    */
    func testDownloadRandomLinks() {
        let documentOpenExpectation = self.expectation(description: "Check whether the random list includes two Listings.")
        do {
            try self.session?.getRandom(completion: { (result) in
                var isSucceeded = false
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let tuple):
                    isSucceeded = (tuple.0.children.count == 1)
                    isSucceeded = isSucceeded && (tuple.0.children[0] is Link)
                    isSucceeded = isSucceeded && (tuple.1.children.count > 0)
                    for obj in tuple.1.children {
                        isSucceeded = isSucceeded && (obj is Comment)
                    }
                }
                XCTAssert(isSucceeded, "Check whether the random list includes two Listings. Why this test is always failed...?")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
    }
    
    func testDownloadRandomLinksAmongSpecifiedSubreddit() {
        let documentOpenExpectation = self.expectation(description: "Check whether the random list among the specified subreddit includes two Listings when using withoutLink = false.")

        var isSucceeded = false
        let subreddit = Subreddit(subreddit: "sandboxtest")
        do {
            try self.session?.getRandom(subreddit, completion: { (result) in
                switch result {
                case .failure(let error):
                    print(error.description)
                case .success(let tuple):
                    isSucceeded = (tuple.0.children.count == 1)
                    isSucceeded = isSucceeded && (tuple.0.children[0] is Link)
                    isSucceeded = isSucceeded && (tuple.1.children.count >= 0)
                    for obj in tuple.1.children {
                        isSucceeded = isSucceeded && (obj is Comment)
                    }
                }
                XCTAssert(isSucceeded, "Check whether the random list among the specified subreddit includes two Listings when using withoutLink = false.")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
    }
    
    func testDownloadArticlesOfLinkWhichIsSelectedRandomlyFromTheSubreddit() {
        let sortTypes: [CommentSort] = [.confidence, .top, .new, .hot, .controversial, .old, .random, .qa]
        for sort in sortTypes {
            Thread.sleep(forTimeInterval: localTestTimeInterval)
            var link: Link? = nil
            do {
                print("Test to download artcles of the link which is selected randomly from redditdev subreddit, \(sort.description)")
                let documentOpenExpectation = self.expectation(description: "Test to download artcles of the link which is selected randomly from redditdev subreddit, \(sort.description)")
                let subreddit = Subreddit(subreddit: "redditdev")
                try self.session?.getList(Paginator(), subreddit: subreddit, sort: .new, timeFilterWithin: .week, completion: { (result) in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let listing):
                        for obj in listing.children {
                            if obj is Link {
                                link = obj as? Link
                                break
                            }
                        }
                    }
                    XCTAssert(link != nil, "Check whether the aritcles include one Listing when using withoutLink = true.")
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
            } catch { XCTFail((error as NSError).description) }
            
            do {
                let documentOpenExpectation = self.expectation(description: "Test to download artcles of the link which is selected randomly from redditdev subreddit, \(sort.description)")
                if let link = link {
                    try self.session?.getArticles(link, sort: sort, completion: { (result) -> Void in
                        var isSucceeded = false
                        switch result {
                        case .failure:
                            print("\(String(describing: result.error))")
                        case .success(let tuple):
                            isSucceeded = true
                            for obj in tuple.1.children {
                                isSucceeded = isSucceeded && (obj is Comment)
                            }
                        }
                        XCTAssert(isSucceeded, "Check whether the aritcles include one Listing when using withoutLink = true.")
                        documentOpenExpectation.fulfill()
                    })
                    self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
                }
            } catch { XCTFail((error as NSError).description) }
        }
    }
}
