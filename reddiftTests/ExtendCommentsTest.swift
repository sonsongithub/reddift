//
//  ExtendCommentsTest.swift
//  reddift
//
//  Created by sonson on 2015/04/28.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
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
        let json:AnyObject? = self.jsonFromFileName("comments_extend.json")
        if let json:JSON = json {
            if let array = Parser.parseJSON(json) as? [AnyObject] {
                XCTAssertEqual(array.count, 2, "Check 2 Listing objects")
                if let listing = array[0] as? Listing {
                    XCTAssertEqual(listing.children.count, 1, "Check 2 Listing objects")
                }
                if let listing = array[1] as? Listing {
                    XCTAssertEqual(listing.children.count, 4, "Check 4 Listing objects")
                    var comments:[Thing] = []
                    for obj in listing.children {
                        if let comment = obj as? Comment {
                            comments += extendAllReplies(comment)
                        }
                        else {
                            comments.append(obj)
                        }
                    }
                    let numberOfComments = comments.reduce(0, combine: { (value:Int, comment:Thing) -> Int in
                        return comment is Comment ? 1 + value : value
                    })
                    let numberOfMores = comments.reduce(0, combine: { (value:Int, comment:Thing) -> Int in
                        return comment is More ? 1 + value : value
                    })
                    XCTAssertEqual(numberOfComments, 13, "Check number of extended comments.")
                    XCTAssertEqual(numberOfMores, 9, "Check number of more things.")
                }
            }
            else {
                XCTFail("JSON error")
            }
        }
        else {
            XCTFail("JSON error")
        }
    }
}
