//
//  ExtendCommentsTest.swift
//  reddift
//
//  Created by sonson on 2015/04/28.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit
import XCTest

class ExtendCommentsTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExtendRepliesInCommentsRecursively() {
//        let json:AnyObject? = self.jsonFromFileName("comments_extend.json")
//        if let json:JSON = json {
//            if let objects = Parser.parseJSON2(json, depth:0) as? [AnyObject] {
//                XCTAssertEqual(objects.count, 2, "Check 2 Listing objects")
//                XCTAssertEqual(objects[0].count, 1, "Check first Listing object's children.")
//                if objects[0].count > 0 {
//                    XCTAssert((objects[0].children[0] is Link), "Check class of children.")
//                }
//                XCTAssertEqual(objects[1].children.count, 4, "Check class of children.")
//                
//                var comments:[Comment] = []
//                if let children = objects[1].children as? [Comment] {
//                    for obj in children {
////                        comments += extendAllReplies(obj, [])
//                    }
//                }
//                XCTAssertEqual(comments.count, 13, "Check number of extended comments.")
//                let numberOfMores = comments.reduce(0, combine: { (value:Int, comment:Comment) -> Int in
//                    return comment.hasMore() ? 1 + value : value
//                })
//                XCTAssertEqual(numberOfMores, 9, "Check number of more things.")
//            }
//            else {
//                XCTFail("JSON error")
//            }
//        }
//        else {
//            XCTFail("JSON error")
//        }
    }
}
