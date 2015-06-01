//
//  LinksTest.swift
//  reddift
//
//  Created by sonson on 2015/05/09.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Nimble
import Quick

class LinksTest: SessionTestSpec {
    /// Link ID, https://www.reddit.com/r/sandboxtest/comments/35dpes/reddift_test/
    let testLinkId = "35dpes"
    let testCommentId = "cr3g41y"
    var postedThings:[Comment] = []
    
    func test_deleteCommentOrLink(thing:Thing) {
        var isSucceeded = false
        self.session?.deleteCommentOrLink(thing.name, completion: { (result) -> Void in
            switch result {
            case let .Failure:
                println(result.error!.description)
            case let .Success:
                isSucceeded = true
            }
        })
        expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
    }
    
    override func spec() {
        beforeEach { () -> () in
            self.createSession()
        }
        
        describe("Test posting a comment to existing comment") {
            var comment:Comment? = nil
            it("Check whether the comment is posted as a child of the specified link") {
                let name = "t3_" + self.testLinkId
                self.session?.postComment("test comment2", parentName:name, completion: { (result) -> Void in
                    switch result {
                    case let .Failure:
                        println(result.error!.description)
                    case let .Success:
                        comment = result.value
                    }
                })
                expect(comment != nil).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            it("Test to delete the last posted comment.") {
                if let comment = comment {
                    self.test_deleteCommentOrLink(comment)
                }
            }
        }
        
        describe("Test posting a comment to existing link") {
            var comment:Comment? = nil
            it("the comment is posted as a child of the specified comment") {
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
            }
            it("Test to delete the last posted comment.") {
                if let comment = comment {
                    self.test_deleteCommentOrLink(comment)
                }
            }
        }
        
        describe("Test set NSFW") {
            
        }
    }

}

