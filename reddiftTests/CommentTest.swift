//
//  CommentTest.swift
//  reddift
//
//  Created by sonson on 2015/05/09.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Nimble
import Quick

class CommentTest: SessionTestSpec {
    /// Link ID, https://www.reddit.com/r/sandboxtest/comments/35dpes/reddift_test/
    let testLinkId = "35dpes"
    let testCommentId = "cr3g41y"
    var postedThings:[Thing] = []
    
    override func spec() {
        beforeEach { () -> () in
            self.createSession()
        }
        
        afterEach { () -> () in
            for thing in self.postedThings {
                var isSucceeded = false
                self.session?.deleteCommentOrLink(thing, completion: { (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        isSucceeded = true
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: 10, pollInterval: self.pollingInterval)
            }
        }
    
        describe("Try to post a comment to the specified link") {
            it("the comment is posted as a child of the specified link") {
                var comment:Comment? = nil
                var thing = Thing()
                thing.id = self.testLinkId
                thing.kind = "t3"
                thing.name = thing.kind + "_" + thing.id
                self.session?.postComment("test comment2", parent: thing, completion: { (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        comment = result.value
                    }
                })
                expect(comment != nil).toEventually(equal(true), timeout: 10, pollInterval: self.pollingInterval)
                if let comment = comment {
                    self.postedThings.append(comment)
                    expect(comment.parentId).to(equal(thing.name))
                }
            }
        }
        
        describe("Try to post a comment to the specified comment") {
            it("the comment is posted as a child of the specified comment") {
                var comment:Comment? = nil
                var thing = Thing()
                thing.id = self.testCommentId
                thing.kind = "t1"
                thing.name = thing.kind + "_" + thing.id
                self.session?.postComment("test comment3", parent: thing, completion: { (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        comment = result.value
                    }
                })
                expect(comment != nil).toEventually(equal(true), timeout: 10, pollInterval: self.pollingInterval)
                if let comment = comment {
                    self.postedThings.append(comment)
                    expect(comment.parentId).to(equal(thing.name))
                }
            }
        }
    }

}

