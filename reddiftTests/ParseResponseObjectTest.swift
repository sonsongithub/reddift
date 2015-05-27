//
//  ParseResponseObjectTest.swift
//  reddift
//
//  Created by sonson on 2015/04/22.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import Nimble
import Quick

class ParseResponseObjectTest: QuickSpec {
    override func spec() {
        
        describe("When error json which is not a response from reddit.com is loaded") {
            it("output is nil") {
                for fileName in ["error.json", "t1.json", "t2.json", "t3.json", "t4.json", "t5.json"] {
                    var isSucceeded = false
                    if let json:AnyObject = self.jsonFromFileName(fileName) {
                        let object:Any? = Parser.parseJSON(json)
                        expect(object == nil).to(equal(true))
                        isSucceeded = true
                    }
                    expect(isSucceeded).to(equal(true))
                }
            }
        }
        
        describe("comments.json file") {
            it("has 1 Link and 26 Comments") {
                var isSucceeded = false
                if let json:AnyObject = self.jsonFromFileName("comments.json") {
                    if let objects = Parser.parseJSON(json) as? [JSON] {
                        expect(objects.count).to(equal(2))
                        if let links = objects[0] as? Listing {
                            expect(links.children.count).to(equal(1))
                            expect(links.children[0] is Link).to(equal(true))
                        }
                        if let comments = objects[1] as? Listing {
                            for comment in comments.children {
                                expect(comment is Comment).to(equal(true))
                            }
                            expect(comments.children.count).to(equal(26))
                        }
                        isSucceeded = true
                    }
                }
                expect(isSucceeded).to(equal(true))
            }
        }
        
        describe("links.json file") {
            it("has 26 Links") {
                var isSucceeded = false
                if let json:AnyObject = self.jsonFromFileName("links.json") {
                    if let listing = Parser.parseJSON(json) as? Listing {
                        expect(listing.children.count).to(equal(26))
                        for child in listing.children {
                            expect(child is Link).to(equal(true))
                        }
                        isSucceeded = true
                    }
                }
                expect(isSucceeded).to(equal(true))
            }
        }
        
        describe("message.json file") {
            it("has 4 entries, Comment, Comment, Comment, Message.") {
                var isSucceeded = false
                if let json:AnyObject = self.jsonFromFileName("message.json") {
                    if let listing = Parser.parseJSON(json) as? Listing {
                        isSucceeded = true
                        expect(listing.children.count).to(equal(4))
                        expect(listing.children[0] is Comment).to(equal(true))
                        expect(listing.children[1] is Comment).to(equal(true))
                        expect(listing.children[2] is Comment).to(equal(true))
                        expect(listing.children[3] is Message).to(equal(true))
                    }
                }
                expect(isSucceeded).to(equal(true))
            }
        }
                
        describe("subreddit.json file") {
            it("has 5 Subreddits.") {
                var isSucceeded = false
                if let json:AnyObject = self.jsonFromFileName("subreddit.json") {
                    if let listing = Parser.parseJSON(json) as? Listing {
                        expect(listing.children.count).to(equal(5))
                        for child in listing.children {
                            expect(child is Subreddit).to(equal(true))
                        }
                        isSucceeded = true
                    }
                }
                expect(isSucceeded).to(equal(true))
            }
        }
        
        describe("Parse JSON that is a response to posting a comment") {
            it("To t1 object as Comment") {
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
                expect(isSucceeded).to(equal(true))
            }
        }
        
        describe("Parse JSON which contains multi") {
            it("Must have 2 Multi objects") {
                var isSucceeded = false
                if let json:AnyObject = self.jsonFromFileName("multi.json") {
                    if let array = Parser.parseJSON(json) as? [Any] {
                        isSucceeded = true
                        for obj in array {
                            expect(obj is Multireddit).to(equal(true))
                        }
                    }
                }
                expect(isSucceeded).to(equal(true))
            }
        }
        
    }
}
