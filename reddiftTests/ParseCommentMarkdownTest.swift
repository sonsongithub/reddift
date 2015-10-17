//
//  ParseCommentMarkdownTest.swift
//  reddift
//
//  Created by sonson on 2015/09/24.
//  Copyright © 2015年 sonson. All rights reserved.
//

import XCTest

class ParseCommentMarkdownTest: XCTestCase {
    var json:AnyObject? = nil
    
    override func setUp() {
        super.setUp()
        json = self.jsonFromFileName("comment_parse_data.json")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /// Perfomance test for markdown parsing.
    func testPerformanceOfParserCommentMarkdown() {
        print("Check performance of Simple Markdown Parser to parse reddit's makrdown format.")
        print("test data : comment_parse_data.json")
        
        /// Start to test
        self.measureBlock {
        }
    }
    
    /// Unit test for markdown parsing
    func testParserCommentMarkdown() {
        print("Test whether Simple Markdown Parser can parse reddit's makrdown format.")
        print("test data : comment_parse_data.json")
        
        /// Start to test
        if let array = self.json as? [AnyObject] {
        }
    }
    
}
