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
            case .Failure:
                print(result.error!.description)
            case .Success:
                isSucceeded = true
            }
        })
        expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
    }
    
    override func spec() {
        beforeEach { () -> () in
            self.createSession()
        }
        
        // MARK: Test posting a comment to existing comment.

        describe("Test posting a comment to existing comment") {
            var comment:Comment? = nil
            it("Check whether the comment is posted as a child of the specified link") {
                let name = "t3_" + self.testLinkId
                self.session?.postComment("test comment2", parentName:name, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
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
    
        // MARK: Test posting a comment to existing link.
    
        describe("Test posting a comment to existing link") {
            var comment:Comment? = nil
            it("the comment is posted as a child of the specified comment") {
                let name = "t1_" + self.testCommentId
                self.session?.postComment("test comment3", parentName:name, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
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
    
        // MARK: Test set NSFW.
    
        describe("Test set NSFW") {
            it("Test to make specified Link NSFW.") {
                var isSucceeded = false
                let link = Link(id: self.testLinkId)
                self.session?.setNSFW(true, thing: link, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Check whether the specified Link is NSFW.") {
                var isSucceeded = false
                let link = Link(id: self.testLinkId)
                self.session?.getInfo([link.name], completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        if let listing = result.value as? Listing {
                            for obj in listing.children {
                                if let incommingLink = obj as? Link {
                                    isSucceeded = (incommingLink.name == link.name && incommingLink.over18)
                                }
                            }
                        }
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Test to make specified Link NOT NSFW.") {
                var isSucceeded = false
                let link = Link(id: self.testLinkId)
                self.session?.setNSFW(false, thing: link, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Check whether the specified Link is NOT NSFW.") {
                var isSucceeded = false
                let link = Link(id: self.testLinkId)
                self.session?.getInfo([link.name], completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        if let listing = result.value as? Listing {
                            for obj in listing.children {
                                if let incommingLink = obj as? Link {
                                    isSucceeded = (incommingLink.name == link.name && !incommingLink.over18)
                                }
                            }
                        }
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
        }
        
        // MARK: Test to save a link or a comment
        
        describe("Test to save") {
            it("Test to save specified Link.") {
                var isSucceeded = false
                let link = Link(id: self.testLinkId)
                self.session?.setSave(true, name: link.name, category: "", completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Check whether the specified Link is saved.") {
                var isSucceeded = false
                let link = Link(id: self.testLinkId)
                self.session?.getInfo([link.name], completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        if let listing = result.value as? Listing {
                            for obj in listing.children {
                                if let incommingLink = obj as? Link {
                                    isSucceeded = (incommingLink.name == link.name && incommingLink.saved)
                                }
                            }
                        }
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Test to unsave specified Link.") {
                var isSucceeded = false
                let link = Link(id: self.testLinkId)
                self.session?.setSave(false, name: link.name, category: "", completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Check whether the specified Link is unsaved.") {
                var isSucceeded = false
                let link = Link(id: self.testLinkId)
                self.session?.getInfo([link.name], completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        if let listing = result.value as? Listing {
                            for obj in listing.children {
                                if let incommingLink = obj as? Link {
                                    isSucceeded = (incommingLink.name == link.name && !incommingLink.saved)
                                }
                            }
                        }
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
        }

        // MARK: Test to hide a comment or a link
        
        describe("Test to hide") {
            it("Test to hide the specified Link.") {
                var isSucceeded = false
                let link = Link(id: self.testLinkId)
                self.session?.setHide(true, name: link.name, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Check whether the specified Link is hidden.") {
                var isSucceeded = false
                let link = Link(id: self.testLinkId)
                self.session?.getInfo([link.name], completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        if let listing = result.value as? Listing {
                            for obj in listing.children {
                                if let incommingLink = obj as? Link {
                                    isSucceeded = (incommingLink.name == link.name && incommingLink.hidden)
                                }
                            }
                        }
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Test to show the specified Link.") {
                var isSucceeded = false
                let link = Link(id: self.testLinkId)
                self.session?.setHide(false, name: link.name, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Check whether the specified Link is not hidden.") {
                var isSucceeded = false
                let link = Link(id: self.testLinkId)
                self.session?.getInfo([link.name], completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        if let listing = result.value as? Listing {
                            for obj in listing.children {
                                if let incommingLink = obj as? Link {
                                    isSucceeded = (incommingLink.name == link.name && !incommingLink.hidden)
                                }
                            }
                        }
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
        }

        // MARK: Test to vote a comment or a link
        
        describe("Test to give a upvote to a comment or a link.") {
            it("Test to upvote the specified Link.") {
                var isSucceeded = false
                let link = Link(id: self.testLinkId)
                self.session?.setVote(VoteDirection.Up, name: link.name, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Check whether the specified Link is gave upvote.") {
                var isSucceeded = false
                let link = Link(id: self.testLinkId)
                self.session?.getInfo([link.name], completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        if let listing = result.value as? Listing {
                            for obj in listing.children {
                                if let incommingLink = obj as? Link {
                                    if let likes = incommingLink.likes {
                                        isSucceeded = (incommingLink.name == link.name && likes)
                                    }
                                }
                            }
                        }
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Test to give a downvote to the specified Link.") {
                var isSucceeded = false
                let link = Link(id: self.testLinkId)
                self.session?.setVote(VoteDirection.Down, name: link.name, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Check whether the specified Link is gave downvote.") {
                var isSucceeded = false
                let link = Link(id: self.testLinkId)
                self.session?.getInfo([link.name], completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        if let listing = result.value as? Listing {
                            for obj in listing.children {
                                if let incommingLink = obj as? Link {
                                    if let likes = incommingLink.likes {
                                        isSucceeded = (incommingLink.name == link.name && !likes)
                                    }
                                }
                            }
                        }
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Test to revoke voting to the specified Link.") {
                var isSucceeded = false
                let link = Link(id: self.testLinkId)
                self.session?.setVote(VoteDirection.No, name: link.name, completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        isSucceeded = true
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
            
            it("Check whether the downvote to the specified Link has benn revoked.") {
                var isSucceeded = false
                let link = Link(id: self.testLinkId)
                self.session?.getInfo([link.name], completion: { (result) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error!.description)
                    case .Success:
                        if let listing = result.value as? Listing {
                            for obj in listing.children {
                                if let incommingLink = obj as? Link {
                                    isSucceeded = (incommingLink.name == link.name && (incommingLink.likes == nil))
                                }
                            }
                        }
                    }
                })
                expect(isSucceeded).toEventually(equal(true), timeout: self.timeoutDuration, pollInterval: self.pollingInterval)
            }
        }
    }

}

