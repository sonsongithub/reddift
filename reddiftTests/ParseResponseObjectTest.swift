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
