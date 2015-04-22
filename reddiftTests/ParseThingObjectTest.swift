//
//  ParseThingObjectTest.swift
//  reddift
//
//  Created by sonson on 2015/04/22.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit
import XCTest

/**
Test for parsing JSON data of "Thing".
Test data files are t1.json, t2.json, t3.json, t4.json, t5.json and more.json.
*/
class ParseThingObjectTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func jsonFromFileName(name:String) -> [String:AnyObject]? {
        if let path = NSBundle(forClass: self.classForCoder).pathForResource(name, ofType:nil) {
            if let data = NSData(contentsOfFile: path) {
                if let json = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) as? [String:AnyObject] {
                    return json
                }
            }
        }
        return nil
    }

    func testParseThing_t1() {
        let json = self.jsonFromFileName("t1.json")!
        var object = Parser.parseDataInThing_t1(json) as? Comment
        XCTAssert(object != nil, "Not appropreate class")
        if let object = object {
            XCTAssertEqual(object.subreddit_id, "t5_2qizd", "check subreddit_id's value.")
            XCTAssertEqual(object.banned_by, "", "check banned_by's value.")
            XCTAssertEqual(object.link_id, "t3_32wnhw", "check link_id's value.")
            XCTAssertEqual(object.likes, "", "check likes's value.")
            XCTAssertEqual(object.user_reports.count, 0, "check user_reports's value.")
            XCTAssertEqual(object.saved, false, "check saved's value.")
            XCTAssertEqual(object.id, "cqfhkcb", "check id's value.")
            XCTAssertEqual(object.gilded, 0, "check gilded's value.")
            XCTAssertEqual(object.archived, false, "check archived's value.")
            XCTAssertEqual(object.report_reasons.count, 0, "check report_reasons's value.")
            XCTAssertEqual(object.author, "Icnoyotl", "check author's value.")
            XCTAssertEqual(object.parent_id, "t1_cqfh5kz", "check parent_id's value.")
            XCTAssertEqual(object.score, 1, "check score's value.")
            XCTAssertEqual(object.approved_by, "", "check approved_by's value.")
            XCTAssertEqual(object.controversiality, 0, "check controversiality's value.")
            XCTAssertEqual(object.body, "The bot has been having this problem for awhile, there have been thousands of new comments since it last worked properly, so it seems like this must be something recurring? Could it have something to do with our AutoModerator?", "check body's value.")
            XCTAssertEqual(object.edited, false, "check edited's value.")
            XCTAssertEqual(object.author_flair_css_class, "", "check author_flair_css_class's value.")
            XCTAssertEqual(object.downs, 0, "check downs's value.")
            XCTAssertEqual(object.body_html, "&lt;div class=\"md\"&gt;&lt;p&gt;The bot has been having this problem for awhile, there have been thousands of new comments since it last worked properly, so it seems like this must be something recurring? Could it have something to do with our AutoModerator?&lt;/p&gt;\n&lt;/div&gt;", "check body_html's value.")
            XCTAssertEqual(object.subreddit, "redditdev", "check subreddit's value.")
            XCTAssertEqual(object.score_hidden, false, "check score_hidden's value.")
            XCTAssertEqual(object.name, "t1_cqfhkcb", "check name's value.")
            XCTAssertEqual(object.created, 1429284845, "check created's value.")
            XCTAssertEqual(object.author_flair_text, "", "check author_flair_text's value.")
            XCTAssertEqual(object.created_utc, 1429281245, "check created_utc's value.")
            XCTAssertEqual(object.distinguished, false, "check distinguished's value.")
            XCTAssertEqual(object.mod_reports.count, 0, "check mod_reports's value.")
            XCTAssertEqual(object.num_reports, 0, "check num_reports's value.")
            XCTAssertEqual(object.ups, 1, "check ups's value.")
            
            if let listing = object.replies as? Listing {
                XCTAssertEqual(listing.children.count, 1, "check replies' value.")
                if let more = listing.children[0] as? More {
                    XCTAssertEqual(more.count, 0, "check replies' value.")
                    XCTAssertEqual(more.parent_id, "t1_cqfhkcb", "check replies' value.")
                    XCTAssertEqual(more.name, "t1_cqfmmpp", "check replies' value.")
                    XCTAssertEqual(more.id, "cqfmmpp", "check replies' value.")
                    XCTAssertEqual(more.children.count, 1, "check replies' value.")
                    XCTAssertEqual(more.children[0], "cqfmmpp", "check replies' value.")
                    XCTAssertEqual(listing.after, "", "check replies' value.")
                    XCTAssertEqual(listing.before, "", "check replies' value.")
                                        
//                    "provider_url": "http://i.imgur.com",
//                    "description": "The Internet's visual storytelling community. Explore, share, and discuss the best visual stories the Internet has to offer.",
//                    "title": "Imgur GIF",
//                    "html": "&lt;iframe class=\"embedly-embed\" src=\"//cdn.embedly.com/widgets/media.html?src=https%3A%2F%2Fi.imgur.com%2FnN5D1BT.mp4&amp;src_secure=1&amp;url=http%3A%2F%2Fi.imgur.com%2FnN5D1BT.gifv&amp;image=http%3A%2F%2Fi.imgur.com%2FnN5D1BT.gif&amp;key=2aa3c4d5f3de4f5b9120b660ad850dc9&amp;type=video%2Fmp4&amp;schema=imgur\" width=\"320\" height=\"568\" scrolling=\"no\" frameborder=\"0\" allowfullscreen&gt;&lt;/iframe&gt;",
//                    "version": "1.0",
//                    "provider_name": "Imgur",
//                    "thumbnail_url": "http://i.imgur.com/nN5D1BT.gif",
//                    "type": "video",
                }
                else {
                    XCTFail("check replies' value.")
                }
            }
            else {
                XCTFail("check replies' value.")
            }
        }
    }
    
    func testParseThing_t2() {
        let json = self.jsonFromFileName("t2.json")!
        var object = Parser.parseDataInThing_t2(json) as? Account
        XCTAssert(object != nil, "Not appropreate class")
        if let object = object {
            XCTAssertEqual(object.has_mail, false, "check has_mail's value.")
            XCTAssertEqual(object.name, "sonson_twit", "check name's value.")
            XCTAssertEqual(object.created, 1427126074, "check created's value.")
            XCTAssertEqual(object.hide_from_robots, false, "check hide_from_robots's value.")
            XCTAssertEqual(object.gold_creddits, 0, "check gold_creddits's value.")
            XCTAssertEqual(object.created_utc, 1427122474, "check created_utc's value.")
            XCTAssertEqual(object.has_mod_mail, false, "check has_mod_mail's value.")
            XCTAssertEqual(object.link_karma, 1, "check link_karma's value.")
            XCTAssertEqual(object.comment_karma, 1, "check comment_karma's value.")
            XCTAssertEqual(object.over_18, true, "check over_18's value.")
            XCTAssertEqual(object.is_gold, false, "check is_gold's value.")
            XCTAssertEqual(object.is_mod, false, "check is_mod's value.")
            XCTAssertEqual(object.gold_expiration, false, "check gold_expiration's value.")
            XCTAssertEqual(object.has_verified_email, false, "check has_verified_email's value.")
            XCTAssertEqual(object.id, "mfsh8", "check id's value.")
            XCTAssertEqual(object.inbox_count, 0, "check inbox_count's value.")
        }
    }
    
    func testParseThing_t3() {
        let json = self.jsonFromFileName("t3.json")!
        var object = Parser.parseDataInThing_t3(json) as? Link
        XCTAssert(object != nil, "Not appropreate class")
        if let object = object {
            XCTAssertEqual(object.domain, "self.redditdev", "check domain's value.")
            XCTAssertEqual(object.banned_by, "", "check banned_by's value.")
            XCTAssertEqual(object.subreddit, "redditdev", "check subreddit's value.")
            XCTAssertEqual(object.selftext_html, "&lt;!-- SC_OFF --&gt;&lt;div class=\"md\"&gt;&lt;p&gt;So this is the code I ran:&lt;/p&gt;\n\n&lt;pre&gt;&lt;code&gt;r = praw.Reddit(&amp;quot;/u/habnpam sflkajsfowifjsdlkfj test test test&amp;quot;)\n\n\nfor c in praw.helpers.comment_stream(reddit_session=r, subreddit=&amp;quot;helpmefind&amp;quot;, limit=500, verbosity=1):\n    print(c.author)\n&lt;/code&gt;&lt;/pre&gt;\n\n&lt;hr/&gt;\n\n&lt;p&gt;From what I understand, comment_stream() gets the most recent comments. So if we specify the limit to be 100, it will initially get the 100 newest comment, and then constantly update to get new comments.  It seems to works appropriately for every subreddit except &lt;a href=\"/r/helpmefind\"&gt;/r/helpmefind&lt;/a&gt;. For &lt;a href=\"/r/helpmefind\"&gt;/r/helpmefind&lt;/a&gt;, it fetches around 30 comments, regardless of the limit.&lt;/p&gt;\n&lt;/div&gt;&lt;!-- SC_ON --&gt;", "check selftext_html's value.")
            XCTAssertEqual(object.selftext, "So this is the code I ran:\n\n    r = praw.Reddit(\"/u/habnpam sflkajsfowifjsdlkfj test test test\")\n    \n\n    for c in praw.helpers.comment_stream(reddit_session=r, subreddit=\"helpmefind\", limit=500, verbosity=1):\n        print(c.author)\n\n\n---\n\nFrom what I understand, comment_stream() gets the most recent comments. So if we specify the limit to be 100, it will initially get the 100 newest comment, and then constantly update to get new comments.  It seems to works appropriately for every subreddit except /r/helpmefind. For /r/helpmefind, it fetches around 30 comments, regardless of the limit.", "check selftext's value.")
            XCTAssertTrue((object.likes == nil), "check likes's value.")
            XCTAssertEqual(object.user_reports.count, 0, "check user_reports's value.")
            XCTAssertTrue((object.secure_media == nil), "check secure_media's value.")
            XCTAssertEqual(object.link_flair_text, "", "check link_flair_text's value.")
            XCTAssertEqual(object.id, "32wnhw", "check id's value.")
            XCTAssertEqual(object.gilded, 0, "check gilded's value.")
            XCTAssertEqual(object.archived, false, "check archived's value.")
            XCTAssertEqual(object.clicked, false, "check clicked's value.")
            XCTAssertEqual(object.report_reasons.count, 0, "check report_reasons's value.")
            XCTAssertEqual(object.author, "habnpam", "check author's value.")
            XCTAssertEqual(object.num_comments, 10, "check num_comments's value.")
            XCTAssertEqual(object.score, 2, "check score's value.")
            XCTAssertEqual(object.approved_by, "", "check approved_by's value.")
            XCTAssertEqual(object.over_18, false, "check over_18's value.")
            XCTAssertEqual(object.hidden, false, "check hidden's value.")
            XCTAssertEqual(object.thumbnail, "", "check thumbnail's value.")
            XCTAssertEqual(object.subreddit_id, "t5_2qizd", "check subreddit_id's value.")
            XCTAssertEqual(object.edited, false, "check edited's value.")
            XCTAssertEqual(object.link_flair_css_class, "", "check link_flair_css_class's value.")
            XCTAssertEqual(object.author_flair_css_class, "", "check author_flair_css_class's value.")
            XCTAssertEqual(object.downs, 0, "check downs's value.")
            XCTAssertEqual(object.mod_reports.count, 0, "check mod_reports's value.")
            XCTAssertTrue((object.secure_media_embed == nil), "check secure_media_embed's value.")
            XCTAssertEqual(object.saved, false, "check saved's value.")
            XCTAssertEqual(object.is_self, true, "check is_self's value.")
            XCTAssertEqual(object.name, "t3_32wnhw", "check name's value.")
            XCTAssertEqual(object.permalink, "/r/redditdev/comments/32wnhw/praw_comment_stream_messes_up_when_getting/", "check permalink's value.")
            XCTAssertEqual(object.stickied, false, "check stickied's value.")
            XCTAssertEqual(object.created, 1429292148, "check created's value.")
            XCTAssertEqual(object.url, "http://www.reddit.com/r/redditdev/comments/32wnhw/praw_comment_stream_messes_up_when_getting/", "check url's value.")
            XCTAssertEqual(object.author_flair_text, "", "check author_flair_text's value.")
            XCTAssertEqual(object.title, "[PRAW] comment_stream() messes up when getting comments from a certain subreddit.", "check title's value.")
            XCTAssertEqual(object.created_utc, 1429263348, "check created_utc's value.")
            XCTAssertEqual(object.ups, 2, "check ups's value.")
            XCTAssertEqual(object.upvote_ratio, 0.75, "check upvote_ratio's value.")
            XCTAssertEqual(object.visited, false, "check visited's value.")
            XCTAssertEqual(object.num_reports, 0, "check num_reports's value.")
            XCTAssertEqual(object.distinguished, false, "check distinguished's value.")
            
            // media
            XCTAssertTrue((object.media != nil), "check media's value.")
            if let media = object.media {
                XCTAssertEqual(media.type, "i.imgur.com", "check media's value.")
                XCTAssertEqual(media.oembed.width, 320, "check media's value.")
                XCTAssertEqual(media.oembed.height, 568, "check media's value.")
                XCTAssertEqual(media.oembed.thumbnail_width, 320, "check media's value.")
                XCTAssertEqual(media.oembed.thumbnail_height, 568, "check media's value.")
            }
            XCTAssertTrue((object.media_embed != nil), "check media_embed's value.")
        }
    }
    
    func testParseThing_t4() {
        let json = self.jsonFromFileName("t4.json")!
        var object = Parser.parseDataInThing_t4(json) as? Message
        XCTAssert(object != nil, "Not appropreate class")
        if let object = object {
        }
    }
    
    func testParseThing_t5() {
        let json = self.jsonFromFileName("t5.json")!
        var object = Parser.parseDataInThing_t5(json) as? Subreddit
        XCTAssert(object != nil, "Not appropreate class")
        if let object = object {
        }
    }
    
    
    func testParseThing_more() {
        let json = self.jsonFromFileName("more.json")!
        var object = Parser.parseDataInThing_more(json) as? More
        XCTAssert(object != nil, "Not appropreate class")
        if let object = object {
        }
    }

}
