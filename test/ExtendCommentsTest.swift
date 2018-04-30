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
        (Comment.self, 1),
        (Comment.self, 2),
        (More.self, 3),
        (Comment.self, 2),
        (More.self, 3),
        (Comment.self, 1),
        (Comment.self, 2),
        (More.self, 3),
        (More.self, 3),
        (Comment.self, 1),
        (Comment.self, 2),
        (More.self, 3),
        (Comment.self, 2),
        (More.self, 3),
        (Comment.self, 1),
        (Comment.self, 2),
        (More.self, 3),
        (Comment.self, 2),
        (More.self, 3),
        (Comment.self, 2),
        (More.self, 3),
        (Comment.self, 2),
        (More.self, 3)
    ]
    
    /**
     test data
     Comment - cohjrv4
        Comment - cons4l2
            More - consbf7
        Comment - cohr3kv
            More - cohx6zp
     Comment - cogquu1
        Comment - cogz3r1
            More - coh2imm
            More - coh1r93
     Comment - co9197y
        Comment - co91ryk
            More - co9awll
        Comment - co91cai
            More - co92mv7
     Comment - co958z3
        Comment - co9memo
            More - co9y5oi
        Comment - co9805g
            More - co9la4t
        Comment - co95j0h
            More - co95jvd
        Comment - co95cz2
            More - co95f5x
    */
    func testListWhichHasSomeCommentsIncludingRepliesRecursively() {
        print("Test whether Parser can extend Comment objects that has some More objects as children.")
        print("consists of 1 Link, 13 Comments and 9 Mores.")
        if let json = self.jsonFromFileName("comments_extend.json") {
            if let array = Parser.redditAny(from: json) as? [Any] {
                if array.count == 2 {
                    if let listing = array[0] as? Listing {
                        let numberOfLinks = listing.children.reduce(0, { (value: Int, link: Thing) -> Int in
                            return link is Link ? 1 + value : value
                        })
                        XCTAssert(numberOfLinks == 1)
                    } else {
                        XCTFail("Error")
                    }
                    if let listing = array[1] as? Listing {
                        let incomming = listing.children
                            .compactMap({ $0 as? Comment })
                            .reduce([], {
                                return $0 + extendAllReplies(in: $1, current: 1)
                            })
                        
                        incomming.forEach({
                            var b = ""
                            for _ in 0 ..< ($0.1 - 1) {
                                b += "  "
                            }
//                            print("\(b)\(type(of: $0.0)) - \($0.0.id)")
                        })
                        
                        XCTAssert(gt_type.count == incomming.count, "list is mulformed.")
//                        print(gt_type)
//                        print(gt_type.count)
                        for i in 0 ..< gt_type.count {
                            let (c, d) = gt_type[i]
                            XCTAssert(c == type(of: incomming[i].0), "data type error.")
                            XCTAssert(d == incomming[i].1, "element's depth is wrong.")
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
