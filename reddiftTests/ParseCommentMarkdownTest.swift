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
    
    func testPerformanceOfParserCommentMarkdown() {
        print("Check performance of Simple Markdown Parser to parse reddit's makrdown format.")
        print("test data : comment_parse_data.json")
        
        /// Start to test
        self.measureBlock {
            if let array = self.json as? [AnyObject] {
                array.forEach({ (testData) -> () in
                    if let dict = testData as? [String:AnyObject],
                        let source = dict["source"] as? String {
                            let _:NSAttributedString = source.simpleRedditMarkdownParse()
                    }
                })
            }
        }
    }
    
    func testParserCommentMarkdown() {
        print("Test whether Simple Markdown Parser can parse reddit's makrdown format.")
        print("test data : comment_parse_data.json")
        
        /// Mapping test data's type to NSAttributedString's attribute name.
        let typeDict:[String:String] = [
            "link": NSLinkAttributeName,
            "bold": NSFontAttributeName,
            "italic": NSFontAttributeName,
            "superscript": NSBaselineOffsetAttributeName,
            "strike": NSStrikethroughStyleAttributeName
        ]
        
        /// Start to test
        if let array = self.json as? [AnyObject] {
            array.forEach({ (testData) -> () in
                print("----------------------------------------")
                if let dict = testData as? [String:AnyObject],
                    let body = dict["body"] as? String,
                    let source = dict["source"] as? String,
                    let attr = dict["attr"] as? [AnyObject] {
                        /// Parse
                        let attributedString:NSAttributedString = source.simpleRedditMarkdownParse()
                        print("------->Input markdown")
                        print(source)
                        print("------->Ground truth")
                        print(body)
                        print("------->Parser's result")
                        print(attributedString.string)
                        
                        /// Test string
                        XCTAssert(body == attributedString.string)
                        
                        /// Test all attributes that must be attached NSAttributedString.
                        attr.forEach({(item) -> () in
                            var check = false
                            if let item = item as? [String:AnyObject], let type = item["type"] as? String, let name = typeDict[type] {
                                if let location = item["location"] as? Int, let length = item["length"] as? Int {
                                    attributedString.enumerateAttribute(name, inRange: NSMakeRange(location - 1, length), options: NSAttributedStringEnumerationOptions(), usingBlock: { (value:AnyObject?, range:NSRange, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                                        check = (value != nil && (location - 1) == range.location && length == range.length)
                                    })
                                }
                            }
                            XCTAssert(check == true)
                        })
                }
            })
        }
    }
    
}
