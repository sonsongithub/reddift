//
//  ParseThingObjectTest.swift
//  reddift
//
//  Created by sonson on 2015/04/22.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit
import XCTest

extension XCTestCase {
    func jsonFromFileName(name:String) -> AnyObject? {
        if let path = NSBundle(forClass: self.classForCoder).pathForResource(name, ofType:nil) {
            if let data = NSData(contentsOfFile: path) {
                if let json:AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil) {
                    return json
                }
            }
        }
        return nil
    }
}

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

    func testParseThing_t1() {
        let json:AnyObject? = self.jsonFromFileName("t1.json")
        if let json = json as? [String:AnyObject] {
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
        else {
            XCTFail("JSON error")
        }
    }
    
    func testParseThing_t2() {
        let json:AnyObject? = self.jsonFromFileName("t2.json")
        if let json = json as? [String:AnyObject] {
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
        else {
            XCTFail("JSON error")
        }
    }
    
    func testParseThing_t3() {
        let json:AnyObject? = self.jsonFromFileName("t3.json")
        if let json = json as? [String:AnyObject] {
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
                    
                    XCTAssertEqual(media.oembed.provider_url, "http://i.imgur.com", "check media's value.")
                    XCTAssertEqual(media.oembed.description, "The Internet's visual storytelling community. Explore, share, and discuss the best visual stories the Internet has to offer.", "check media's value.")
                    XCTAssertEqual(media.oembed.title, "Imgur GIF", "check media's value.")
                    XCTAssertEqual(media.oembed.html, "&lt;iframe class=\"embedly-embed\" src=\"//cdn.embedly.com/widgets/media.html?src=https%3A%2F%2Fi.imgur.com%2FnN5D1BT.mp4&amp;src_secure=1&amp;url=http%3A%2F%2Fi.imgur.com%2FnN5D1BT.gifv&amp;image=http%3A%2F%2Fi.imgur.com%2FnN5D1BT.gif&amp;key=2aa3c4d5f3de4f5b9120b660ad850dc9&amp;type=video%2Fmp4&amp;schema=imgur\" width=\"320\" height=\"568\" scrolling=\"no\" frameborder=\"0\" allowfullscreen&gt;&lt;/iframe&gt;", "check media's value.")
                    XCTAssertEqual(media.oembed.version, "1.0", "check media's value.")
                    XCTAssertEqual(media.oembed.provider_name, "Imgur", "check media's value.")
                    XCTAssertEqual(media.oembed.thumbnail_url, "http://i.imgur.com/nN5D1BT.gif", "check media's value.")
                    XCTAssertEqual(media.oembed.type, "video", "check media's value.")
                }
                
                // media embed
                XCTAssertTrue((object.media_embed != nil), "check media_embed's value.")
                if let media_embed = object.media_embed {
                    XCTAssertEqual(media_embed.content, "&lt;iframe class=\"embedly-embed\" src=\"//cdn.embedly.com/widgets/media.html?src=https%3A%2F%2Fi.imgur.com%2FnN5D1BT.mp4&amp;src_secure=1&amp;url=http%3A%2F%2Fi.imgur.com%2FnN5D1BT.gifv&amp;image=http%3A%2F%2Fi.imgur.com%2FnN5D1BT.gif&amp;key=2aa3c4d5f3de4f5b9120b660ad850dc9&amp;type=video%2Fmp4&amp;schema=imgur\" width=\"320\" height=\"568\" scrolling=\"no\" frameborder=\"0\" allowfullscreen&gt;&lt;/iframe&gt;", "check media_embed's value.")
                    XCTAssertEqual(media_embed.width, 320, "check media_embed's value.")
                    XCTAssertEqual(media_embed.height, 568, "check media_embed's value.")
                    XCTAssertEqual(media_embed.scrolling, false, "check media_embed's value.")
                }
            }
        }
        else {
            XCTFail("JSON error")
        }
    }
    
    func testParseThing_t4() {
        let json:AnyObject? = self.jsonFromFileName("t4.json")
        if let json = json as? [String:AnyObject] {
            var object = Parser.parseDataInThing_t4(json) as? Message
            XCTAssert(object != nil, "Not appropreate class")
            if let object = object {
                XCTAssertEqual(object.body, "Hello! [Hola!](https://www.reddit.com/r/reddit.com/wiki/templat.....", "check body's value.")
                XCTAssertEqual(object.was_comment, false, "check was_comment's value.")
                XCTAssertEqual(object.first_message, "", "check first_message's value.")
                XCTAssertEqual(object.name, "t4_36sfhx", "check name's value.")
                XCTAssertEqual(object.first_message_name, "", "check first_message_name's value.")
                XCTAssertEqual(object.created, 1427126074, "check created's value.")
                XCTAssertEqual(object.dest, "sonson_twit", "check dest's value.")
                XCTAssertEqual(object.author, "reddit", "check author's value.")
                XCTAssertEqual(object.created_utc, 1427122474, "check created_utc's value.")
                XCTAssertEqual(object.body_html, "&lt;!-- SC_.....", "check body_html's value.")
                XCTAssertEqual(object.subreddit, "", "check subreddit's value.")
                XCTAssertEqual(object.parent_id, "", "check parent_id's value.")
                XCTAssertEqual(object.context, "", "check context's value.")
                XCTAssertEqual(object.replies, "", "check replies's value.")
                XCTAssertEqual(object.id, "36sfhx", "check id's value.")
                XCTAssertEqual(object.new, false, "check new's value.")
                XCTAssertEqual(object.distinguished, "admin", "check distinguished's value.")
                XCTAssertEqual(object.subject, "Hello, /u/sonson_twit! Welcome to reddit!", "check subject's value.")
            }
        }
        else {
            XCTFail("JSON error")
        }
    }
    
    func testParseThing_t5() {
        let json:AnyObject? = self.jsonFromFileName("t5.json")
        if let json = json as? [String:AnyObject] {
            var object = Parser.parseDataInThing_t5(json) as? Subreddit
            XCTAssert(object != nil, "Not appropreate class")
            if let object = object {
                XCTAssertEqual(object.banner_img, "", "check banner_img's value.")
                XCTAssertEqual(object.user_sr_theme_enabled, true, "check user_sr_theme_enabled's value.")
                XCTAssertEqual(object.submit_text_html, "&lt;!-- SC_OFF --&gt;&lt;div class=\"md\"&gt;&lt;p&gt;&lt;strong&gt;GIFs are banned.&lt;/strong&gt;\nIf you want to post a GIF, please &lt;a href=\"http://imgur.com\"&gt;rehost it as a GIFV&lt;/a&gt; instead. &lt;a href=\"http://www.reddit.com/r/woahdude/wiki/html5\"&gt;(Read more)&lt;/a&gt;&lt;/p&gt;\n\n&lt;p&gt;&lt;strong&gt;Link flair is mandatory.&lt;/strong&gt;\nClick &amp;quot;Add flair&amp;quot; button after you submit. The button will be located under your post title. &lt;a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_flair_is_mandatory\"&gt;(read more)&lt;/a&gt;&lt;/p&gt;\n\n&lt;p&gt;&lt;strong&gt;XPOST labels are banned.&lt;/strong&gt;\nCrossposts are fine, just don&amp;#39;t label them as such. &lt;a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_.5Bxpost.5D_tags.2Flabels_are_banned\"&gt;(read more)&lt;/a&gt;&lt;/p&gt;\n\n&lt;p&gt;&lt;strong&gt;Trippy or Mesmerizing content only!&lt;/strong&gt;\nWhat is WoahDude-worthy content? &lt;a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_what_is_.22woahdude_material.22.3F\"&gt;(Read more)&lt;/a&gt;&lt;/p&gt;\n&lt;/div&gt;&lt;!-- SC_ON --&gt;", "check submit_text_html's value.")
                XCTAssertEqual(object.user_is_banned, false, "check user_is_banned's value.")
                XCTAssertEqual(object.id, "2r8tu", "check id's value.")
                XCTAssertEqual(object.submit_text, "**GIFs are banned.**\nIf you want to post a GIF, please [rehost it as a GIFV](http://imgur.com) instead. [(Read more)](http://www.reddit.com/r/woahdude/wiki/html5)\n\n**Link flair is mandatory.**\nClick \"Add flair\" button after you submit. The button will be located under your post title. [(read more)](http://www.reddit.com/r/woahdude/wiki/index#wiki_flair_is_mandatory)\n\n**XPOST labels are banned.**\nCrossposts are fine, just don't label them as such. [(read more)](http://www.reddit.com/r/woahdude/wiki/index#wiki_.5Bxpost.5D_tags.2Flabels_are_banned)\n\n**Trippy or Mesmerizing content only!**\nWhat is WoahDude-worthy content? [(Read more)](http://www.reddit.com/r/woahdude/wiki/index#wiki_what_is_.22woahdude_material.22.3F)", "check submit_text's value.")
                XCTAssertEqual(object.display_name, "woahdude", "check display_name's value.")
                XCTAssertEqual(object.header_img, "http://b.thumbs.redditmedia.com/fnO6IreM4s_Em4dTIU2HtmZ_NTw7dZdlCoaLvtKwbzM.png", "check header_img's value.")
                XCTAssertEqual(object.description_html, "&lt;!-- SC_OFF --&gt;&lt;div class=\"md\"&gt;&lt;h5&gt;&lt;a href=\"https://www.reddit.com/r/woahdude/comments/2qi1jh/best_of_rwoahdude_2014_results/?\"&gt;Best of WoahDude 2014 ⇦&lt;/a&gt;&lt;/h5&gt;\n\n&lt;p&gt;&lt;a href=\"#nyanbro\"&gt;&lt;/a&gt;&lt;/p&gt;\n\n&lt;h4&gt;&lt;strong&gt;What is WoahDude?&lt;/strong&gt;&lt;/h4&gt;\n\n&lt;p&gt;&lt;em&gt;The best links to click while you&amp;#39;re stoned!&lt;/em&gt; &lt;/p&gt;\n\n&lt;p&gt;Trippy &amp;amp; mesmerizing games, video, audio &amp;amp; images that make you go &amp;#39;woah dude!&amp;#39;&lt;/p&gt;\n\n&lt;p&gt;No one wants to have to sift through the entire internet for fun links when they&amp;#39;re stoned - so make this your one-stop shop!&lt;/p&gt;\n\n&lt;p&gt;⇨ &lt;a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_what_is_.22woahdude_material.22.3F\"&gt;more in-depth explanation here&lt;/a&gt; ⇦&lt;/p&gt;\n\n&lt;h4&gt;&lt;strong&gt;Filter WoahDude by flair&lt;/strong&gt;&lt;/h4&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair:picture&amp;amp;sort=top&amp;amp;restrict_sr=on\"&gt;picture&lt;/a&gt; - Static images&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair:wallpaper+OR+%5BWALLPAPER%5D&amp;amp;sort=top&amp;amp;restrict_sr=on\"&gt;wallpaper&lt;/a&gt; - PC or Smartphone&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair%3Agifv+OR+flair%3Awebm&amp;amp;restrict_sr=on&amp;amp;sort=top&amp;amp;t=all\"&gt;gifv&lt;/a&gt; - Animated images&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair:audio&amp;amp;sort=top&amp;amp;restrict_sr=on\"&gt;audio&lt;/a&gt; - Non-musical audio &lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair:music&amp;amp;sort=top&amp;amp;restrict_sr=on\"&gt;music&lt;/a&gt;  - Include: Band &amp;amp; Song Title&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair:musicvideo&amp;amp;sort=top&amp;amp;restrict_sr=on\"&gt;music video&lt;/a&gt; - If slideshow, tag [music] &lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair:video&amp;amp;sort=top&amp;amp;restrict_sr=on\"&gt;video&lt;/a&gt; - Non-musical video&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://redd.it/29owi1#movies\"&gt;movies&lt;/a&gt; - Movies&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair:game&amp;amp;restrict_sr=on&amp;amp;sort=top&amp;amp;t=all\"&gt;game&lt;/a&gt; - Goal oriented games&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair%3Ainteractive+OR+sandbox&amp;amp;sort=top&amp;amp;restrict_sr=on&amp;amp;t=all\"&gt;interactive&lt;/a&gt; - Interactive pages&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/comments/1jri9s/woahdude_featured_apps_get_free_download_codes/\"&gt;mobile app&lt;/a&gt; - Mod-curated selection of apps&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/WoahDude/search?q=flair%3Atext&amp;amp;restrict_sr=on&amp;amp;sort=top&amp;amp;t=all\"&gt;text&lt;/a&gt; - Articles, selfposts &amp;amp; textpics&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair%3Awoahdude%2Bapproved&amp;amp;sort=new&amp;amp;restrict_sr=on&amp;amp;t=all\"&gt;WOAHDUDE APPROVED&lt;/a&gt; - Mod-curated selection of the best WoahDude submissions.&lt;/p&gt;\n\n&lt;h4&gt;RULES  &lt;a href=\"http://www.reddit.com/r/woahdude/wiki\"&gt;⇨ FULL VERSION&lt;/a&gt;&lt;/h4&gt;\n\n&lt;blockquote&gt;\n&lt;ol&gt;\n&lt;li&gt;LINK FLAIR &lt;strong&gt;is &lt;a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_flair_is_mandatory\"&gt;mandatory&lt;/a&gt;.&lt;/strong&gt;&lt;/li&gt;\n&lt;li&gt;XPOST &lt;strong&gt;labels are &lt;a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_.5Bxpost.5D_tags.2Flabels_are_banned\"&gt;banned&lt;/a&gt;. Crossposts are fine, just don&amp;#39;t label them as such.&lt;/strong&gt;&lt;/li&gt;\n&lt;li&gt; NO &lt;strong&gt;hostility!&lt;/strong&gt; PLEASE &lt;strong&gt;giggle like a giraffe :)&lt;/strong&gt;&lt;/li&gt;\n&lt;/ol&gt;\n&lt;/blockquote&gt;\n\n&lt;p&gt;Certain reposts are allowed. &lt;a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_reposts\"&gt;Learn more&lt;/a&gt;. Those not allowed may be reported via this form:&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/message/compose?to=%2Fr%2Fwoahdude&amp;amp;subject=Repost%20Report&amp;amp;message=Here%20%5bLINK%5d%20is%20an%20illegitimate%20repost,%20and%20here%20%5bLINK%5d%20is%20proof%20that%20the%20original%20woahdude%20post%20had%201500%2b%20upvotes.#reportwarning\"&gt;&lt;/a&gt; &lt;a href=\"http://www.reddit.com/message/compose?to=%2Fr%2Fwoahdude&amp;amp;subject=Repost%20Report&amp;amp;message=Here%20%5bLINK%5d%20is%20an%20illegitimate%20repost,%20and%20here%20%5bLINK%5d%20is%20proof%20that%20the%20original%20woahdude%20post%20had%201500%2b%20upvotes.\"&gt;&lt;strong&gt;REPORT AN ILLEGITIMATE REPOST&lt;/strong&gt;&lt;/a&gt;&lt;/p&gt;\n\n&lt;h4&gt;WoahDude community&lt;/h4&gt;\n\n&lt;ul&gt;\n&lt;li&gt;&lt;a href=\"/r/WoahDude\"&gt;/r/WoahDude&lt;/a&gt; - All media&lt;/li&gt;\n&lt;li&gt;&lt;a href=\"/r/WoahTube\"&gt;/r/WoahTube&lt;/a&gt; - Videos only&lt;/li&gt;\n&lt;li&gt;&lt;a href=\"/r/WoahTunes\"&gt;/r/WoahTunes&lt;/a&gt; - Music only&lt;/li&gt;\n&lt;li&gt;&lt;a href=\"/r/StonerPhilosophy\"&gt;/r/StonerPhilosophy&lt;/a&gt; - Text posts only&lt;/li&gt;\n&lt;li&gt;&lt;a href=\"/r/WoahPoon\"&gt;/r/WoahPoon&lt;/a&gt; - NSFW&lt;/li&gt;\n&lt;li&gt;&lt;strong&gt;&lt;a href=\"http://www.reddit.com/user/rWoahDude/m/woahdude\"&gt;MULTIREDDIT&lt;/a&gt;&lt;/strong&gt;&lt;/li&gt;\n&lt;/ul&gt;\n\n&lt;h5&gt;&lt;a href=\"http://facebook.com/rWoahDude\"&gt;&lt;/a&gt;&lt;/h5&gt;\n\n&lt;h5&gt;&lt;a href=\"http://twitter.com/rWoahDude\"&gt;&lt;/a&gt;&lt;/h5&gt;\n\n&lt;h5&gt;&lt;a href=\"http://emilydavis.bandcamp.com/track/sagans-song\"&gt;http://emilydavis.bandcamp.com/track/sagans-song&lt;/a&gt;&lt;/h5&gt;\n&lt;/div&gt;&lt;!-- SC_ON --&gt;", "check description_html's value.")
                XCTAssertEqual(object.title, "The BEST links to click while you're STONED", "check title's value.")
                XCTAssertEqual(object.collapse_deleted_comments, true, "check collapse_deleted_comments's value.")
                XCTAssertEqual(object.over18, false, "check over18's value.")
                XCTAssertEqual(object.public_description_html, "&lt;!-- SC_OFF --&gt;&lt;div class=\"md\"&gt;&lt;p&gt;The best links to click while you&amp;#39;re stoned!&lt;/p&gt;\n\n&lt;p&gt;Trippy, mesmerizing, and mindfucking games, video, audio &amp;amp; images that make you go &amp;#39;woah dude!&amp;#39;&lt;/p&gt;\n\n&lt;p&gt;If you like to look at amazing stuff while smoking weed or doing other drugs, come inside for some Science, Philosophy, Mindfucks, Math, Engineering, Illusions and Cosmic weirdness.&lt;/p&gt;\n&lt;/div&gt;&lt;!-- SC_ON --&gt;", "check public_description_html's value.")
                XCTAssertEqual(object.icon_size, [145, 60], "check icon_size's value.")
                XCTAssertEqual(object.icon_img, "", "check icon_img's value.")
                XCTAssertEqual(object.header_title, "Turn on the stylesheet and click Carl Sagan's head", "check header_title's value.")
                XCTAssertEqual(object.description, "#####[Best of WoahDude 2014 ⇦](https://www.reddit.com/r/woahdude/comments/2qi1jh/best_of_rwoahdude_2014_results/?)\n\n[](#nyanbro)\n\n####**What is WoahDude?**\n\n*The best links to click while you're stoned!* \n\nTrippy &amp; mesmerizing games, video, audio &amp; images that make you go 'woah dude!'\n\nNo one wants to have to sift through the entire internet for fun links when they're stoned - so make this your one-stop shop!\n\n⇨ [more in-depth explanation here](http://www.reddit.com/r/woahdude/wiki/index#wiki_what_is_.22woahdude_material.22.3F) ⇦\n\n####**Filter WoahDude by flair**\n\n[picture](http://www.reddit.com/r/woahdude/search?q=flair:picture&amp;sort=top&amp;restrict_sr=on) - Static images\n\n[wallpaper](http://www.reddit.com/r/woahdude/search?q=flair:wallpaper+OR+[WALLPAPER]&amp;sort=top&amp;restrict_sr=on) - PC or Smartphone\n\n[gifv](http://www.reddit.com/r/woahdude/search?q=flair%3Agifv+OR+flair%3Awebm&amp;restrict_sr=on&amp;sort=top&amp;t=all) - Animated images\n\n[audio](http://www.reddit.com/r/woahdude/search?q=flair:audio&amp;sort=top&amp;restrict_sr=on) - Non-musical audio \n\n[music](http://www.reddit.com/r/woahdude/search?q=flair:music&amp;sort=top&amp;restrict_sr=on)  - Include: Band &amp; Song Title\n\n[music video](http://www.reddit.com/r/woahdude/search?q=flair:musicvideo&amp;sort=top&amp;restrict_sr=on) - If slideshow, tag [music] \n\n[video](http://www.reddit.com/r/woahdude/search?q=flair:video&amp;sort=top&amp;restrict_sr=on) - Non-musical video\n\n[movies](http://redd.it/29owi1#movies) - Movies\n\n[game](http://www.reddit.com/r/woahdude/search?q=flair:game&amp;restrict_sr=on&amp;sort=top&amp;t=all) - Goal oriented games\n\n[interactive](http://www.reddit.com/r/woahdude/search?q=flair%3Ainteractive+OR+sandbox&amp;sort=top&amp;restrict_sr=on&amp;t=all) - Interactive pages\n\n[mobile app](http://www.reddit.com/r/woahdude/comments/1jri9s/woahdude_featured_apps_get_free_download_codes/) - Mod-curated selection of apps\n\n[text](http://www.reddit.com/r/WoahDude/search?q=flair%3Atext&amp;restrict_sr=on&amp;sort=top&amp;t=all) - Articles, selfposts &amp; textpics\n\n[WOAHDUDE APPROVED](http://www.reddit.com/r/woahdude/search?q=flair%3Awoahdude%2Bapproved&amp;sort=new&amp;restrict_sr=on&amp;t=all) - Mod-curated selection of the best WoahDude submissions.\n\n####RULES  [⇨ FULL VERSION](http://www.reddit.com/r/woahdude/wiki) \n\n&gt; 1. LINK FLAIR **is [mandatory](http://www.reddit.com/r/woahdude/wiki/index#wiki_flair_is_mandatory).**\n2. XPOST **labels are [banned](http://www.reddit.com/r/woahdude/wiki/index#wiki_.5Bxpost.5D_tags.2Flabels_are_banned). Crossposts are fine, just don't label them as such.**\n3.  NO **hostility!** PLEASE **giggle like a giraffe :)**\n\nCertain reposts are allowed. [Learn more](http://www.reddit.com/r/woahdude/wiki/index#wiki_reposts). Those not allowed may be reported via this form:\n\n[](http://www.reddit.com/message/compose?to=%2Fr%2Fwoahdude&amp;subject=Repost%20Report&amp;message=Here%20%5bLINK%5d%20is%20an%20illegitimate%20repost,%20and%20here%20%5bLINK%5d%20is%20proof%20that%20the%20original%20woahdude%20post%20had%201500%2b%20upvotes.#reportwarning) [**REPORT AN ILLEGITIMATE REPOST**](http://www.reddit.com/message/compose?to=%2Fr%2Fwoahdude&amp;subject=Repost%20Report&amp;message=Here%20%5bLINK%5d%20is%20an%20illegitimate%20repost,%20and%20here%20%5bLINK%5d%20is%20proof%20that%20the%20original%20woahdude%20post%20had%201500%2b%20upvotes.)\n\n####WoahDude community\n\n* /r/WoahDude - All media\n* /r/WoahTube - Videos only\n* /r/WoahTunes - Music only\n* /r/StonerPhilosophy - Text posts only\n* /r/WoahPoon - NSFW\n* **[MULTIREDDIT](http://www.reddit.com/user/rWoahDude/m/woahdude)**\n\n#####[](http://facebook.com/rWoahDude)\n#####[](http://twitter.com/rWoahDude)\n\n#####http://emilydavis.bandcamp.com/track/sagans-song", "check description's value.")
                XCTAssertEqual(object.submit_link_label, "SUBMIT LINK", "check submit_link_label's value.")
                XCTAssertEqual(object.accounts_active, 0, "check accounts_active's value.")
                XCTAssertEqual(object.public_traffic, false, "check public_traffic's value.")
                XCTAssertEqual(object.header_size, [145, 60], "check header_size's value.")
                XCTAssertEqual(object.subscribers, 778611, "check subscribers's value.")
                XCTAssertEqual(object.submit_text_label, "SUBMIT TEXT", "check submit_text_label's value.")
                XCTAssertEqual(object.user_is_moderator, false, "check user_is_moderator's value.")
                XCTAssertEqual(object.name, "t5_2r8tu", "check name's value.")
                XCTAssertEqual(object.created, 1254666760, "check created's value.")
                XCTAssertEqual(object.url, "/r/woahdude/", "check url's value.")
                XCTAssertEqual(object.hide_ads, false, "check hide_ads's value.")
                XCTAssertEqual(object.created_utc, 1254663160, "check created_utc's value.")
                XCTAssertEqual(object.banner_size, [], "check banner_size's value.")
                XCTAssertEqual(object.user_is_contributor, false, "check user_is_contributor's value.")
                XCTAssertEqual(object.public_description, "The best links to click while you're stoned!\n\nTrippy, mesmerizing, and mindfucking games, video, audio &amp; images that make you go 'woah dude!'\n\nIf you like to look at amazing stuff while smoking weed or doing other drugs, come inside for some Science, Philosophy, Mindfucks, Math, Engineering, Illusions and Cosmic weirdness.\n\n", "check public_description's value.")
                XCTAssertEqual(object.comment_score_hide_mins, 0, "check comment_score_hide_mins's value.")
                XCTAssertEqual(object.subreddit_type, "public", "check subreddit_type's value.")
                XCTAssertEqual(object.submission_type, "any", "check submission_type's value.")
                XCTAssertEqual(object.user_is_subscriber, true, "check user_is_subscriber's value.")
            }
        }
        else {
            XCTFail("JSON error")
        }
    }
    
    func testParseThing_more() {
        let json:AnyObject? = self.jsonFromFileName("more.json")
        if let json = json as? [String:AnyObject] {
            var object = Parser.parseDataInThing_more(json) as? More
            XCTAssert(object != nil, "Not appropreate class")
            if let object = object {
                XCTAssertEqual(object.count, 0, "check count's value.")
                XCTAssertEqual(object.parent_id, "t1_cp88kh5", "check parent_id's value.")
                XCTAssertEqual(object.children, ["cpddp7v", "cp8jvj8", "cp8cv4b"], "check children's value.")
                XCTAssertEqual(object.name, "t1_cpddp7v", "check name's value.")
                XCTAssertEqual(object.id, "cpddp7v", "check id's value.")
            }
        }
        else {
            XCTFail("JSON error")
        }
    }
}
