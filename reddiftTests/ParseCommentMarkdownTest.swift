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
    
    func testParserCommentMarkdown() {
        let typeDict:[String:String] = [
            "link": NSLinkAttributeName,
            "bold": NSFontAttributeName,
            "italic": NSFontAttributeName,
            "superscript": NSBaselineOffsetAttributeName,
            "strike": NSStrikethroughStyleAttributeName
        ]
        
        if let array = self.json as? [AnyObject] {
            array.forEach({ (testData) -> () in
                print("----------------------------------------")
                if let dict = testData as? [String:AnyObject] {
                    if let body = dict["body"] as? String {
                        print(body)
                    }
                    if let source = dict["source"] as? String, let attr = dict["attr"] as? [AnyObject] {
                        print(dict)
                        let a:NSAttributedString = source.simpleRedditMarkdownParse()
                        attr.forEach({(item) -> () in
                            var check = false
                            if let item = item as? [String:AnyObject], let type = item["type"] as? String, let name = typeDict[type] {
                                if let location = item["location"] as? Int, let length = item["length"] as? Int {
                                    a.enumerateAttribute(name, inRange: NSMakeRange(location - 1, length), options: NSAttributedStringEnumerationOptions(), usingBlock: { (value:AnyObject?, range:NSRange, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                                        check = (value != nil && (location - 1) == range.location && length == range.length)
                                    })
                                }
                            }
                            XCTAssert(check == true)
                        })
                    }
                }
            })
        }
//        
//        self.measureBlock {
//        }
    }
    
}
