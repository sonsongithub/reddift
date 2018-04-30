//
//  SessionNoAuthTestSpec.swift
//  reddift
//
//  Created by sonson on 2015/08/08.
//  Copyright © 2015年 sonson. All rights reserved.
//

import XCTest

class SessionNoAuthTestSpec: XCTestCase {
    /// timeout duration for asynchronous test
    let timeoutDuration: TimeInterval = 30
    
    /// polling interval to check a value for asynchronous test
    let pollingInterval: TimeInterval = 1
    
    /// interval between tests for prevent test code from using API over limit rate.
    let testInterval: TimeInterval = 1
    
    /// shared session object
    var session: Session?
    
    override func setUp() {
        super.setUp()
        session = Session()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDownloadFrontPageWithoutOAuth() {
        var isSucceeded = false
        let documentOpenExpectation = self.expectation(description: "")
        do {
            try session?.getList(Paginator(), subreddit: nil, sort: .controversial, timeFilterWithin: .week) { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success:
                    isSucceeded = true
                }
                documentOpenExpectation.fulfill()
            }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
            XCTAssert(isSucceeded, "Check whether front page without any authentication.")
        } catch { XCTFail((error as NSError).description) }
    }
    
    func testDownloadSubredditListWithoutOAuth() {
        var isSucceeded = false
        let documentOpenExpectation = self.expectation(description: "")
        do {
            try session?.getList(Paginator(), subreddit: Subreddit(subreddit: "swift"), sort: .controversial, timeFilterWithin: .week) { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success:
                    isSucceeded = true
                }
                documentOpenExpectation.fulfill()
            }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
            XCTAssert(isSucceeded, "Check whether the link list of the subreddit without any authentication.")
        } catch { XCTFail((error as NSError).description) }
    }
    
    func testDownloadListAndContentWithoutOAuth() {
        var isSucceeded = true
        let documentOpenExpectation = self.expectation(description: "")
        do {
            try session?.getList(Paginator(), subreddit: Subreddit(subreddit: "swift"), sort: .controversial, timeFilterWithin: .week) { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                    isSucceeded = false
                case .success(let listing):
                    if let link = listing.children.first as? Link {
                        do {
                            try self.session?.getArticles(link, sort: CommentSort.new, completion: { (result) -> Void in
                                switch result {
                                case .failure(let error):
                                    print(error)
                                    isSucceeded = false
                                case .success:
                                    do {}
//                                    print(listing1)
//                                    print(listing2)
//                                    for child in listing1.children {
//                                        print(type(of: child))
//                                    }
//                                    for child in listing2.children {
//                                        print(type(of: child))
//                                    }
                                }
                                documentOpenExpectation.fulfill()
                            })
                        } catch { XCTFail((error as NSError).description) }
                    }
                }
            }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
            XCTAssert(isSucceeded, "Check whether comments can be downloaded from the link list of the subreddit without any authentication.")
        } catch { XCTFail((error as NSError).description) }
    }
}
