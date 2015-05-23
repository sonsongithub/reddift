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
                    let json:AnyObject? = self.jsonFromFileName(fileName)
                    expect(json != nil).to(equal(true))
                    if let json:AnyObject = json {
                        let object:AnyObject? = Parser.parseJSON(json)
                        expect(object == nil).to(equal(true))
                    }
                }
            }
        }
        
        describe("comments.json file") {
            it("has 1 Link and 26 Comments") {
                let json:AnyObject? = self.jsonFromFileName("comments.json")
                expect(json != nil).to(equal(true))
                if let json:AnyObject = json {
                    let objects:AnyObject? = Parser.parseJSON(json)
                    expect(objects != nil).to(equal(true))
                    if let objects = objects as? [JSON] {
                        expect(objects.count).to(equal(2))
                        
                        if let links = objects[0] as? [AnyObject] {
                            expect(objects.count).to(equal(2))
                            expect(links[0] is Link).to(equal(true))
                        }
                        if let comments = objects[1] as? [AnyObject] {
                            for comment in comments {
                                expect(comment.dynamicType === Comment.self).to(equal(true))
                            }
                            expect(comments.count).to(equal(26))
                        }
                    }
                }

            }
        }
        
        describe("links.json file") {
            it("has 26 Links") {
                let json:AnyObject? = self.jsonFromFileName("links.json")
                expect(json != nil).to(equal(true))
                if let json:AnyObject = json {
                    let listing:AnyObject? = Parser.parseJSON(json)
                    expect(listing != nil).to(equal(true))
                    if let listing = listing as? Listing {
                        expect(listing.children.count).to(equal(26))
                        for child in listing.children {
                            expect(child.dynamicType === Link.self).to(equal(true))
                        }
                    }
                }
                
            }
        }
        
        describe("message.json file") {
            it("has 4 entries, Comment, Comment, Comment, Message.") {
                let json:AnyObject? = self.jsonFromFileName("message.json")
                expect(json != nil).to(equal(true))
                if let json:AnyObject = json {
                    let listing:AnyObject? = Parser.parseJSON(json)
                    expect(listing != nil).to(equal(true))
                    
                    if let listing = listing as? Listing {
                        expect(listing.children.count).to(equal(4))
                        expect(listing.children[0].dynamicType === Comment.self).to(equal(true))
                        expect(listing.children[1].dynamicType === Comment.self).to(equal(true))
                        expect(listing.children[2].dynamicType === Comment.self).to(equal(true))
                        expect(listing.children[3].dynamicType === Message.self).to(equal(true))
                    }
                }
                
            }
        }
                
        describe("subreddit.json file") {
            it("has 5 Subreddits.") {
                let json:AnyObject? = self.jsonFromFileName("subreddit.json")
                expect(json != nil).to(equal(true))
                if let json:AnyObject = json {
                    let listing:AnyObject? = Parser.parseJSON(json)
                    expect(listing != nil).to(equal(true))
                    
                    if let listing = listing as? Listing {
                        expect(listing.children.count).to(equal(5))
                        for child in listing.children {
                            expect(child.dynamicType === Subreddit.self).to(equal(true))
                        }
                    }
                }
                
            }
        }
        
        describe("Parse JSON that is a response to posting a comment") {
            it("To t1 object as Comment") {
                let json:AnyObject? = self.jsonFromFileName("api_comment_response.json")
                expect(json != nil).to(equal(true))
                if let json:AnyObject = json {
                    let result = parseResponseJSONToPostComment(json)
                }
            }
        }
        
        describe("Parse JSON which contains multi") {
            it("Must have 2 Multi objects") {
                var isSucceeded = false
                let json:AnyObject? = self.jsonFromFileName("multi.json")
                expect(json != nil).to(equal(true))
                if let json:AnyObject = json {
                    if let hoge:AnyObject? = Parser.parseJSON(json) {
                        if let array = hoge as? [Multireddit] {
                            isSucceeded = true
                        }
                    }
                }
                expect(isSucceeded).to(equal(true))
            }
        }
        
    }
}
