//
//  ParseResponseObjectTest.swift
//  reddift
//
//  Created by sonson on 2015/04/22.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit
import XCTest

class ParseResponseObjectTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testResponse_error() {
        let json:AnyObject? = self.jsonFromFileName("error.json")
        if let json:AnyObject = json {
            let object:AnyObject? = Parser.parseJSON(json, depth:0)
            XCTAssert((object == nil), "Irregular json file test.")
        }
        else {
            XCTFail("JSON error")
        }
    }
    
    func testResponse_irregular() {
        for fileName in ["t1.json", "t2.json", "t3.json", "t4.json", "t5.json"] {
            let json:AnyObject? = self.jsonFromFileName(fileName)
            if let json:AnyObject = json {
                let object:AnyObject? = Parser.parseJSON(json, depth:0)
                XCTAssert((object == nil), "Irregular json file test.")
            }
            else {
                XCTFail("JSON error")
            }
        }
    }
    
    func testResponse_comment() {
        let json:AnyObject? = self.jsonFromFileName("comments.json")
        if let json:AnyObject = json {
            if let objects = Parser.parseJSON(json, depth:0) as? [Listing] {
                XCTAssertEqual(objects.count, 2, "Check 2 Listing objects")
                XCTAssertEqual(objects[0].children.count, 1, "Check first Listing object's children.")
                if objects[0].children.count > 0 {
                    XCTAssert((objects[0].children[0] is Link), "Check class of children.")
                }
                XCTAssertEqual(objects[1].children.count, 26, "Check class of children.")
                for child in objects[1].children {
                    XCTAssert((child is Comment), "Check class of children.")
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
    
    func testResponse_link() {
        let json:AnyObject? = self.jsonFromFileName("links.json")
        if let json:AnyObject = json {
            if let listing = Parser.parseJSON(json, depth:0) as? Listing {
                XCTAssertEqual(listing.children.count, 26, "Check 2 Listing objects")
                for child in listing.children {
                    XCTAssert((child is Link), "Check class of children.")
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
    
    func testResponse_message() {
        let json:AnyObject? = self.jsonFromFileName("message.json")
        if let json:AnyObject = json {
            if let listing = Parser.parseJSON(json, depth:0) as? Listing {
                XCTAssertEqual(listing.children.count, 4, "Check 2 Listing objects")
                if listing.children.count == 4 {
                    XCTAssert((listing.children[0] is Comment), "Check class of children.")
                    XCTAssert((listing.children[1] is Comment), "Check class of children.")
                    XCTAssert((listing.children[2] is Comment), "Check class of children.")
                    XCTAssert((listing.children[3] is Message), "Check class of children.")
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

    func testResponse_subreddit() {
        let json:AnyObject? = self.jsonFromFileName("subreddit.json")
        if let json:AnyObject = json {
            if let listing = Parser.parseJSON(json, depth:0) as? Listing {
                XCTAssertEqual(listing.children.count, 5, "Check 2 Listing objects")
                for child in listing.children {
                    XCTAssert((child is Subreddit), "Check class of children.")
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
