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
        let documentOpenExpectation = self.expectation(description: "getTestCommentID")
        let link = Link(id: self.testLinkId)
        do {
            try self.session?.getArticles(link, sort: .new, comments: nil, completion: { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let (_, listing1)):
                    for obj in listing1.children {
                        if let comment = obj as? Comment {
                            self.testCommentId = comment.id
                        }
                        break
                    }
                }
                documentOpenExpectation.fulfill()
            })
        } catch { print(error) }
        self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
    }
    
    func getTestLinkID() {
        let subreddit = Subreddit(subreddit: "sandboxtest")
        let documentOpenExpectation = self.expectation(description: "getTestLinkID")
        do {
            try self.session?.getList(Paginator(), subreddit: subreddit, sort: .new, timeFilterWithin: .week, completion: { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let listing):
                    for obj in listing.children {
                        if let link = obj as? Link {
                            if link.numComments > 0 {
                                self.testLinkId = link.id
                                break
                            }
                        }
                    }
                }
                documentOpenExpectation.fulfill()
            })
        } catch { XCTFail((error as NSError).description) }
        self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
    }
    
    func test_deleteCommentOrLink(_ thing: Thing) {
        let documentOpenExpectation = self.expectation(description: "test_deleteCommentOrLink")
        var isSucceeded = false
        do {
            try self.session?.deleteCommentOrLink(thing.name, completion: { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error.description)
                case .success:
                    isSucceeded = true
                }
                XCTAssert(isSucceeded, "Test to delete the last posted comment.")
                documentOpenExpectation.fulfill()
            })
        } catch { XCTFail((error as NSError).description) }
        self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
    }
    
    func testPostingCommentToExistingLink() {
        print("Test posting a comment to existing link")
        do {
            var comment: Comment? = nil
            print ("Check whether the comment is posted as a child of the specified link")
            do {
                do {
                    let name = "t3_" + self.testLinkId
                    let documentOpenExpectation = self.expectation(description: "Check whether the comment is posted as a child of the specified link")
                    try self.session?.postComment("test comment2", parentName: name, completion: { (result) -> Void in
                        switch result {
                        case .failure(let error):
                            print(error.description)
                        case .success(let postedComment):
                            comment = postedComment
                        }
                        XCTAssert(comment != nil, "Check whether the comment is posted as a child of the specified link")
                        documentOpenExpectation.fulfill()
                    })
                } catch { XCTFail((error as NSError).description) }
                self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
            }
            print ("Test to delete the last posted comment.")
            do {
                if let comment = comment {
                    self.test_deleteCommentOrLink(comment)
                }
            }
        }
    }
    
    func testParsingErrorObjectWhenPostingCommentToTooOldComment() {
        print("Test whether Parse class can parse returned JSON object when posting a comment to the too old comment")
        do {
            do {
                do {
                    let name = "t1_cw05r44" // old comment object ID
                    let documentOpenExpectation = self.expectation(description: "Test whether Parse class can parse returned JSON object when posting a comment to the too old comment")
                    try self.session?.postComment("test comment3", parentName: name, completion: { (result) -> Void in
                        switch result {
                        case .failure(let error):
                            XCTAssert(error.code == ReddiftError.commentJsonObjectIsMalformed.rawValue)
                        case .success(let postedComment):
                            print(postedComment)
                            XCTFail("")
                        }
                        documentOpenExpectation.fulfill()
                    })
                } catch { XCTFail((error as NSError).description) }
                self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
            }
        }
    }
    
    func testPostingCommentToExistingComment() {
        print("Test posting a comment to existing comment")
        do {
            var comment: Comment? = nil
            print("the comment is posted as a child of the specified comment")
            do {
                do {
                    let name = "t1_" + self.testCommentId
                    let documentOpenExpectation = self.expectation(description: "the comment is posted as a child of the specified comment")
                    try self.session?.postComment("test comment3", parentName: name, completion: { (result) -> Void in
                        switch result {
                        case .failure(let error):
                            print(error.description)
                        case .success(let postedComment):
                            comment = postedComment
                        }
                        XCTAssert(comment != nil, "the comment is posted as a child of the specified comment")
                        documentOpenExpectation.fulfill()
                    })
                } catch { XCTFail((error as NSError).description) }
                self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
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
            let link = Link(id: nsfwTestLinkId)
            let documentOpenExpectation = self.expectation(description: "Test to make specified Link NSFW.")
            do {
                try self.session?.setNSFW(true, thing: link, completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error.description)
                    case .success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to make specified Link NSFW.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
        
        print("Check whether the specified Link is NSFW.")
        do {
            let link = Link(id: nsfwTestLinkId)
            let documentOpenExpectation = self.expectation(description: "Check whether the specified Link is NSFW.")
            do {
                try self.session?.getInfo([link.name], completion: { (result) -> Void in
                    var isSucceeded = false
                    switch result {
                    case .failure(let error):
                        print(error.description)
                    case .success(let listing):
                        isSucceeded = listing.children
                            .compactMap({(thing: Thing) -> Link? in
                            if let obj = thing as? Link {if obj.name == link.name { return obj }}
                            return nil
                            })
                        .reduce(true) {(a: Bool, link: Link) -> Bool in
                                return (a && link.over18)
                            }
                    }
                    XCTAssert(isSucceeded, "Check whether the specified Link is NSFW.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }

        print("Test to make specified Link NOT NSFW.")
        do {
            var isSucceeded = false
            let link = Link(id: nsfwTestLinkId)
            let documentOpenExpectation = self.expectation(description: "Test to make specified Link NOT NSFW.")
            do {
                try self.session?.setNSFW(false, thing: link, completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error.description)
                    case .success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to make specified Link NOT NSFW.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }

        print("Check whether the specified Link is NOT NSFW.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectation(description: "Test to make specified Link NOT NSFW.")
            let link = Link(id: nsfwTestLinkId)
            do {
                try self.session?.getInfo([link.name], completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error.description)
                    case .success(let listing):
                        for obj in listing.children {
                            if let incommingLink = obj as? Link {
                                isSucceeded = (incommingLink.name == link.name && !incommingLink.over18)
                            }
                        }
                    }
                    XCTAssert(isSucceeded, "Test to make specified Link NOT NSFW.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
    }
    
    func testToSaveLink() {

        print("Test to save specified Link.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectation(description: "Test to save specified Link.")
            let link = Link(id: self.testLinkId)
            do {
                try self.session?.setSave(true, name: link.name, category: "", completion: { (result) -> Void in
                    switch result {
                    case .failure:
                        print(result.error!.description)
                    case .success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to save specified Link.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }

        print("Check whether the specified Link is saved.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectation(description: "Check whether the specified Link is saved.")
            let link = Link(id: self.testLinkId)
            do {
                try self.session?.getInfo([link.name], completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error.description)
                    case .success(let listing):
                        for obj in listing.children {
                            if let incommingLink = obj as? Link {
                                isSucceeded = (incommingLink.name == link.name && incommingLink.saved)
                            }
                        }
                    }
                    XCTAssert(isSucceeded, "Check whether the specified Link is saved.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }

        print("Test to unsave specified Link.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectation(description: "Test to unsave specified Link.")
            let link = Link(id: self.testLinkId)
            do {
                try self.session?.setSave(false, name: link.name, category: "", completion: { (result) -> Void in
                    switch result {
                    case .failure:
                        print(result.error!.description)
                    case .success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to unsave specified Link.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }

        print("Check whether the specified Link is unsaved.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectation(description: "Check whether the specified Link is unsaved.")
            let link = Link(id: self.testLinkId)
            do {
                try self.session?.getInfo([link.name], completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error.description)
                    case .success(let listing):
                        for obj in listing.children {
                            if let incommingLink = obj as? Link {
                                isSucceeded = (incommingLink.name == link.name && !incommingLink.saved)
                            }
                        }
                    }
                    XCTAssert(isSucceeded, "Check whether the specified Link is unsaved.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
    }
    
    func testToSaveComment() {
        
        print("Test to save specified Comment.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectation(description: "Test to save specified Comment.")
            let comment = Comment(id: self.testCommentId)
            do {
                try self.session?.setSave(true, name: comment.name, category: "", completion: { (result) -> Void in
                    switch result {
                    case .failure:
                        print(result.error!.description)
                    case .success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to save specified Comment.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
        
        print("Check whether the specified Comment is saved.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectation(description: "Check whether the specified Comment is saved.")
            let comment = Comment(id: self.testCommentId)
            do {
                try self.session?.getInfo([comment.name], completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error.description)
                    case .success(let listing):
                        for obj in listing.children {
                            if let incommingComment = obj as? Comment {
                                isSucceeded = (incommingComment.name == comment.name && incommingComment.saved)
                            }
                        }
                    }
                    XCTAssert(isSucceeded, "Check whether the specified Comment is saved.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
        
        print("Test to unsave specified Comment.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectation(description: "Test to unsave specified Comment.")
            let comment = Comment(id: self.testCommentId)
            do {
                try self.session?.setSave(false, name: comment.name, category: "", completion: { (result) -> Void in
                    switch result {
                    case .failure:
                        print(result.error!.description)
                    case .success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to unsave specified Comment.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
        
        print("Check whether the specified Comment is unsaved.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectation(description: "Check whether the specified Comment is unsaved.")
            let comment = Comment(id: self.testCommentId)
            do {
                try self.session?.getInfo([comment.name], completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error.description)
                    case .success(let listing):
                        for obj in listing.children {
                            if let incommingComment = obj as? Comment {
                                isSucceeded = (incommingComment.name == comment.name && !incommingComment.saved)
                            }
                        }
                    }
                    XCTAssert(isSucceeded, "Check whether the specified Comment is unsaved.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
    }

    func testToHideLink() {
        
        print("Test to hide the specified Link.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectation(description: "Test to hide the specified Link.")
            let link = Link(id: self.testLinkId)
            do {
                try self.session?.setHide(true, name: link.name, completion: { (result) -> Void in
                    switch result {
                    case .failure:
                        print(result.error!.description)
                    case .success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to hide the specified Link.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }

        print("Check whether the specified Link is hidden.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectation(description: "Check whether the specified Link is hidden.")
            let link = Link(id: self.testLinkId)
            do {
                try self.session?.getInfo([link.name], completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error.description)
                    case .success(let listing):
                        for obj in listing.children {
                            if let incommingLink = obj as? Link {
                                isSucceeded = (incommingLink.name == link.name && incommingLink.hidden)
                            }
                        }
                    }
                    XCTAssert(isSucceeded, "Check whether the specified Link is hidden.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }

        print("Test to show the specified Link.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectation(description: "Test to show the specified Link.")
            let link = Link(id: self.testLinkId)
            do {
                try self.session?.setHide(false, name: link.name, completion: { (result) -> Void in
                    switch result {
                    case .failure:
                        print(result.error!.description)
                    case .success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to show the specified Link.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }

        print("Check whether the specified Link is not hidden.")
        do {
            var isSucceeded = false
            let documentOpenExpectation = self.expectation(description: "Check whether the specified Link is not hidden.")
            let link = Link(id: self.testLinkId)
            do {
                try self.session?.getInfo([link.name], completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error.description)
                    case .success(let listing):
                        for obj in listing.children {
                            if let incommingLink = obj as? Link {
                                isSucceeded = (incommingLink.name == link.name && !incommingLink.hidden)
                            }
                        }
                    }
                    XCTAssert(isSucceeded, "Check whether the specified Link is not hidden.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
    }
    
    func testToVoteLink() {
        
        print("Test to upvote the specified Link.")
        do {
            var isSucceeded = false
            let link = Link(id: self.testLinkId)
            let documentOpenExpectation = self.expectation(description: "Test to upvote the specified Link.")
            do {
                try self.session?.setVote(.up, name: link.name, completion: { (result) -> Void in
                    switch result {
                    case .failure:
                        print(result.error!.description)
                    case .success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to upvote the specified Link.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
        
        Thread.sleep(forTimeInterval: testInterval)

        print("Check whether the specified Link is gave upvote.")
        do {
            var isSucceeded = false
            let link = Link(id: self.testLinkId)
            let documentOpenExpectation = self.expectation(description: "Check whether the specified Link is gave upvote.")
            do {
                try self.session?.getInfo([link.name], completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error.description)
                    case .success(let listing):
                        for obj in listing.children {
                            if let incommingLink = obj as? Link {
                                isSucceeded = (incommingLink.name == link.name && incommingLink.likes == .up)
                            }
                        }
                    }
                    XCTAssert(isSucceeded, "Check whether the specified Link is gave upvote.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
        
        Thread.sleep(forTimeInterval: testInterval)
        
        print("Test to give a downvote to the specified Link.")
        do {
            var isSucceeded = false
            let link = Link(id: self.testLinkId)
            let documentOpenExpectation = self.expectation(description: "Test to give a downvote to the specified Link.")
            do {
                try self.session?.setVote(.down, name: link.name, completion: { (result) -> Void in
                    switch result {
                    case .failure:
                        print(result.error!.description)
                    case .success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to give a downvote to the specified Link.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
        
        Thread.sleep(forTimeInterval: testInterval)

        print("Check whether the specified Link is gave downvote.")
        do {
            var isSucceeded = false
                let link = Link(id: self.testLinkId)
                let documentOpenExpectation = self.expectation(description: "Check whether the specified Link is gave downvote.")
                do {
                    try self.session?.getInfo([link.name], completion: { (result) -> Void in
                        switch result {
                        case .failure(let error):
                            print(error.description)
                        case .success(let listing):
                            for obj in listing.children {
                                if let incommingLink = obj as? Link {
                                    isSucceeded = (incommingLink.name == link.name && incommingLink.likes == .down)
                                }
                            }
                        }
                        XCTAssert(isSucceeded, "Check whether the specified Link is gave downvote.")
                        documentOpenExpectation.fulfill()
                    })
                } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
        
        Thread.sleep(forTimeInterval: testInterval)

        print("Test to revoke voting to the specified Link.")
        do {
            var isSucceeded = false
            let link = Link(id: self.testLinkId)
            let documentOpenExpectation = self.expectation(description: "Test to revoke voting to the specified Link.")
            do {
                try self.session?.setVote(.none, name: link.name, completion: { (result) -> Void in
                    switch result {
                    case .failure:
                        print(result.error!.description)
                    case .success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to revoke voting to the specified Link.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
        
        Thread.sleep(forTimeInterval: testInterval)

        print("Check whether the downvote to the specified Link has been revoked.")
        do {
            var isSucceeded = false
            let link = Link(id: self.testLinkId)
            let documentOpenExpectation = self.expectation(description: "Check whether the downvote to the specified Link has been revoked.")
            do {
                try self.session?.getInfo([link.name], completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error.description)
                    case .success(let listing):
                        for obj in listing.children {
                            if let incommingLink = obj as? Link {
                                isSucceeded = (incommingLink.name == link.name && (incommingLink.likes == .none))
                            }
                        }
                    }
                    XCTAssert(isSucceeded, "Check whether the downvote to the specified Link has been revoked.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
    }
    
    func testToVoteComment() {
        
        print("Test to upvote the specified Comment.")
        do {
            var isSucceeded = false
            let comment = Comment(id: self.testCommentId)
            let documentOpenExpectation = self.expectation(description: "Test to upvote the specified Comment.")
            do {
                try self.session?.setVote(VoteDirection.up, name: comment.name, completion: { (result) -> Void in
                    switch result {
                    case .failure:
                        print(result.error!.description)
                    case .success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to upvote the specified comment.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
        
        Thread.sleep(forTimeInterval: testInterval)
        
        print("Check whether the specified Comment is gave upvote.")
        do {
            var isSucceeded = false
            let comment = Comment(id: self.testCommentId)
            let documentOpenExpectation = self.expectation(description: "Check whether the specified Comment is gave upvote.")
            do {
                try self.session?.getInfo([comment.name], completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error.description)
                    case .success(let listing):
                        for obj in listing.children {
                            if let incommingComment = obj as? Comment {
                                isSucceeded = (incommingComment.name == comment.name && (incommingComment.likes == .up))
                            }
                        }
                    }
                    XCTAssert(isSucceeded, "Check whether the specified Comment is gave upvote.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
        
        Thread.sleep(forTimeInterval: testInterval)
        
        print("Test to give a downvote to the specified Comment.")
        do {
            var isSucceeded = false
            let comment = Comment(id: self.testCommentId)
            let documentOpenExpectation = self.expectation(description: "Test to give a downvote to the specified Link.")
            do {
                try self.session?.setVote(VoteDirection.down, name: comment.name, completion: { (result) -> Void in
                    switch result {
                    case .failure:
                        print(result.error!.description)
                    case .success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to give a downvote to the specified Link.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
        
        Thread.sleep(forTimeInterval: testInterval)
        
        print("Check whether the specified Comment is gave downvote.")
        do {
            var isSucceeded = false
            let comment = Comment(id: self.testCommentId)
            let documentOpenExpectation = self.expectation(description: "Check whether the specified Comment is gave downvote.")
            do {
                try self.session?.getInfo([comment.name], completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error.description)
                    case .success(let listing):
                        for obj in listing.children {
                            if let incommingComment = obj as? Comment {
                                isSucceeded = (incommingComment.name == comment.name && (incommingComment.likes == .down))
                            }
                        }
                    }
                    XCTAssert(isSucceeded, "Check whether the specified Link is gave downvote.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
        
        Thread.sleep(forTimeInterval: testInterval)
        
        print("Test to revoke voting to the specified Comment.")
        do {
            var isSucceeded = false
            let comment = Comment(id: self.testCommentId)
            let documentOpenExpectation = self.expectation(description: "Test to revoke voting to the specified Comment.")
            do {
                try self.session?.setVote(.none, name: comment.name, completion: { (result) -> Void in
                    switch result {
                    case .failure:
                        print(result.error!.description)
                    case .success:
                        isSucceeded = true
                    }
                    XCTAssert(isSucceeded, "Test to revoke voting to the specified Comment.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
        
        Thread.sleep(forTimeInterval: testInterval)
        
        print("Check whether the downvote to the specified Comment has been revoked.")
        do {
            var isSucceeded = false
            let comment = Comment(id: self.testCommentId)
            let documentOpenExpectation = self.expectation(description: "Check whether the downvote to the specified Comment has been revoked.")
            do {
                try self.session?.getInfo([comment.name], completion: { (result) -> Void in
                    switch result {
                    case .failure(let error):
                        print(error.description)
                    case .success(let listing):
                        for obj in listing.children {
                            if let incommingComment = obj as? Comment {
                                isSucceeded = (incommingComment.name == comment.name && (incommingComment.likes == .none))
                            }
                        }
                    }
                    XCTAssert(isSucceeded, "Check whether the downvote to the specified Comment has been revoked.")
                    documentOpenExpectation.fulfill()
                })
            } catch { XCTFail((error as NSError).description) }
            self.waitForExpectations(timeout: self.timeoutDuration, handler: nil)
        }
    }
}
