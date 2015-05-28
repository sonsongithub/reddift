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
    var postedThings:[Comment] = []
    
    override func spec() {
        beforeEach { () -> () in
            self.createSession()
        }
        
        afterEach { () -> () in
            for comment in self.postedThings {
                var isSucceeded = false
                self.session?.deleteCommentOrLink(comment.name, completion: { (result) -> Void in
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
                let name = "t3_" + self.testLinkId
                var comment:Comment? = nil
                self.session?.postComment("test comment2", parentName:name, completion: { (result) -> Void in
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
                    expect(comment.parentId).to(equal(name))
                }
            }
        }
        
        describe("Try to post a comment to the specified comment") {
            it("the comment is posted as a child of the specified comment") {
                var comment:Comment? = nil
                let name = "t1_" + self.testCommentId
                self.session?.postComment("test comment3", parentName:name, completion: { (result) -> Void in
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
                    expect(comment.parentId).to(equal(name))
                }
            }
        }
    }

}

