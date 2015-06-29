//
//  ParseResponseObjectTest.swift
//  reddift
//
//  Created by sonson on 2015/04/22.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import XCTest

class ParseResponseObjectTest: XCTestCase {
        
        func testWhenErrorJsonWhichIsNotResponseFromRmoteIsLoaded() {
            print("output is nil")
            for fileName in ["error.json", "t1.json", "t2.json", "t3.json", "t4.json", "t5.json"] {
                var isSucceeded = false
                if let json:AnyObject = self.jsonFromFileName(fileName) {
                    let object:Any? = Parser.parseJSON(json)
                    XCTAssert(object == nil)
                    isSucceeded = true
                }
                XCTAssert(isSucceeded == true)
            }
        }
        
        func testCommentsJsonFile() {
            print("has 1 Link and 26 Comments")
            if let json:AnyObject = self.jsonFromFileName("comments.json") {
                if let objects = Parser.parseJSON(json) as? [JSON] {
                    XCTAssert(objects.count == 2)
                    if let links = objects[0] as? Listing {
                        XCTAssert(links.children.count == 1)
                        XCTAssert(links.children[0] is Link == true)
                    }
                    if let comments = objects[1] as? Listing {
                        for comment in comments.children {
                            XCTAssert(comment is Comment == true)
                        }
                        XCTAssert(comments.children.count == 26)
                    }
                }
            }
        }
        
        func testLinksJsonFile() {
            print("has 26 Links")
            if let json:AnyObject = self.jsonFromFileName("links.json") {
                if let listing = Parser.parseJSON(json) as? Listing {
                    XCTAssert(listing.children.count == 26)
                    for child in listing.children {
                        XCTAssert(child is Link == true)
                    }
                }
            }
        }
        
        func testMessageJsonFile() {
            print("has 4 entries, Comment, Comment, Comment, Message.")
            if let json:AnyObject = self.jsonFromFileName("message.json") {
                if let listing = Parser.parseJSON(json) as? Listing {
                    XCTAssert(listing.children.count == 4)
                    XCTAssert(listing.children[0] is Comment == true)
                    XCTAssert(listing.children[1] is Comment == true)
                    XCTAssert(listing.children[2] is Comment == true)
                    XCTAssert(listing.children[3] is Message == true)
                }
            }
        }
                
        func testSubredditJsonFile() {
            print("has 5 Subreddits.")
            if let json:AnyObject = self.jsonFromFileName("subreddit.json") {
                if let listing = Parser.parseJSON(json) as? Listing {
                    XCTAssert(listing.children.count == 5)
                    for child in listing.children {
                        XCTAssert(child is Subreddit == true)
                    }
                }
            }
        }
    
        func testParseJSONIsResponseToPostingComment() {
            print("To t1 object as Comment")
            var isSucceeded = false
            if let json:AnyObject = self.jsonFromFileName("api_comment_response.json") {
                let result = parseResponseJSONToPostComment(json)
                switch result {
                case .Success:
                    isSucceeded = true
                case .Failure:
                    break
                }
            }
            XCTAssert(isSucceeded == true)
        }
        
        func testParseJSONWhichContainsMulti() {
            print("Must have 2 Multi objects")
            if let json:AnyObject = self.jsonFromFileName("multi.json") {
                if let array = Parser.parseJSON(json) as? [Any] {
                    for obj in array {
                        XCTAssert(obj is Multireddit == true)
                    }
                }
            }
        }
}
