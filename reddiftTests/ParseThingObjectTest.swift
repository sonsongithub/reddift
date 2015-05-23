//
//  ParseThingObjectTest.swift
//  reddift
//
//  Created by sonson on 2015/04/22.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Quick
import Nimble

extension QuickSpec {
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
class ParseThingObjectTest: QuickSpec {
    override func spec() {
        describe("Parsing t1 json file") {
            it("Each property of t1 has been loaded correctly") {
                let json:AnyObject? = self.jsonFromFileName("t1.json")
                expect(json is JSONDictionary).to(equal(true))
                
                if let json = json as? JSONDictionary {
                    let object = Comment(data:json)
                    expect(object.subredditId).to(equal("t5_2qizd"))
                    expect(object.bannedBy).to(equal(""))
                    expect(object.linkId).to(equal("t3_32wnhw"))
                    expect(object.likes).to(equal(""))
                    expect(object.userReports.count).to(equal(0))
                    expect(object.saved).to(equal(false))
                    expect(object.id).to(equal("cqfhkcb"))
                    expect(object.gilded).to(equal(0))
                    expect(object.archived).to(equal(false))
                    expect(object.reportReasons.count).to(equal(0))
                    expect(object.author).to(equal("Icnoyotl"))
                    expect(object.parentId).to(equal("t1_cqfh5kz"))
                    expect(object.score).to(equal(1))
                    expect(object.approvedBy).to(equal(""))
                    expect(object.controversiality).to(equal(0))
                    expect(object.body).to(equal("The bot has been having this problem for awhile, there have been thousands of new comments since it last worked properly, so it seems like this must be something recurring? Could it have something to do with our AutoModerator?"))
                    expect(object.edited).to(equal(false))
                    expect(object.authorFlairCssClass).to(equal(""))
                    expect(object.downs).to(equal(0))
                    expect(object.bodyHtml).to(equal("&lt;div class=\"md\"&gt;&lt;p&gt;The bot has been having this problem for awhile, there have been thousands of new comments since it last worked properly, so it seems like this must be something recurring? Could it have something to do with our AutoModerator?&lt;/p&gt;\n&lt;/div&gt;"))
                    expect(object.subreddit).to(equal("redditdev"))
                    expect(object.scoreHidden).to(equal(false))
                    expect(object.name).to(equal("t1_cqfhkcb"))
                    expect(object.created).to(equal(1429284845))
                    expect(object.authorFlairText).to(equal(""))
                    expect(object.createdUtc).to(equal(1429281245))
                    expect(object.distinguished).to(equal(false))
                    expect(object.modReports.count).to(equal(0))
                    expect(object.numReports).to(equal(0))
                    expect(object.ups).to(equal(1))
                    
                    expect(object.replies != nil).to(equal(true))
                    if let listing = object.replies {
                        expect(listing.children.count).to(equal(0))
                        
                        expect(listing.more != nil).to(equal(true))
                        if let more = listing.more {
                            expect(more.count).to(equal(0))
                            expect(more.parentId).to(equal("t1_cqfhkcb"))
                            expect(more.name).to(equal("t1_cqfmmpp"))
                            expect(more.id).to(equal("cqfmmpp"))
                            expect(more.children.count).to(equal(1))
                            expect(more.children[0]).to(equal("cqfmmpp"))
                        }
                    }
                }
            }
        }
        
        describe("Parsing t2 json file") {
            it("Each property of t2 has been loaded correctly") {
                let json:AnyObject? = self.jsonFromFileName("t2.json")
                expect(json is JSONDictionary).to(equal(true))
                
                if let json = json as? JSONDictionary {
                    let object = Account(data:json)
                    expect(object.hasMail).to(equal(false))
                    expect(object.name).to(equal("sonson_twit"))
                    expect(object.created).to(equal(1427126074))
                    expect(object.hideFromRobots).to(equal(false))
                    expect(object.goldCreddits).to(equal(0))
                    expect(object.createdUtc).to(equal(1427122474))
                    expect(object.hasModMail).to(equal(false))
                    expect(object.linkKarma).to(equal(1))
                    expect(object.commentKarma).to(equal(1))
                    expect(object.over18).to(equal(true))
                    expect(object.isGold).to(equal(false))
                    expect(object.isMod).to(equal(false))
                    expect(object.goldExpiration).to(equal(false))
                    expect(object.hasVerifiedEmail).to(equal(false))
                    expect(object.id).to(equal("mfsh8"))
                    expect(object.inboxCount).to(equal(0))
                }
            }
        }
        
        describe("Parsing t3 json file") {
            it("Each property of t3 has been loaded correctly") {
                let json:AnyObject? = self.jsonFromFileName("t3.json")
                expect(json is JSONDictionary).to(equal(true))
                
                if let json = json as? JSONDictionary {
                    
                    var object = Link(data:json)
                    expect(object.domain).to(equal("self.redditdev"))
                    expect(object.bannedBy).to(equal(""))
                    expect(object.subreddit).to(equal("redditdev"))
                    expect(object.selftextHtml).to(equal("&lt;!-- SC_OFF --&gt;&lt;div class=\"md\"&gt;&lt;p&gt;So this is the code I ran:&lt;/p&gt;\n\n&lt;pre&gt;&lt;code&gt;r = praw.Reddit(&amp;quot;/u/habnpam sflkajsfowifjsdlkfj test test test&amp;quot;)\n\n\nfor c in praw.helpers.comment_stream(reddit_session=r, subreddit=&amp;quot;helpmefind&amp;quot;, limit=500, verbosity=1):\n    print(c.author)\n&lt;/code&gt;&lt;/pre&gt;\n\n&lt;hr/&gt;\n\n&lt;p&gt;From what I understand, comment_stream() gets the most recent comments. So if we specify the limit to be 100, it will initially get the 100 newest comment, and then constantly update to get new comments.  It seems to works appropriately for every subreddit except &lt;a href=\"/r/helpmefind\"&gt;/r/helpmefind&lt;/a&gt;. For &lt;a href=\"/r/helpmefind\"&gt;/r/helpmefind&lt;/a&gt;, it fetches around 30 comments, regardless of the limit.&lt;/p&gt;\n&lt;/div&gt;&lt;!-- SC_ON --&gt;"))
                    expect(object.selftext).to(equal("So this is the code I ran:\n\n    r = praw.Reddit(\"/u/habnpam sflkajsfowifjsdlkfj test test test\")\n    \n\n    for c in praw.helpers.comment_stream(reddit_session=r, subreddit=\"helpmefind\", limit=500, verbosity=1):\n        print(c.author)\n\n\n---\n\nFrom what I understand, comment_stream() gets the most recent comments. So if we specify the limit to be 100, it will initially get the 100 newest comment, and then constantly update to get new comments.  It seems to works appropriately for every subreddit except /r/helpmefind. For /r/helpmefind, it fetches around 30 comments, regardless of the limit."))
                    XCTAssertTrue((object.likes == nil), "check likes's value.")
                    expect(object.userReports.count).to(equal(0))
                    XCTAssertTrue((object.secureMedia == nil), "check secure_media's value.")
                    expect(object.linkFlairText).to(equal(""))
                    expect(object.id).to(equal("32wnhw"))
                    expect(object.gilded).to(equal(0))
                    expect(object.archived).to(equal(false))
                    expect(object.clicked).to(equal(false))
                    expect(object.reportReasons.count).to(equal(0))
                    expect(object.author).to(equal("habnpam"))
                    expect(object.numComments).to(equal(10))
                    expect(object.score).to(equal(2))
                    expect(object.approvedBy).to(equal(""))
                    expect(object.over18).to(equal(false))
                    expect(object.hidden).to(equal(false))
                    expect(object.thumbnail).to(equal(""))
                    expect(object.subredditId).to(equal("t5_2qizd"))
                    expect(object.edited).to(equal(false))
                    expect(object.linkFlairCssClass).to(equal(""))
                    expect(object.authorFlairCssClass).to(equal(""))
                    expect(object.downs).to(equal(0))
                    expect(object.modReports.count).to(equal(0))
                    XCTAssertTrue((object.secureMediaEmbed == nil), "check secure_media_embed's value.")
                    expect(object.saved).to(equal(false))
                    expect(object.isSelf).to(equal(true))
                    expect(object.name).to(equal("t3_32wnhw"))
                    expect(object.permalink).to(equal("/r/redditdev/comments/32wnhw/praw_comment_stream_messes_up_when_getting/"))
                    expect(object.stickied).to(equal(false))
                    expect(object.created).to(equal(1429292148))
                    expect(object.url).to(equal("http://www.reddit.com/r/redditdev/comments/32wnhw/praw_comment_stream_messes_up_when_getting/"))
                    expect(object.authorFlairText).to(equal(""))
                    expect(object.title).to(equal("[PRAW] comment_stream() messes up when getting comments from a certain subreddit."))
                    expect(object.createdUtc).to(equal(1429263348))
                    expect(object.ups).to(equal(2))
                    expect(object.upvoteRatio).to(equal(0.75))
                    expect(object.visited).to(equal(false))
                    expect(object.numReports).to(equal(0))
                    expect(object.distinguished).to(equal(false))
                    
                    // media
                    XCTAssertTrue((object.media != nil), "check media's value.")
                    if let media = object.media {
                        expect(media.type).to(equal("i.imgur.com"))
                        expect(media.oembed.width).to(equal(320))
                        expect(media.oembed.height).to(equal(568))
                        expect(media.oembed.thumbnailWidth).to(equal(320))
                        expect(media.oembed.thumbnailHeight).to(equal(568))
                        
                        expect(media.oembed.providerUrl).to(equal("http://i.imgur.com"))
                        expect(media.oembed.description).to(equal("The Internet's visual storytelling community. Explore, share, and discuss the best visual stories the Internet has to offer."))
                        expect(media.oembed.title).to(equal("Imgur GIF"))
                        expect(media.oembed.html).to(equal("&lt;iframe class=\"embedly-embed\" src=\"//cdn.embedly.com/widgets/media.html?src=https%3A%2F%2Fi.imgur.com%2FnN5D1BT.mp4&amp;src_secure=1&amp;url=http%3A%2F%2Fi.imgur.com%2FnN5D1BT.gifv&amp;image=http%3A%2F%2Fi.imgur.com%2FnN5D1BT.gif&amp;key=2aa3c4d5f3de4f5b9120b660ad850dc9&amp;type=video%2Fmp4&amp;schema=imgur\" width=\"320\" height=\"568\" scrolling=\"no\" frameborder=\"0\" allowfullscreen&gt;&lt;/iframe&gt;"))
                        expect(media.oembed.version).to(equal("1.0"))
                        expect(media.oembed.providerName).to(equal("Imgur"))
                        expect(media.oembed.thumbnailUrl).to(equal("http://i.imgur.com/nN5D1BT.gif"))
                        expect(media.oembed.type).to(equal("video"))
                    }
                    
                    // media embed
                    XCTAssertTrue((object.mediaEmbed != nil), "check media_embed's value.")
                    if let media_embed = object.mediaEmbed {
                        expect(media_embed.content).to(equal("&lt;iframe class=\"embedly-embed\" src=\"//cdn.embedly.com/widgets/media.html?src=https%3A%2F%2Fi.imgur.com%2FnN5D1BT.mp4&amp;src_secure=1&amp;url=http%3A%2F%2Fi.imgur.com%2FnN5D1BT.gifv&amp;image=http%3A%2F%2Fi.imgur.com%2FnN5D1BT.gif&amp;key=2aa3c4d5f3de4f5b9120b660ad850dc9&amp;type=video%2Fmp4&amp;schema=imgur\" width=\"320\" height=\"568\" scrolling=\"no\" frameborder=\"0\" allowfullscreen&gt;&lt;/iframe&gt;"))
                        expect(media_embed.width).to(equal(320))
                        expect(media_embed.height).to(equal(568))
                        expect(media_embed.scrolling).to(equal(false))
                    }
                }
            }
        }

        describe("Parsing t4 json file") {
            it("Each property of t4 has been loaded correctly") {
                let json:AnyObject? = self.jsonFromFileName("t4.json")
                expect(json is JSONDictionary).to(equal(true))
                
                if let json = json as? JSONDictionary {
                    let object = Message(data:json)
                    expect(object.body).to(equal("Hello! [Hola!](https://www.reddit.com/r/reddit.com/wiki/templat....."))
                    expect(object.wasComment).to(equal(false))
                    expect(object.firstMessage).to(equal(""))
                    expect(object.name).to(equal("t4_36sfhx"))
                    expect(object.firstMessageName).to(equal(""))
                    expect(object.created).to(equal(1427126074))
                    expect(object.dest).to(equal("sonson_twit"))
                    expect(object.author).to(equal("reddit"))
                    expect(object.createdUtc).to(equal(1427122474))
                    expect(object.bodyHtml).to(equal("&lt;!-- SC_....."))
                    expect(object.subreddit).to(equal(""))
                    expect(object.parentId).to(equal(""))
                    expect(object.context).to(equal(""))
                    expect(object.replies).to(equal(""))
                    expect(object.id).to(equal("36sfhx"))
                    expect(object.new).to(equal(false))
                    expect(object.distinguished).to(equal("admin"))
                    expect(object.subject).to(equal("Hello, /u/sonson_twit! Welcome to reddit!"))
                }
            }
        }
        
        describe("Parsing t5 json file") {
            it("Each property of t5 has been loaded correctly") {
                let json:AnyObject? = self.jsonFromFileName("t5.json")
                expect(json is JSONDictionary).to(equal(true))
                
                if let json = json as? JSONDictionary {
                    let object = Subreddit(data:json)
                    expect(object.bannerImg).to(equal(""))
                    expect(object.userSrThemeEnabled).to(equal(true))
                    expect(object.submitTextHtml).to(equal("&lt;!-- SC_OFF --&gt;&lt;div class=\"md\"&gt;&lt;p&gt;&lt;strong&gt;GIFs are banned.&lt;/strong&gt;\nIf you want to post a GIF, please &lt;a href=\"http://imgur.com\"&gt;rehost it as a GIFV&lt;/a&gt; instead. &lt;a href=\"http://www.reddit.com/r/woahdude/wiki/html5\"&gt;(Read more)&lt;/a&gt;&lt;/p&gt;\n\n&lt;p&gt;&lt;strong&gt;Link flair is mandatory.&lt;/strong&gt;\nClick &amp;quot;Add flair&amp;quot; button after you submit. The button will be located under your post title. &lt;a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_flair_is_mandatory\"&gt;(read more)&lt;/a&gt;&lt;/p&gt;\n\n&lt;p&gt;&lt;strong&gt;XPOST labels are banned.&lt;/strong&gt;\nCrossposts are fine, just don&amp;#39;t label them as such. &lt;a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_.5Bxpost.5D_tags.2Flabels_are_banned\"&gt;(read more)&lt;/a&gt;&lt;/p&gt;\n\n&lt;p&gt;&lt;strong&gt;Trippy or Mesmerizing content only!&lt;/strong&gt;\nWhat is WoahDude-worthy content? &lt;a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_what_is_.22woahdude_material.22.3F\"&gt;(Read more)&lt;/a&gt;&lt;/p&gt;\n&lt;/div&gt;&lt;!-- SC_ON --&gt;"))
                    expect(object.userIsBanned).to(equal(false))
                    expect(object.id).to(equal("2r8tu"))
                    expect(object.submitText).to(equal("**GIFs are banned.**\nIf you want to post a GIF, please [rehost it as a GIFV](http://imgur.com) instead. [(Read more)](http://www.reddit.com/r/woahdude/wiki/html5)\n\n**Link flair is mandatory.**\nClick \"Add flair\" button after you submit. The button will be located under your post title. [(read more)](http://www.reddit.com/r/woahdude/wiki/index#wiki_flair_is_mandatory)\n\n**XPOST labels are banned.**\nCrossposts are fine, just don't label them as such. [(read more)](http://www.reddit.com/r/woahdude/wiki/index#wiki_.5Bxpost.5D_tags.2Flabels_are_banned)\n\n**Trippy or Mesmerizing content only!**\nWhat is WoahDude-worthy content? [(Read more)](http://www.reddit.com/r/woahdude/wiki/index#wiki_what_is_.22woahdude_material.22.3F)"))
                    expect(object.displayName).to(equal("woahdude"))
                    expect(object.headerImg).to(equal("http://b.thumbs.redditmedia.com/fnO6IreM4s_Em4dTIU2HtmZ_NTw7dZdlCoaLvtKwbzM.png"))
                    expect(object.descriptionHtml).to(equal("&lt;!-- SC_OFF --&gt;&lt;div class=\"md\"&gt;&lt;h5&gt;&lt;a href=\"https://www.reddit.com/r/woahdude/comments/2qi1jh/best_of_rwoahdude_2014_results/?\"&gt;Best of WoahDude 2014 ⇦&lt;/a&gt;&lt;/h5&gt;\n\n&lt;p&gt;&lt;a href=\"#nyanbro\"&gt;&lt;/a&gt;&lt;/p&gt;\n\n&lt;h4&gt;&lt;strong&gt;What is WoahDude?&lt;/strong&gt;&lt;/h4&gt;\n\n&lt;p&gt;&lt;em&gt;The best links to click while you&amp;#39;re stoned!&lt;/em&gt; &lt;/p&gt;\n\n&lt;p&gt;Trippy &amp;amp; mesmerizing games, video, audio &amp;amp; images that make you go &amp;#39;woah dude!&amp;#39;&lt;/p&gt;\n\n&lt;p&gt;No one wants to have to sift through the entire internet for fun links when they&amp;#39;re stoned - so make this your one-stop shop!&lt;/p&gt;\n\n&lt;p&gt;⇨ &lt;a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_what_is_.22woahdude_material.22.3F\"&gt;more in-depth explanation here&lt;/a&gt; ⇦&lt;/p&gt;\n\n&lt;h4&gt;&lt;strong&gt;Filter WoahDude by flair&lt;/strong&gt;&lt;/h4&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair:picture&amp;amp;sort=top&amp;amp;restrict_sr=on\"&gt;picture&lt;/a&gt; - Static images&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair:wallpaper+OR+%5BWALLPAPER%5D&amp;amp;sort=top&amp;amp;restrict_sr=on\"&gt;wallpaper&lt;/a&gt; - PC or Smartphone&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair%3Agifv+OR+flair%3Awebm&amp;amp;restrict_sr=on&amp;amp;sort=top&amp;amp;t=all\"&gt;gifv&lt;/a&gt; - Animated images&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair:audio&amp;amp;sort=top&amp;amp;restrict_sr=on\"&gt;audio&lt;/a&gt; - Non-musical audio &lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair:music&amp;amp;sort=top&amp;amp;restrict_sr=on\"&gt;music&lt;/a&gt;  - Include: Band &amp;amp; Song Title&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair:musicvideo&amp;amp;sort=top&amp;amp;restrict_sr=on\"&gt;music video&lt;/a&gt; - If slideshow, tag [music] &lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair:video&amp;amp;sort=top&amp;amp;restrict_sr=on\"&gt;video&lt;/a&gt; - Non-musical video&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://redd.it/29owi1#movies\"&gt;movies&lt;/a&gt; - Movies&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair:game&amp;amp;restrict_sr=on&amp;amp;sort=top&amp;amp;t=all\"&gt;game&lt;/a&gt; - Goal oriented games&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair%3Ainteractive+OR+sandbox&amp;amp;sort=top&amp;amp;restrict_sr=on&amp;amp;t=all\"&gt;interactive&lt;/a&gt; - Interactive pages&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/comments/1jri9s/woahdude_featured_apps_get_free_download_codes/\"&gt;mobile app&lt;/a&gt; - Mod-curated selection of apps&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/WoahDude/search?q=flair%3Atext&amp;amp;restrict_sr=on&amp;amp;sort=top&amp;amp;t=all\"&gt;text&lt;/a&gt; - Articles, selfposts &amp;amp; textpics&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/r/woahdude/search?q=flair%3Awoahdude%2Bapproved&amp;amp;sort=new&amp;amp;restrict_sr=on&amp;amp;t=all\"&gt;WOAHDUDE APPROVED&lt;/a&gt; - Mod-curated selection of the best WoahDude submissions.&lt;/p&gt;\n\n&lt;h4&gt;RULES  &lt;a href=\"http://www.reddit.com/r/woahdude/wiki\"&gt;⇨ FULL VERSION&lt;/a&gt;&lt;/h4&gt;\n\n&lt;blockquote&gt;\n&lt;ol&gt;\n&lt;li&gt;LINK FLAIR &lt;strong&gt;is &lt;a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_flair_is_mandatory\"&gt;mandatory&lt;/a&gt;.&lt;/strong&gt;&lt;/li&gt;\n&lt;li&gt;XPOST &lt;strong&gt;labels are &lt;a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_.5Bxpost.5D_tags.2Flabels_are_banned\"&gt;banned&lt;/a&gt;. Crossposts are fine, just don&amp;#39;t label them as such.&lt;/strong&gt;&lt;/li&gt;\n&lt;li&gt; NO &lt;strong&gt;hostility!&lt;/strong&gt; PLEASE &lt;strong&gt;giggle like a giraffe :)&lt;/strong&gt;&lt;/li&gt;\n&lt;/ol&gt;\n&lt;/blockquote&gt;\n\n&lt;p&gt;Certain reposts are allowed. &lt;a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_reposts\"&gt;Learn more&lt;/a&gt;. Those not allowed may be reported via this form:&lt;/p&gt;\n\n&lt;p&gt;&lt;a href=\"http://www.reddit.com/message/compose?to=%2Fr%2Fwoahdude&amp;amp;subject=Repost%20Report&amp;amp;message=Here%20%5bLINK%5d%20is%20an%20illegitimate%20repost,%20and%20here%20%5bLINK%5d%20is%20proof%20that%20the%20original%20woahdude%20post%20had%201500%2b%20upvotes.#reportwarning\"&gt;&lt;/a&gt; &lt;a href=\"http://www.reddit.com/message/compose?to=%2Fr%2Fwoahdude&amp;amp;subject=Repost%20Report&amp;amp;message=Here%20%5bLINK%5d%20is%20an%20illegitimate%20repost,%20and%20here%20%5bLINK%5d%20is%20proof%20that%20the%20original%20woahdude%20post%20had%201500%2b%20upvotes.\"&gt;&lt;strong&gt;REPORT AN ILLEGITIMATE REPOST&lt;/strong&gt;&lt;/a&gt;&lt;/p&gt;\n\n&lt;h4&gt;WoahDude community&lt;/h4&gt;\n\n&lt;ul&gt;\n&lt;li&gt;&lt;a href=\"/r/WoahDude\"&gt;/r/WoahDude&lt;/a&gt; - All media&lt;/li&gt;\n&lt;li&gt;&lt;a href=\"/r/WoahTube\"&gt;/r/WoahTube&lt;/a&gt; - Videos only&lt;/li&gt;\n&lt;li&gt;&lt;a href=\"/r/WoahTunes\"&gt;/r/WoahTunes&lt;/a&gt; - Music only&lt;/li&gt;\n&lt;li&gt;&lt;a href=\"/r/StonerPhilosophy\"&gt;/r/StonerPhilosophy&lt;/a&gt; - Text posts only&lt;/li&gt;\n&lt;li&gt;&lt;a href=\"/r/WoahPoon\"&gt;/r/WoahPoon&lt;/a&gt; - NSFW&lt;/li&gt;\n&lt;li&gt;&lt;strong&gt;&lt;a href=\"http://www.reddit.com/user/rWoahDude/m/woahdude\"&gt;MULTIREDDIT&lt;/a&gt;&lt;/strong&gt;&lt;/li&gt;\n&lt;/ul&gt;\n\n&lt;h5&gt;&lt;a href=\"http://facebook.com/rWoahDude\"&gt;&lt;/a&gt;&lt;/h5&gt;\n\n&lt;h5&gt;&lt;a href=\"http://twitter.com/rWoahDude\"&gt;&lt;/a&gt;&lt;/h5&gt;\n\n&lt;h5&gt;&lt;a href=\"http://emilydavis.bandcamp.com/track/sagans-song\"&gt;http://emilydavis.bandcamp.com/track/sagans-song&lt;/a&gt;&lt;/h5&gt;\n&lt;/div&gt;&lt;!-- SC_ON --&gt;"))
                    expect(object.title).to(equal("The BEST links to click while you're STONED"))
                    expect(object.collapseDeletedComments).to(equal(true))
                    expect(object.over18).to(equal(false))
                    expect(object.publicDescriptionHtml).to(equal("&lt;!-- SC_OFF --&gt;&lt;div class=\"md\"&gt;&lt;p&gt;The best links to click while you&amp;#39;re stoned!&lt;/p&gt;\n\n&lt;p&gt;Trippy, mesmerizing, and mindfucking games, video, audio &amp;amp; images that make you go &amp;#39;woah dude!&amp;#39;&lt;/p&gt;\n\n&lt;p&gt;If you like to look at amazing stuff while smoking weed or doing other drugs, come inside for some Science, Philosophy, Mindfucks, Math, Engineering, Illusions and Cosmic weirdness.&lt;/p&gt;\n&lt;/div&gt;&lt;!-- SC_ON --&gt;"))
                    expect(object.iconSize).to(equal([145, 60]))
                    expect(object.iconImg).to(equal(""))
                    expect(object.headerTitle).to(equal("Turn on the stylesheet and click Carl Sagan's head"))
                    expect(object.description).to(equal("#####[Best of WoahDude 2014 ⇦](https://www.reddit.com/r/woahdude/comments/2qi1jh/best_of_rwoahdude_2014_results/?)\n\n[](#nyanbro)\n\n####**What is WoahDude?**\n\n*The best links to click while you're stoned!* \n\nTrippy &amp; mesmerizing games, video, audio &amp; images that make you go 'woah dude!'\n\nNo one wants to have to sift through the entire internet for fun links when they're stoned - so make this your one-stop shop!\n\n⇨ [more in-depth explanation here](http://www.reddit.com/r/woahdude/wiki/index#wiki_what_is_.22woahdude_material.22.3F) ⇦\n\n####**Filter WoahDude by flair**\n\n[picture](http://www.reddit.com/r/woahdude/search?q=flair:picture&amp;sort=top&amp;restrict_sr=on) - Static images\n\n[wallpaper](http://www.reddit.com/r/woahdude/search?q=flair:wallpaper+OR+[WALLPAPER]&amp;sort=top&amp;restrict_sr=on) - PC or Smartphone\n\n[gifv](http://www.reddit.com/r/woahdude/search?q=flair%3Agifv+OR+flair%3Awebm&amp;restrict_sr=on&amp;sort=top&amp;t=all) - Animated images\n\n[audio](http://www.reddit.com/r/woahdude/search?q=flair:audio&amp;sort=top&amp;restrict_sr=on) - Non-musical audio \n\n[music](http://www.reddit.com/r/woahdude/search?q=flair:music&amp;sort=top&amp;restrict_sr=on)  - Include: Band &amp; Song Title\n\n[music video](http://www.reddit.com/r/woahdude/search?q=flair:musicvideo&amp;sort=top&amp;restrict_sr=on) - If slideshow, tag [music] \n\n[video](http://www.reddit.com/r/woahdude/search?q=flair:video&amp;sort=top&amp;restrict_sr=on) - Non-musical video\n\n[movies](http://redd.it/29owi1#movies) - Movies\n\n[game](http://www.reddit.com/r/woahdude/search?q=flair:game&amp;restrict_sr=on&amp;sort=top&amp;t=all) - Goal oriented games\n\n[interactive](http://www.reddit.com/r/woahdude/search?q=flair%3Ainteractive+OR+sandbox&amp;sort=top&amp;restrict_sr=on&amp;t=all) - Interactive pages\n\n[mobile app](http://www.reddit.com/r/woahdude/comments/1jri9s/woahdude_featured_apps_get_free_download_codes/) - Mod-curated selection of apps\n\n[text](http://www.reddit.com/r/WoahDude/search?q=flair%3Atext&amp;restrict_sr=on&amp;sort=top&amp;t=all) - Articles, selfposts &amp; textpics\n\n[WOAHDUDE APPROVED](http://www.reddit.com/r/woahdude/search?q=flair%3Awoahdude%2Bapproved&amp;sort=new&amp;restrict_sr=on&amp;t=all) - Mod-curated selection of the best WoahDude submissions.\n\n####RULES  [⇨ FULL VERSION](http://www.reddit.com/r/woahdude/wiki) \n\n&gt; 1. LINK FLAIR **is [mandatory](http://www.reddit.com/r/woahdude/wiki/index#wiki_flair_is_mandatory).**\n2. XPOST **labels are [banned](http://www.reddit.com/r/woahdude/wiki/index#wiki_.5Bxpost.5D_tags.2Flabels_are_banned). Crossposts are fine, just don't label them as such.**\n3.  NO **hostility!** PLEASE **giggle like a giraffe :)**\n\nCertain reposts are allowed. [Learn more](http://www.reddit.com/r/woahdude/wiki/index#wiki_reposts). Those not allowed may be reported via this form:\n\n[](http://www.reddit.com/message/compose?to=%2Fr%2Fwoahdude&amp;subject=Repost%20Report&amp;message=Here%20%5bLINK%5d%20is%20an%20illegitimate%20repost,%20and%20here%20%5bLINK%5d%20is%20proof%20that%20the%20original%20woahdude%20post%20had%201500%2b%20upvotes.#reportwarning) [**REPORT AN ILLEGITIMATE REPOST**](http://www.reddit.com/message/compose?to=%2Fr%2Fwoahdude&amp;subject=Repost%20Report&amp;message=Here%20%5bLINK%5d%20is%20an%20illegitimate%20repost,%20and%20here%20%5bLINK%5d%20is%20proof%20that%20the%20original%20woahdude%20post%20had%201500%2b%20upvotes.)\n\n####WoahDude community\n\n* /r/WoahDude - All media\n* /r/WoahTube - Videos only\n* /r/WoahTunes - Music only\n* /r/StonerPhilosophy - Text posts only\n* /r/WoahPoon - NSFW\n* **[MULTIREDDIT](http://www.reddit.com/user/rWoahDude/m/woahdude)**\n\n#####[](http://facebook.com/rWoahDude)\n#####[](http://twitter.com/rWoahDude)\n\n#####http://emilydavis.bandcamp.com/track/sagans-song"))
                    expect(object.submitLinkLabel).to(equal("SUBMIT LINK"))
                    expect(object.accountsActive).to(equal(0))
                    expect(object.publicTraffic).to(equal(false))
                    expect(object.headerSize).to(equal([145, 60]))
                    expect(object.subscribers).to(equal(778611))
                    expect(object.submitTextLabel).to(equal("SUBMIT TEXT"))
                    expect(object.userIsModerator).to(equal(false))
                    expect(object.name).to(equal("t5_2r8tu"))
                    expect(object.created).to(equal(1254666760))
                    expect(object.url).to(equal("/r/woahdude/"))
                    expect(object.hideAds).to(equal(false))
                    expect(object.createdUtc).to(equal(1254663160))
                    expect(object.bannerSize).to(equal([]))
                    expect(object.userIsContributor).to(equal(false))
                    expect(object.publicDescription).to(equal("The best links to click while you're stoned!\n\nTrippy, mesmerizing, and mindfucking games, video, audio &amp; images that make you go 'woah dude!'\n\nIf you like to look at amazing stuff while smoking weed or doing other drugs, come inside for some Science, Philosophy, Mindfucks, Math, Engineering, Illusions and Cosmic weirdness.\n\n"))
                    expect(object.commentScoreHideMins).to(equal(0))
                    expect(object.subredditType).to(equal("public"))
                    expect(object.submissionType).to(equal("any"))
                    expect(object.userIsSubscriber).to(equal(true))
                }
            }
        }
        
        describe("Parsing more json file") {
            it("Each property of more has been loaded correctly") {
                let json:AnyObject? = self.jsonFromFileName("more.json")
                expect(json is JSONDictionary).to(equal(true))
                
                if let json = json as? JSONDictionary {
                    var object = More(data:json)
                    expect(object.count).to(equal(0))
                    expect(object.parentId).to(equal("t1_cp88kh5"))
                    expect(object.children).to(equal(["cpddp7v", "cp8jvj8", "cp8cv4b"]))
                    expect(object.name).to(equal("t1_cpddp7v"))
                    expect(object.id).to(equal("cpddp7v"))
                }
            }
        }
        
        describe("Parsing LabeledMulti json file") {
            it("Each property of more has been loaded correctly") {
                let json:AnyObject? = self.jsonFromFileName("LabeledMulti.json")
                expect(json is JSONDictionary).to(equal(true))
                if let json = json as? JSONDictionary {
                    let object = Multireddit(json:json)
                    expect(object.canEdit).to(equal(true))
                    expect(object.displayName).to(equal("english"))
                    expect(object.name).to(equal("english"))
                    expect(object.descriptionHtml).to(equal(""))
                    expect(object.created).to(equal(1432028681))
                    expect(object.copiedFrom).to(equal(""))
                    expect(object.iconUrl).to(equal(""))
                    expect(object.subreddits).to(equal(["redditdev", "swift"]))
                    expect(object.createdUtc).to(equal(1431999881))
                    expect(object.keyColor).to(equal("#cee3f8"))
                    expect(object.visibility).to(equal(MultiredditVisibility.Private))
                    expect(object.iconName).to(equal(MultiredditIconName.None))
                    expect(object.weightingScheme).to(equal(MultiredditWeightingScheme.Classic))
                    expect(object.path).to(equal("/user/sonson_twit/m/english"))
                    expect(object.descriptionMd).to(equal(""))
                }
            }
        }
        
        describe("Parsing LabeledMultiDescription json file") {
            it("Each property of more has been loaded correctly") {
                let json:AnyObject? = self.jsonFromFileName("LabeledMultiDescription.json")
                expect(json is JSONDictionary).to(equal(true))
                if let json = json as? JSONDictionary {
                    let object = MultiredditDescription(json:json)
                    expect(object.bodyHtml).to(equal("&lt;!-- SC_OFF --&gt;&lt;div class=\"md\"&gt;&lt;p&gt;updated&lt;/p&gt;\n&lt;/div&gt;&lt;!-- SC_ON --&gt;"))
                    expect(object.bodyMd).to(equal("updated"))
                }
            }
        }
        
        describe("Parsing Needs CAPTHCA response String test") {
            it("is true or false") {
                var r = false
                if let path = NSBundle(forClass: self.classForCoder).pathForResource("api_needs_captcha.json", ofType:nil) {
                    if let data = NSData(contentsOfFile: path) {
                        var result = decodeBooleanString(data)
                        switch result {
                        case .Failure:
                            println(result.error!.description)
                        case .Success:
                            r = true
                        }
                    }
                }
                expect(r).to(equal(true))
            }
        }
        
        describe("Parsing CAPTHCA Iden response JSON Test") {
            it("Each property of more has been loaded correctly") {
                var r = false
                let json:AnyObject? = self.jsonFromFileName("api_new_captcha.json")
                expect(json is JSONDictionary).to(equal(true))
                if let thing = json as? JSONDictionary {
                    var result = parseCAPTCHAIdenJSON(thing)
                    switch result {
                    case .Failure:
                        println(result.error!.description)
                    case .Success:
                        r = true
                    }
                }
                expect(r).to(equal(true))
            }
        }
    }
}
