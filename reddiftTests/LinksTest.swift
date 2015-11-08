//
//  LinksTest.swift
//  reddift
//
//  Created by sonson on 2015/05/09.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import XCTest

class LinksTest: SessionTestSpec {
    /// Default contents to be used by test
    var testLinkId = "3r2pih"
    var testCommentId = "cw05r44"
    let nsfwTestLinkId = "35ljt6"
    
    override func setUp() {
        super.setUp()
        getTestLinkID()
        getTestCommentID()
    }
    
    func getTestCommentID() {
        let documentOpenExpectation = self.expectationWithDescription("getTestCommentID")
        let link = Link(id: self.testLinkId)
        do {
            try self.session?.getArticles(link, sort:.New, comments:nil, completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error)
                case .Success(let (_, listing1)):
                    for obj in listing1.children {
                        if let comment = obj as? Comment {
                            self.testCommentId = comment.id
                        }
                        break
                    }
                }
                documentOpenExpectation.fulfill()
            })
        }
        catch { print(error) }
        self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
    }
    
    func getTestLinkID() {
        let subreddit = Subreddit(subreddit: "sandboxtest")
        let documentOpenExpectation = self.expectationWithDescription("getTestLinkID")
        do {
            try self.session?.getList(Paginator(), subreddit:subreddit, sort:.New, timeFilterWithin:.Week, completion: { (result) in
                switch result {
                case .Failure(let error):
                    print(error)
                case .Success(let listing):
                    for obj in listing.children {
                        if let link = obj as? Link {
                            self.testLinkId = link.id
                        }
                        break
                    }
                }
                documentOpenExpectation.fulfill()
            })
        }
        catch { XCTFail((error as NSError).description) }
        self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
    }
    
    func test_deleteCommentOrLink(thing:Thing) {
        let documentOpenExpectation = self.expectationWithDescription("test_deleteCommentOrLink")
        var isSucceeded = false
        do {
            try self.session?.deleteCommentOrLink(thing.name, completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success:
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, "Test to delete the last posted comment.")
                documentOpenExpectation.fulfill()
            })
        }
        catch { XCTFail((error as NSError).description) }
        self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
    }
    
    func testPostingCommentToExistingComment() {
        print("Test posting a comment to existing comment")
        do {
            var comment:Comment? = nil
            print ("Check whether the comment is posted as a child of the specified link")
            do {
                do {
                    let name = "t3_" + self.testLinkId
                    let documentOpenExpectation = self.expectationWithDescription("Check whether the comment is posted as a child of the specified link")
                    try self.session?.postComment("test comment2", parentName:name, completion: { (result) -> Void in
                        switch result {
                        case .Failure(let error):
                            print(error.description)
                        case .Success(let postedComment):
                            comment = postedComment
                        }
                        XCTAssert(comment != nil, "Check whether the comment is posted as a child of the specified link")
                        documentOpenExpectation.fulfill()
                    })
                }
                catch { XCTFail((error as NSError).description) }
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
                do {
                    let name = "t1_" + self.testCommentId
                    print(self.testCommentId)
                    let documentOpenExpectation = self.expectationWithDescription("the comment is posted as a child of the specified comment")
                    try self.session?.postComment("test comment3", parentName:name, completion: { (result) -> Void in
                        switch result {
                        case .Failure(let error):
                            print(error.description)
                        case .Success(let postedComment):
                            comment = postedComment
                        }
                        XCTAssert(comment != nil, "the comment is posted as a child of the specified comment")
                        documentOpenExpectation.fulfill()
                    })
                }
                catch { XCTFail((error as NSError).description) }
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
    
    func testSetNSFW() {nsfwTestLinkId
        print("Test to make specified Link NSFW.")
        do {
            var isSucceeded = false
            let link = Link(id: nsfwTestLinkId)
            let documentOpenExpectation = self.expectationWithDescription("Test to make specified Link NSFW.")
            do {
                try self.session?.setNSFW(true, thing: link, completion: { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error.description)
                    case .Success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to make specified Link NSFW.")
                    documentOpenExpectation.fulfill()
                })
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        
        print("Check whether the specified Link is NSFW.")
        do{
            let link = Link(id: nsfwTestLinkId)
            let documentOpenExpectation = self.expectationWithDescription("Check whether the specified Link is NSFW.")
            do {
                try self.session?.getInfo([link.name], completion: { (result) -> Void in
                    var isSucceeded = false
                    switch result {
                    case .Failure(let error):
                        print(error.description)
                    case .Success(let listing):
                        isSucceeded = listing.children
                            .flatMap({(thing:Thing) -> Link? in
                            if let obj = thing as? Link {if obj.name == link.name { return obj }}
                            return nil
                            })
                        .reduce(true) {(a:Bool, link:Link) -> Bool in
                                return (a && link.over18)
                            }
                    }
                    XCTAssert(isSucceeded, "Check whether the specified Link is NSFW.")
                    documentOpenExpectation.fulfill()
                })
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Test to make specified Link NOT NSFW.")
        do{
            var isSucceeded = false
            let link = Link(id: nsfwTestLinkId)
            let documentOpenExpectation = self.expectationWithDescription("Test to make specified Link NOT NSFW.")
            do {
                try self.session?.setNSFW(false, thing: link, completion: { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error.description)
                    case .Success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to make specified Link NOT NSFW.")
                    documentOpenExpectation.fulfill()
                })
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Check whether the specified Link is NOT NSFW.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription("Test to make specified Link NOT NSFW.")
            let link = Link(id: nsfwTestLinkId)
            do {
                try self.session?.getInfo([link.name], completion: { (result) -> Void in
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
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
    }
    
    func testToSaveLinkOrComment() {

        print("Test to save specified Link.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription("Test to save specified Link.")
            let link = Link(id: self.testLinkId)
            do {
                try self.session?.setSave(true, name: link.name, category: "", completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to save specified Link.")
                    documentOpenExpectation.fulfill()
                })
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Check whether the specified Link is saved.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription("Check whether the specified Link is saved.")
            let link = Link(id: self.testLinkId)
            do {
                try self.session?.getInfo([link.name], completion: { (result) -> Void in
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
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Test to unsave specified Link.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription("Test to unsave specified Link.")
            let link = Link(id: self.testLinkId)
            do {
                try self.session?.setSave(false, name: link.name, category: "", completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to unsave specified Link.")
                    documentOpenExpectation.fulfill()
                })
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Check whether the specified Link is unsaved.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription("Check whether the specified Link is unsaved.")
            let link = Link(id: self.testLinkId)
            do {
                try self.session?.getInfo([link.name], completion: { (result) -> Void in
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
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
    }

    func testToHideCommentOrLink() {
        
        print("Test to hide the specified Link.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription("Test to hide the specified Link.")
            let link = Link(id: self.testLinkId)
            do {
                try self.session?.setHide(true, name: link.name, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to hide the specified Link.")
                    documentOpenExpectation.fulfill()
                })
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Check whether the specified Link is hidden.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription("Check whether the specified Link is hidden.")
            let link = Link(id: self.testLinkId)
            do {
                try self.session?.getInfo([link.name], completion: { (result) -> Void in
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
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Test to show the specified Link.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription("Test to show the specified Link.")
            let link = Link(id: self.testLinkId)
            do {
                try self.session?.setHide(false, name: link.name, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to show the specified Link.")
                    documentOpenExpectation.fulfill()
                })
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Check whether the specified Link is not hidden.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectationWithDescription("Check whether the specified Link is not hidden.")
            let link = Link(id: self.testLinkId)
            do {
                try self.session?.getInfo([link.name], completion: { (result) -> Void in
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
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
    }
    
    func testToVoteLink() {
        
        print("Test to upvote the specified Link.")
        do {
            var isSucceeded = false
            let link = Link(id: self.testLinkId)
            let documentOpenExpectation = self.expectationWithDescription("Test to upvote the specified Link.")
            do {
                try self.session?.setVote(VoteDirection.Up, name: link.name, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to upvote the specified Link.")
                    documentOpenExpectation.fulfill()
                })
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Check whether the specified Link is gave upvote.")
        do {
            var isSucceeded = false
            let link = Link(id: self.testLinkId)
            let documentOpenExpectation = self.expectationWithDescription("Check whether the specified Link is gave upvote.")
            do {
                try self.session?.getInfo([link.name], completion: { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error.description)
                    case .Success(let listing):
                        for obj in listing.children {
                            if let incommingLink = obj as? Link {
                                isSucceeded = (incommingLink.name == link.name && incommingLink.likes == .Up)
                            }
                        }
                    }
                    XCTAssert(isSucceeded, "Check whether the specified Link is gave upvote.")
                    documentOpenExpectation.fulfill()
                })
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        
        print("Test to give a downvote to the specified Link.")
        do {
            var isSucceeded = false
            let link = Link(id: self.testLinkId)
            let documentOpenExpectation = self.expectationWithDescription("Test to give a downvote to the specified Link.")
            do {
                try self.session?.setVote(VoteDirection.Down, name: link.name, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to give a downvote to the specified Link.")
                    documentOpenExpectation.fulfill()
                })
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Check whether the specified Link is gave downvote.")
        do {
            var isSucceeded = false
                let link = Link(id: self.testLinkId)
                let documentOpenExpectation = self.expectationWithDescription("Check whether the specified Link is gave downvote.")
                do {
                    try self.session?.getInfo([link.name], completion: { (result) -> Void in
                        switch result {
                        case .Failure(let error):
                            print(error.description)
                        case .Success(let listing):
                            for obj in listing.children {
                                if let incommingLink = obj as? Link {
                                    isSucceeded = (incommingLink.name == link.name && incommingLink.likes == .Down)
                                }
                            }
                        }
                        XCTAssert(isSucceeded, "Check whether the specified Link is gave downvote.")
                        documentOpenExpectation.fulfill()
                    })
                }
                catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Test to revoke voting to the specified Link.")
        do {
            var isSucceeded = false
            let link = Link(id: self.testLinkId)
            let documentOpenExpectation = self.expectationWithDescription("Test to revoke voting to the specified Link.")
            do {
                try self.session?.setVote(VoteDirection.None, name: link.name, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to revoke voting to the specified Link.")
                    documentOpenExpectation.fulfill()
                })
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }

        print("Check whether the downvote to the specified Link has benn revoked.")
        do {
            var isSucceeded = false
            let link = Link(id: self.testLinkId)
            let documentOpenExpectation = self.expectationWithDescription("Check whether the downvote to the specified Link has benn revoked.")
            do {
                try self.session?.getInfo([link.name], completion: { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error.description)
                    case .Success(let listing):
                        for obj in listing.children {
                            if let incommingLink = obj as? Link {
                                isSucceeded = (incommingLink.name == link.name && (incommingLink.likes == .None))
                            }
                        }
                    }
                    XCTAssert(isSucceeded, "Check whether the downvote to the specified Link has benn revoked.")
                    documentOpenExpectation.fulfill()
                })
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
    }
    
    func testToVoteComment() {
        
        print("Test to upvote the specified Comment.")
        do {
            var isSucceeded = false
            let comment = Comment(id: self.testCommentId)
            let documentOpenExpectation = self.expectationWithDescription("Test to upvote the specified Comment.")
            do {
                try self.session?.setVote(VoteDirection.Up, name: comment.name, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to upvote the specified comment.")
                    documentOpenExpectation.fulfill()
                })
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        
        print("Check whether the specified Comment is gave upvote.")
        do {
            var isSucceeded = false
            let comment = Comment(id: self.testCommentId)
            let documentOpenExpectation = self.expectationWithDescription("Check whether the specified Comment is gave upvote.")
            do {
                try self.session?.getInfo([comment.name], completion: { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error.description)
                    case .Success(let listing):
                        for obj in listing.children {
                            if let incommingComment = obj as? Comment {
                                isSucceeded = (incommingComment.name == comment.name && (incommingComment.likes == .Up))
                            }
                        }
                    }
                    XCTAssert(isSucceeded, "Check whether the specified Comment is gave upvote.")
                    documentOpenExpectation.fulfill()
                })
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        
        print("Test to give a downvote to the specified Comment.")
        do {
            var isSucceeded = false
            let comment = Comment(id: self.testCommentId)
            let documentOpenExpectation = self.expectationWithDescription("Test to give a downvote to the specified Link.")
            do {
                try self.session?.setVote(VoteDirection.Down, name: comment.name, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to give a downvote to the specified Link.")
                    documentOpenExpectation.fulfill()
                })
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        
        print("Check whether the specified Comment is gave downvote.")
        do {
            var isSucceeded = false
            let comment = Comment(id: self.testCommentId)
            let documentOpenExpectation = self.expectationWithDescription("Check whether the specified Comment is gave downvote.")
            do {
                try self.session?.getInfo([comment.name], completion: { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error.description)
                    case .Success(let listing):
                        for obj in listing.children {
                            if let incommingComment = obj as? Comment {
                                isSucceeded = (incommingComment.name == comment.name && (incommingComment.likes == .Down))
                            }
                        }
                    }
                    XCTAssert(isSucceeded, "Check whether the specified Link is gave downvote.")
                    documentOpenExpectation.fulfill()
                })
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        
        print("Test to revoke voting to the specified Comment.")
        do {
            var isSucceeded = false
            let comment = Comment(id: self.testCommentId)
            let documentOpenExpectation = self.expectationWithDescription("Test to revoke voting to the specified Comment.")
            do {
                try self.session?.setVote(.None, name: comment.name, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to revoke voting to the specified Comment.")
                    documentOpenExpectation.fulfill()
                })
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
        
        print("Check whether the downvote to the specified Comment has benn revoked.")
        do {
            var isSucceeded = false
            let comment = Comment(id: self.testCommentId)
            let documentOpenExpectation = self.expectationWithDescription("Check whether the downvote to the specified Comment has benn revoked.")
            do {
                try self.session?.getInfo([comment.name], completion: { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error.description)
                    case .Success(let listing):
                        for obj in listing.children {
                            if let incommingComment = obj as? Comment {
                                isSucceeded = (incommingComment.name == comment.name && (incommingComment.likes == .None))
                            }
                        }
                    }
                    XCTAssert(isSucceeded, "Check whether the downvote to the specified Comment has benn revoked.")
                    documentOpenExpectation.fulfill()
                })
            }
            catch { XCTFail((error as NSError).description) }
            self.waitForExpectationsWithTimeout(self.timeoutDuration, handler: nil)
        }
    }
}

