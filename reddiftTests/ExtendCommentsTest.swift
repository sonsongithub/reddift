//
//  ExtendCommentsTest.swift
//  reddift
//
//  Created by sonson on 2015/04/28.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import XCTest

class ExtendCommentsTest: XCTestCase {
    
    let gt_type: [(Any.Type, Int)] = [
        (Comment.self,  1),
        (Comment.self,  2),
        (More.self,     3),
        (Comment.self,  2),
        (More.self,     3),
        (Comment.self,  1),
        (Comment.self,  2),
        (More.self,     3),
        (Comment.self,  1),
        (Comment.self,  2),
        (More.self,     3),
        (Comment.self,  2),
        (More.self,     3),
        (Comment.self,  1),
        (Comment.self,  2),
        (More.self,     3),
        (Comment.self,  2),
        (More.self,     3),
        (Comment.self,  2),
        (More.self,     3),
        (Comment.self,  2),
        (More.self,     3)
    ]
    
    /**
     test data
     comment
        comment
            more
        comment
            more
     comment
        comment
            more
     comment
        comment
            more
        comment
            more
     comment
        comment
            more
        comment
            more
        comment
            more
        comment
            more
    */
    func testListWhichHasSomeCommentsIncludingRepliesRecursively() {
        print("Test whether Parser can extend Comment objects that has some More objects as children.")
        print("consists of 1 Link, 13 Comments and 9 Mores.")
        if let json: JSON = self.jsonFromFileName("comments_extend.json") {
            if let array = Parser.parseJSON(json) as? [Any] {
                if array.count == 2 {
                    if let listing = array[0] as? Listing {
                        let numberOfLinks = listing.children.reduce(0, combine: { (value: Int, link: Thing) -> Int in
                            return link is Link ? 1 + value : value
                        })
                        XCTAssert(numberOfLinks == 1)
                    } else {
                        XCTFail("Error")
                    }
                    if let listing = array[1] as? Listing {
                        var comments: [Thing] = []
                        var depths: [Int] = []
                        for thing in listing.children {
                            let (c, d) = extendAllRepliesAndDepth(thing, depth:1)
                            comments += c
                            depths += d
                        }
                        XCTAssert(comments.count == depths.count, "list is mulformed.")
                        XCTAssert(gt_type.count == comments.count, "list is mulformed.")
                        
                        for i in 0 ..< comments.count {
                            let (c, d) = gt_type[i]
                            XCTAssert(c == comments[i].dynamicType, "data type error.")
                            XCTAssert(d == depths[i], "element's depth is wrong.")
                        }
                    } else {
                        XCTFail("Error")
                    }
                } else {
                    XCTFail("Error")
                }
            } else {
                XCTFail("Error")
            }
        }
    }
}
