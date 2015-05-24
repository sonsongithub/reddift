//
//  SubredditTest.swift
//  reddift
//
//  Created by sonson on 2015/05/25.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Nimble
import Quick

class SubredditTest : SessionTestSpec {
    override func spec() {
        beforeEach { () -> () in
            self.createSession()
        }
        
        describe("Test Sticky of the subreddit") {
            it("Get sticky link") {
//                var subreddit = Subreddit()
//                self.session?.getSticky(<#subreddit: Subreddit#>, completion: <#(Result<JSON>) -> Void##(Result<JSON>) -> Void#>)
            }
        }
    }
}
