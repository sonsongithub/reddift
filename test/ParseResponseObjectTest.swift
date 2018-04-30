//
//  response2DataObjectTest.swift
//  reddift
//
//  Created by sonson on 2015/04/22.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import XCTest

class response2DataObjectTest: XCTestCase {
        
    func testWhenErrorJsonWhichIsNotResponseFromRmoteIsLoaded() {
//        print("output is nil")
        for fileName in ["error.json", "t1.json", "t2.json", "t3.json", "t4.json", "t5.json"] {
            var isSucceeded = false
            if let json = self.jsonFromFileName(fileName) {
                let object: Any? = Parser.redditAny(from: json)
                XCTAssert(object == nil)
                isSucceeded = true
            }
            XCTAssert(isSucceeded == true)
        }
    }
    
    func testCommentsJsonFile() {
//        print("has 1 Link and 26 Comments")
        if let json = self.jsonFromFileName("comments.json") {
            if let objects = Parser.redditAny(from: json) as? [JSONAny] {
                XCTAssert(objects.count == 2)
                if let links = objects[0] as? Listing {
                    XCTAssert(links.children.count == 1)
                    XCTAssert(links.children[0] is Link == true)
                }
                if let comments = objects[1] as? Listing {
                    for comment in comments.children {
                        XCTAssert(comment is Comment == true)
                    }
                    XCTAssert(comments.children.count == 26)
                }
            } else { XCTFail("can not parse JSON") }
        }
    }
    
    func testLinksJsonFile() {
//        print("has 26 Links")
        if let json = self.jsonFromFileName("links.json") {
            if let listing = Parser.redditAny(from: json) as? Listing {
                XCTAssert(listing.children.count == 26)
                for child in listing.children {
                    XCTAssert(child is Link == true)
                }
            } else { XCTFail("can not parse JSON") }
        }
    }
    
    func testMessageJsonFile() {
//        print("has 4 entries, Comment, Comment, Comment, Message.")
        if let json = self.jsonFromFileName("message.json") {
            if let listing = Parser.redditAny(from: json) as? Listing {
                XCTAssert(listing.children.count == 4)
                XCTAssert(listing.children[0] is Comment == true)
                XCTAssert(listing.children[1] is Comment == true)
                XCTAssert(listing.children[2] is Comment == true)
                XCTAssert(listing.children[3] is Message == true)
            } else { XCTFail("can not parse JSON") }
        }
    }
            
    func testSubredditJsonFile() {
//        print("has 5 Subreddits.")
        if let json = self.jsonFromFileName("subreddit.json") {
            if let listing = Parser.redditAny(from: json) as? Listing {
                XCTAssert(listing.children.count == 5)
                for child in listing.children {
                    XCTAssert(child is Subreddit == true)
                }
            } else { XCTFail("can not parse JSON") }
        }
    }

    func testParseJSONIsResponseToPostingComment() {
//        print("To t1 object as Comment")
        var isSucceeded = false
        if let json = self.jsonFromFileName("api_comment_response.json") {
            let result = json2Comment(from: json)
            switch result {
            case .success:
                isSucceeded = true
            case .failure:
                break
            }
        }
        XCTAssert(isSucceeded == true)
    }
    
    func testParseJSONWhichContainsMulti() {
//        print("Must have 2 Multi objects")
        if let json = self.jsonFromFileName("multi.json") {
            if let array = Parser.redditAny(from: json) as? [Any] {
                if array.count == 0 { XCTFail("can not parse JSON") }
                for obj in array {
                    XCTAssert(obj is Multireddit == true)
                }
            } else { XCTFail("can not parse JSON") }
        }
    }
    
    func testParsingUserList() {
        if let json = self.jsonFromFileName("UserList.json") as? JSONDictionary {
            if let userlist = Parser.redditAny(from: json) as? [User] {
                if userlist.count == 0 { XCTFail("can not parse JSON") }
                
                XCTAssert(userlist[0].date == 1382991535)
                XCTAssert(userlist[0].modPermissions.count == 0)
                XCTAssert(userlist[0].name == "PicsMod")
                XCTAssert(userlist[0].id == "t2_5onsi")
                
                XCTAssert(userlist[1].date == 1415392097)
                XCTAssert(userlist[1].modPermissions.hasSameElements([UserModPermission.all]))
                XCTAssert(userlist[1].name == "cwenham")
                XCTAssert(userlist[1].id == "t2_2fpn")
                
                XCTAssert(userlist[2].date == 1445810001)
                XCTAssert(userlist[2].modPermissions.hasSameElements([UserModPermission.wiki, UserModPermission.posts, UserModPermission.mail, UserModPermission.flair]))
                XCTAssert(userlist[2].name == "adeadhead")
                XCTAssert(userlist[2].id == "t2_5tt1l")
            } else { XCTFail("can not parse JSON") }
        }
    }
    
    func testParsingTrophyList() {
        if let json = self.jsonFromFileName("TrophyList.json") as? JSONDictionary {
            if let trophylist = Parser.redditAny(from: json) as? [Trophy] {
                if trophylist.count == 0 { XCTFail("can not parse JSON") }
                
                XCTAssert(trophylist[0].id == "10wnxy")
                XCTAssert(trophylist[0].description == "")
                XCTAssert(trophylist[0].url == nil)
                XCTAssert(trophylist[0].icon40 == URL(string: "https://s3.amazonaws.com/redditstatic/award/n00b-40.png")!)
                XCTAssert(trophylist[0].icon70 == URL(string: "https://s3.amazonaws.com/redditstatic/award/n00b-70.png")!)
                XCTAssert(trophylist[0].awardID == "j")
                XCTAssert(trophylist[0].title == "New User")
            } else { XCTFail("can not parse JSON") }
        }
    }
    
    func testParsingMoreChildrenJson() {
        if let json = self.jsonFromFileName("moreChildren.json") as? JSONDictionary {
            let (list, error) = Parser.commentAndMore(from: json)
            if let error = error {
                XCTFail(error.description)
            } else if list.count != 7 {
                XCTFail("Failed to paser, result is vacant list.")
            } else {
                /// Check dynamic type
                XCTAssert(list[0] is Comment)
                XCTAssert(list[1] is Comment)
                XCTAssert(list[2] is Comment)
                XCTAssert(list[3] is Comment)
                XCTAssert(list[4] is Comment)
                XCTAssert(list[5] is Comment)
                XCTAssert(list[6] is More)
                
                /// Check ID
                XCTAssert(list[0].name == "t1_c6b0qgj")
                XCTAssert(list[1].name == "t1_c6b0scf")
                XCTAssert(list[2].name == "t1_c6b0vo7")
                XCTAssert(list[3].name == "t1_c6b0yyz")
                XCTAssert(list[4].name == "t1_c6b1sc7")
                XCTAssert(list[5].name == "t1_c6b1urd")
                XCTAssert(list[6].name == "t1_c6b21ja")
            }
        }
    }
}
