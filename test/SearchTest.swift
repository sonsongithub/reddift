//
//  SearchTest.swift
//  reddift
//
//  Created by sonson on 2015/06/01.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import XCTest

class SearchTest: SessionTestSpec {
    
    /**
     Test procedure
     */
    func testSearch() {
        var links: [Link] = []
        let query = "apple"
        let msg = "Search subreddit name used of \(query)"
        let documentOpenExpectation = self.expectation(description: msg)
        let subreddit = Subreddit(subreddit: "apple")
        
        do {
            try self.session?.getSearch(subreddit, query: query, paginator: Paginator(), sort: .new, completion: { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let listing):
                    links.append(contentsOf: listing.children.compactMap { $0 as? Link })
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        } catch { XCTFail((error as NSError).description) }
        XCTAssert(links.count > 0, msg)
    }
    
}
