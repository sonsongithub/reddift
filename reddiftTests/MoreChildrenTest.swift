//
//  MoreChildrenTest.swift
//  reddift
//
//  Created by sonson on 2016/02/26.
//  Copyright © 2016年 sonson. All rights reserved.
//

import XCTest

class MoreChildrenTest: SessionTestSpec {
    
    /**
     Test procedure
     1. Get Link list from speficified Subreddit.
     2. Get the Link which has the most comments in the list.
     3. Get Comments and More from Link.
     4. Expand More objects.
    */
    func testGetMoreChildren() {
        
        guard let link = getTheMostCommentedLink("machinelearning") else { XCTFail("Get the Link that has the most comment."); return}
        
        var moreList:[More] = []
        
        do {
            let documentOpenExpectation = self.expectationWithDescription("")
            try session?.getArticles(link, sort: .New, comments: nil, limit: 50, completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error)
                case .Success(_, let listing):
                    let incomming = listing.children.flatMap({ $0 as? More})
                    moreList.appendContentsOf(incomming)
                }
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        catch { XCTFail((error as NSError).description) }
        
        XCTAssert(moreList.count > 0, "Cannot get More objects.")
        
        var check = true
        
        moreList.forEach({
            do {
                let documentOpenExpectation = self.expectationWithDescription("")
                try session?.getMoreChildren($0.children, link: link, sort: .New, completion: { (result) -> Void in
                    switch(result){
                    case .Failure(let error):
                        print(error)
                        check = false
                    case .Success(let list):
                        print(list)
                        if list.count == 0 {
                            check = false
                        }
                    }
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            catch { XCTFail((error as NSError).description) }
        })
        XCTAssert(check, "Cannot expand More objects.")
    }
}

extension MoreChildrenTest {
    /**
     Extract Link which has the most comment in the specified Subreddit.
    */
    func getTheMostCommentedLink(subredditName:String) -> Link? {
        var mostCommentsLink:Link? = nil
        do {
            let documentOpenExpectation = self.expectationWithDescription("")
            try session?.getList(Paginator(), subreddit: Subreddit(subreddit: subredditName), sort: .Top, timeFilterWithin: .Week) { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error)
                case .Success(let listing):
                    let links = listing.children.flatMap({$0 as? Link})
                    mostCommentsLink = links.reduce(links[0], combine: {
                        if $0.numComments < $1.numComments {
                            return $1
                        }
                        else {
                            return $0
                        }
                    })
                }
                documentOpenExpectation.fulfill()
            }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            
        }
        catch { XCTFail((error as NSError).description) }
        return mostCommentsLink
    }
}
