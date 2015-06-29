//
//  LinksTest.swift
//  reddift
//
//  Created by sonson on 2015/05/09.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import XCTest

class LinksTest: SessionTestSpec2 {
    /// Link ID, https://www.reddit.com/r/sandboxtest/comments/35dpes/reddift_test/
    let testLinkId = "35dpes"
    let testCommentId = "cr3g41y"
    var postedThings:[Comment] = []
    
    func test_deleteCommentOrLink(thing:Thing) {
        let documentOpenExpectation = self.expectationWithDescription("test_deleteCommentOrLink")
        var isSucceeded = false
        self.session?.deleteCommentOrLink(thing.name, completion: { (result) -> Void in
            switch result {
            case .Failure(let error):
                print(error.description)
            case .Success:
                isSucceeded = true
            }
            XCTAssert(isSucceeded, "Test to delete the last posted comment.")
            documentOpenExpectation.fulfill()
        })
        self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
    }
    
    func testPostingCommentToExistingComment() {
        print("Test posting a comment to existing comment")
        do {
            var comment:Comment? = nil
            print ("Check whether the comment is posted as a child of the specified link")
            do {
                let name = "t3_" + self.testLinkId
                let documentOpenExpectation = self.expectationWithDescription("Check whether the comment is posted as a child of the specified link")
                self.session?.postComment("test comment2", parentName:name, completion: { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error.description)
                    case .Success(let postedComment):
                        comment = postedComment
                    }
                    XCTAssert(comment != nil, "Check whether the comment is posted as a child of the specified link")
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            print ("Test to delete the last posted comment.")
            do {
                if let comment = comment {
                    self.test_deleteCommentOrLink(comment)
                }
            }
        }
    }
    
    
    func testPostingCommentToExistingLink() {
        print("Test posting a comment to existing link")
        do {
            var comment:Comment? = nil
            print("the comment is posted as a child of the specified comment")
            do {
                let name = "t1_" + self.testCommentId
                let documentOpenExpectation = self.expectationWithDescription("the comment is posted as a child of the specified comment")
                self.session?.postComment("test comment3", parentName:name, completion: { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error.description)
                    case .Success(let postedComment):
                        comment = postedComment
                    }
                    XCTAssert(comment != nil, "the comment is posted as a child of the specified comment")
                    documentOpenExpectation.fulfill()
                })
                self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
            }
            
            print("Test to delete the last posted comment.")
            do {
                if let comment = comment {
                    self.test_deleteCommentOrLink(comment)
                }
            }
        }
    }
    
    func testSetNSFW() {

        print("Test to make specified Link NSFW.")
        do {
            var isSucceeded = false
            let link = Link(id: self.testLinkId)
            let documentOpenExpectation = self.expectationWithDescription("Test to make specified Link NSFW.")
            self.session?.setNSFW(true, thing: link, completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success:
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, "Test to make specified Link NSFW.")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        
        print("Check whether the specified Link is NSFW.")
        do{
            var isSucceeded = false
            let link = Link(id: self.testLinkId)
            let documentOpenExpectation = self.expectationWithDescription("Check whether the specified Link is NSFW.")
            self.session?.getInfo([link.name], completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let listing):
                    for obj in listing.children {
                        if let incommingLink = obj as? Link {
                            isSucceeded = (incommingLink.name == link.name && incommingLink.over18)
                        }
                    }
                }
                XCTAssert(isSucceeded, "Check whether the specified Link is NSFW.")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Test to make specified Link NOT NSFW.")
        do{
            var isSucceeded = false
            let link = Link(id: self.testLinkId)
            let documentOpenExpectation = self.expectationWithDescription("Test to make specified Link NOT NSFW.")
            self.session?.setNSFW(false, thing: link, completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success:
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, "Test to make specified Link NOT NSFW.")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Check whether the specified Link is NOT NSFW.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription("Test to make specified Link NOT NSFW.")
            let link = Link(id: self.testLinkId)
            self.session?.getInfo([link.name], completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let listing):
                    for obj in listing.children {
                        if let incommingLink = obj as? Link {
                            isSucceeded = (incommingLink.name == link.name && !incommingLink.over18)
                        }
                    }
                }
                XCTAssert(isSucceeded, "Test to make specified Link NOT NSFW.")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
    }
    
    func testToSaveLinkOrComment() {

        print("Test to save specified Link.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription("Test to save specified Link.")
            let link = Link(id: self.testLinkId)
            self.session?.setSave(true, name: link.name, category: "", completion: { (result) -> Void in
                switch result {
                case .Failure:
                    print(result.error!.description)
                case .Success:
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, "Test to save specified Link.")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Check whether the specified Link is saved.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription("Check whether the specified Link is saved.")
            let link = Link(id: self.testLinkId)
            self.session?.getInfo([link.name], completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let listing):
                    for obj in listing.children {
                        if let incommingLink = obj as? Link {
                            isSucceeded = (incommingLink.name == link.name && incommingLink.saved)
                        }
                    }
                }
                XCTAssert(isSucceeded, "Check whether the specified Link is saved.")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Test to unsave specified Link.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription("Test to unsave specified Link.")
            let link = Link(id: self.testLinkId)
            self.session?.setSave(false, name: link.name, category: "", completion: { (result) -> Void in
                switch result {
                case .Failure:
                    print(result.error!.description)
                case .Success:
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, "Test to unsave specified Link.")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Check whether the specified Link is unsaved.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription("Check whether the specified Link is unsaved.")
            let link = Link(id: self.testLinkId)
            self.session?.getInfo([link.name], completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let listing):
                    for obj in listing.children {
                        if let incommingLink = obj as? Link {
                            isSucceeded = (incommingLink.name == link.name && !incommingLink.saved)
                        }
                    }
                }
                XCTAssert(isSucceeded, "Check whether the specified Link is unsaved.")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
    }

    func testToHideCommentOrLink() {
        
        print("Test to hide the specified Link.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription("Test to hide the specified Link.")
            let link = Link(id: self.testLinkId)
            self.session?.setHide(true, name: link.name, completion: { (result) -> Void in
                switch result {
                case .Failure:
                    print(result.error!.description)
                case .Success:
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, "Test to hide the specified Link.")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Check whether the specified Link is hidden.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription("Check whether the specified Link is hidden.")
            let link = Link(id: self.testLinkId)
            self.session?.getInfo([link.name], completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let listing):
                    for obj in listing.children {
                        if let incommingLink = obj as? Link {
                            isSucceeded = (incommingLink.name == link.name && incommingLink.hidden)
                        }
                    }
                }
                XCTAssert(isSucceeded, "Check whether the specified Link is hidden.")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Test to show the specified Link.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription("Test to show the specified Link.")
            let link = Link(id: self.testLinkId)
            self.session?.setHide(false, name: link.name, completion: { (result) -> Void in
                switch result {
                case .Failure:
                    print(result.error!.description)
                case .Success:
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, "Test to show the specified Link.")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Check whether the specified Link is not hidden.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription("Check whether the specified Link is not hidden.")
            let link = Link(id: self.testLinkId)
            self.session?.getInfo([link.name], completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let listing):
                    for obj in listing.children {
                        if let incommingLink = obj as? Link {
                            isSucceeded = (incommingLink.name == link.name && !incommingLink.hidden)
                        }
                    }
                }
                XCTAssert(isSucceeded, "Check whether the specified Link is not hidden.")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
    }
    
    func testToVoteCommentOrLink() {
        
        print("Test to upvote the specified Link.")
        do {
            var isSucceeded = false
            let link = Link(id: self.testLinkId)
            let documentOpenExpectation = self.expectationWithDescription("Test to upvote the specified Link.")
            self.session?.setVote(VoteDirection.Up, name: link.name, completion: { (result) -> Void in
                switch result {
                case .Failure:
                    print(result.error!.description)
                case .Success:
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, "Test to upvote the specified Link.")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Check whether the specified Link is gave upvote.")
        do {
            var isSucceeded = false
            let link = Link(id: self.testLinkId)
            let documentOpenExpectation = self.expectationWithDescription("Check whether the specified Link is gave upvote.")
            self.session?.getInfo([link.name], completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let listing):
                    for obj in listing.children {
                        if let incommingLink = obj as? Link {
                            if let likes = incommingLink.likes {
                                isSucceeded = (incommingLink.name == link.name && likes)
                            }
                        }
                    }
                }
                XCTAssert(isSucceeded, "Check whether the specified Link is gave upvote.")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        
        print("Test to give a downvote to the specified Link.")
        do {
            var isSucceeded = false
            let link = Link(id: self.testLinkId)
            let documentOpenExpectation = self.expectationWithDescription("Test to give a downvote to the specified Link.")
            self.session?.setVote(VoteDirection.Down, name: link.name, completion: { (result) -> Void in
                switch result {
                case .Failure:
                    print(result.error!.description)
                case .Success:
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, "Test to give a downvote to the specified Link.")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Check whether the specified Link is gave downvote.")
            do {
            var isSucceeded = false
                let link = Link(id: self.testLinkId)
                let documentOpenExpectation = self.expectationWithDescription("Check whether the specified Link is gave downvote.")
            self.session?.getInfo([link.name], completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let listing):
                    for obj in listing.children {
                        if let incommingLink = obj as? Link {
                            if let likes = incommingLink.likes {
                                isSucceeded = (incommingLink.name == link.name && !likes)
                            }
                        }
                    }
                }
                XCTAssert(isSucceeded, "Check whether the specified Link is gave downvote.")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Test to revoke voting to the specified Link.")
        do {
            var isSucceeded = false
            let link = Link(id: self.testLinkId)
            let documentOpenExpectation = self.expectationWithDescription("Test to revoke voting to the specified Link.")
            self.session?.setVote(VoteDirection.No, name: link.name, completion: { (result) -> Void in
                switch result {
                case .Failure:
                    print(result.error!.description)
                case .Success:
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, "Test to revoke voting to the specified Link.")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Check whether the downvote to the specified Link has benn revoked.")
        do {
            var isSucceeded = false
            let link = Link(id: self.testLinkId)
            let documentOpenExpectation = self.expectationWithDescription("Check whether the downvote to the specified Link has benn revoked.")
            self.session?.getInfo([link.name], completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let listing):
                    for obj in listing.children {
                        if let incommingLink = obj as? Link {
                            isSucceeded = (incommingLink.name == link.name && (incommingLink.likes == nil))
                        }
                    }
                }
                XCTAssert(isSucceeded, "Check whether the downvote to the specified Link has benn revoked.")
                documentOpenExpectation.fulfill()
            })
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
    }
}

