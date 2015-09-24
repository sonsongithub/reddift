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
    
    func testPerformanceExample() {
        
        
        if let array = self.json as? [AnyObject] {
            array.forEach({ (testData) -> () in
                print("----------------------------------------")
                if let dict = testData as? [String:AnyObject] {
                    if let body = dict["body"] as? String {
                        print(body)
                    }
                    if let source = dict["source"] as? String {
                        let a:NSAttributedString = source.simpleRedditMarkdownParse()
//                        a.enumerateAttribute(<#T##attrName: String##String#>, inRange: <#T##NSRange#>, options: <#T##NSAttributedStringEnumerationOptions#>, usingBlock: <#T##(AnyObject?, NSRange, UnsafeMutablePointer<ObjCBool>) -> Void#>)
                    }
                    if let attr = dict["attr"] as? [AnyObject] {
                        attr.forEach({(item) -> () in
                            if let item = item as? [String:AnyObject] {
                                print(item["location"],item["length"])
                            }
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
