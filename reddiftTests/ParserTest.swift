//
//  ParserTest.swift
//  reddift
//
//  Created by sonson on 2015/04/20.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit
import XCTest

class ParserTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
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
//    func testParseThing_t1() {
//        if let path = NSBundle(forClass: self.classForCoder).pathForResource("t1", ofType: "json") {
//            if let data = NSData(contentsOfFile: path) {
//                if let json = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
//					var t1:AnyObject? = Parser.parseJSON(json, depth:0)
//					if let t1 = t1 as? Thing {
//						println(t1.toString())
//					}
//                }
//            }
//        }
//    }
	
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
	
	func testParseThing_t5() {
		if let path = NSBundle(forClass: self.classForCoder).pathForResource("t5", ofType: "json") {
			if let data = NSData(contentsOfFile: path) {
				if let json = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
					var t1:AnyObject? = Parser.parseJSON(json, depth:0)
					if let t1 = t1 as? Thing {
						println(t1.toString())
					}
				}
			}
		}
	}
//
//    func testParseThing_t3() {
//        if let path = NSBundle(forClass: self.classForCoder).pathForResource("t3", ofType: "json") {
//            if let data = NSData(contentsOfFile: path) {
//                if let json = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
//                    if let thing = Parser.parseThing(json, depth:0) as? Thing {
//                        println(thing.data)
//                    }
//                }
//            }
//        }
//    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
}
