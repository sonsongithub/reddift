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

    //    func testLinkList() {
    //        if let path = NSBundle(forClass: self.classForCoder).pathForResource("links", ofType: "json") {
    //            if let data = NSData(contentsOfFile: path) {
    //                if let json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) {
    //					if let listing = Parser.parseJSON(json, depth:0) as? Listing {
    //						for link in listing.children {
    //							if let link = link as? Link {
    //								println(link.toString())
    //							}
    //						}
    //					}
    //                }
    //            }
    //        }
    //    }
    //
    //    func testComment() {
    //        if let path = NSBundle(forClass: self.classForCoder).pathForResource("comments01", ofType: "json") {
    //            if let data = NSData(contentsOfFile: path) {
    //                if let json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) {
    //                    var obj:AnyObject? = Parser.parseJSON(json, depth:0)
    //                    if let array = obj as? [AnyObject] {
    //                        for element in array {
    //                            if let listing = element as? Listing {
    //                                println(listing.toString())
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
    //
    
    
    func testSubreddits() {
        if let path = NSBundle(forClass: self.classForCoder).pathForResource("subreddit", ofType: "json") {
            if let data = NSData(contentsOfFile: path) {
                if let json:AnyObject = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) {
                    if let listing = Parser.parseJSON(json, depth:0) as? Listing {
                        for subreddit in listing.children {
                            if let subreddit = subreddit as? Subreddit {
                                println(subreddit.toString())
                            }
                        }
                    }
                }
            }
        }
    }
    


}
