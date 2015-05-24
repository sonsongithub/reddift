//
//  ExtendCommentsTest.swift
//  reddift
//
//  Created by sonson on 2015/04/28.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Nimble
import Quick

class ExtendCommentsTest: QuickSpec {
    override func spec() {
        describe("List which has some comments including replies recursively,") {
            it("consists of 1 Link, 13 Comments and 9 Mores.") {
                let json:AnyObject? = self.jsonFromFileName("comments_extend.json")
                if let json:JSON = json {
                    if let array = Parser.parseJSON(json) as? [AnyObject] {
                        expect(array.count).to(equal(2))
                        if let listing = array[0] as? Listing {
                            for link in listing.children {
                                expect(link is Link).to(equal(true))
//                                let b = ((listing.children[0]).dynamicType === Link.Type)
//                                expect(b).to(equal(true))
                            }
                        }
                        if let listing = array[1] as? Listing {
                            var comments:[Any] = []
                            for obj in listing.children {
                                if let comment = obj as? Comment {
                                    comments += extendAllReplies(comment)
                                }
                                else {
                                    comments.append(obj)
                                }
                            }
                            let numberOfComments = comments.reduce(0, combine: { (value:Int, comment:Any) -> Int in
                                return comment is Comment ? 1 + value : value
                            })
                            let numberOfMores = comments.reduce(0, combine: { (value:Int, comment:Any) -> Int in
                                return comment is More ? 1 + value : value
                            })
                            expect(numberOfComments).to(equal(13))
                            expect(numberOfMores).to(equal(9))
                        }
                    }
                }
            }
        }
    }
}
