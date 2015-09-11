//
//  ExtendCommentsTest.swift
//  reddift
//
//  Created by sonson on 2015/04/28.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import XCTest

class ExtendCommentsTest: XCTestCase {
    func testListWhichHasSomeCommentsIncludingRepliesRecursively() {
        print("consists of 1 Link, 13 Comments and 9 Mores.")
        if let json:JSON = self.jsonFromFileName("comments_extend.json") {
            if let array = Parser.parseJSON(json) as? [Any] {
                if array.count == 2 {
                    if let listing = array[0] as? Listing {
                        let numberOfLinks = listing.children.reduce(0, combine: { (value:Int, link:Thing) -> Int in
                            return link is Link ? 1 + value : value
                        })
                        XCTAssert(numberOfLinks == 1)
                    }
                    else {
                        XCTFail("Error")
                    }
                    if let listing = array[1] as? Listing {
                        var comments:[Thing] = []
                        for thing in listing.children {
                            comments += extendAllReplies(thing)
                        }
                        let numberOfComments = comments.reduce(0, combine: { (value:Int, comment:Thing) -> Int in
                            return comment is Comment ? 1 + value : value
                        })
                        let numberOfMores = comments.reduce(0, combine: { (value:Int, comment:Thing) -> Int in
                            return comment is More ? 1 + value : value
                        })
                        XCTAssert(numberOfComments == 13)
                        XCTAssert(numberOfMores == 9)
                        XCTAssert(comments.count == 22)
                    }
                    else {
                        XCTFail("Error")
                    }
                }
                else {
                    XCTFail("Error")
                }
            }
            else {
                XCTFail("Error")
            }
        }
    }
}
