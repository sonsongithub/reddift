//
//  ParseThingObjectTest.swift
//  reddift
//
//  Created by sonson on 2015/04/22.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import XCTest

extension XCTestCase {
    func jsonFromFileName(name: String) -> AnyObject? {
        if let path = NSBundle(forClass: self.classForCoder).pathForResource(name, ofType:nil) {
            if let data = NSData(contentsOfFile: path) {
                do {
                    return try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions())
                } catch {
                    XCTFail((error as NSError).description)
                    return nil
                }
            }
        }
        XCTFail()
        return nil
    }
}

/**
Test for parsing JSON data of "Thing".
Test data files are t1.json, t2.json, t3.json, t4.json, t5.json and more.json.
*/
class ParseThingObjectTest: XCTestCase {
    func testParsingT1JsonFile() {
        print("Each property of t1 has been loaded correctly")
        if let json = self.jsonFromFileName("t1.json") as? JSONDictionary {
            let object = Comment(data:json)
            
            XCTAssert(object.subredditId == "t5_2qizd")
            XCTAssert(object.bannedBy == "")
            XCTAssert(object.linkId == "t3_32wnhw")
            XCTAssert(object.likes == .Up)
            XCTAssert(object.userReports.count == 0)
            XCTAssert(object.saved == false)
            XCTAssert(object.id == "cqfhkcb")
            XCTAssert(object.gilded == 0)
            XCTAssert(object.archived == false)
            XCTAssert(object.reportReasons.count == 0)
            XCTAssert(object.author == "Icnoyotl")
            XCTAssert(object.parentId == "t1_cqfh5kz")
            XCTAssert(object.score == 1)
            XCTAssert(object.approvedBy == "")
            XCTAssert(object.controversiality == 0)
            XCTAssert(object.body == "The bot has been having this problem for awhile, there have been thousands of new comments since it last worked properly, so it seems like this must be something recurring? Could it have something to do with our AutoModerator?")
            XCTAssert(object.edited == false)
            XCTAssert(object.authorFlairCssClass == "")
            XCTAssert(object.downs == 0)
            XCTAssert(object.bodyHtml == "<div class=\"md\"><p>The bot has been having this problem for awhile, there have been thousands of new comments since it last worked properly, so it seems like this must be something recurring? Could it have something to do with our AutoModerator?</p>\n</div>")
            XCTAssert(object.subreddit == "redditdev")
            XCTAssert(object.scoreHidden == false)
            XCTAssert(object.name == "t1_cqfhkcb")
            XCTAssert(object.created == 1429284845)
            XCTAssert(object.authorFlairText == "")
            XCTAssert(object.createdUtc == 1429281245)
            XCTAssert(object.distinguished == false)
            XCTAssert(object.modReports.count == 0)
            XCTAssert(object.numReports == 0)
            XCTAssert(object.ups == 1)
            
            XCTAssert(object.replies.children.count == 1)
            var isSucceeded = false
            if object.replies.children.count == 1 {
                if let more = object.replies.children[0] as? More {
                    XCTAssert(more.parentId == "t1_cqfhkcb")
                    XCTAssert(more.name == "t1_cqfmmpp")
                    XCTAssert(more.id == "cqfmmpp")
                    XCTAssert(more.children.count == 1)
                    XCTAssert(more.children[0] == "cqfmmpp")
                    isSucceeded = true
                }
            }
            XCTAssert(isSucceeded == true)
        }
    }
    
    func testParsingT2JsonFile() {
        print("Each property of t2 has been loaded correctly")
        if let json = self.jsonFromFileName("t2.json") as? JSONDictionary {
            let object = Account(data:json)
            XCTAssert(object.hasMail == false)
            XCTAssert(object.name == "sonson_twit")
            XCTAssert(object.created == 1427126074)
            XCTAssert(object.hideFromRobots == false)
            XCTAssert(object.goldCreddits == 0)
            XCTAssert(object.createdUtc == 1427122474)
            XCTAssert(object.hasModMail == false)
            XCTAssert(object.linkKarma == 1)
            XCTAssert(object.commentKarma == 1)
            XCTAssert(object.over18 == true)
            XCTAssert(object.isGold == false)
            XCTAssert(object.isMod == false)
            XCTAssert(object.goldExpiration == false)
            XCTAssert(object.hasVerifiedEmail == false)
            XCTAssert(object.id == "mfsh8")
            XCTAssert(object.inboxCount == 0)
        }
    }
    
    func testParsingT3JsonFile() {
        print("Each property of t3 has been loaded correctly")
        if let json = self.jsonFromFileName("t3.json") as? JSONDictionary {
            let object = Link(data:json)
            XCTAssert(object.domain == "self.redditdev")
            XCTAssert(object.bannedBy == "")
            XCTAssert(object.subreddit == "redditdev")
            XCTAssert(object.selftextHtml == "<!-- SC_OFF --><div class=\"md\"><p>So this is the code I ran:</p>\n\n<pre><code>r = praw.Reddit(&quot;/u/habnpam sflkajsfowifjsdlkfj test test test&quot;)\n\n\nfor c in praw.helpers.comment_stream(reddit_session=r, subreddit=&quot;helpmefind&quot;, limit=500, verbosity=1):\n    print(c.author)\n</code></pre>\n\n<hr/>\n\n<p>From what I understand, comment_stream() gets the most recent comments. So if we specify the limit to be 100, it will initially get the 100 newest comment, and then constantly update to get new comments.  It seems to works appropriately for every subreddit except <a href=\"/r/helpmefind\">/r/helpmefind</a>. For <a href=\"/r/helpmefind\">/r/helpmefind</a>, it fetches around 30 comments, regardless of the limit.</p>\n</div><!-- SC_ON -->")
            XCTAssert(object.selftext == "So this is the code I ran:\n\n    r = praw.Reddit(\"/u/habnpam sflkajsfowifjsdlkfj test test test\")\n    \n\n    for c in praw.helpers.comment_stream(reddit_session=r, subreddit=\"helpmefind\", limit=500, verbosity=1):\n        print(c.author)\n\n\n---\n\nFrom what I understand, comment_stream() gets the most recent comments. So if we specify the limit to be 100, it will initially get the 100 newest comment, and then constantly update to get new comments.  It seems to works appropriately for every subreddit except /r/helpmefind. For /r/helpmefind, it fetches around 30 comments, regardless of the limit.")
            XCTAssertTrue((object.likes == .None), "check likes's value.")
            XCTAssert(object.userReports.count == 0)
            XCTAssertTrue((object.secureMedia == nil), "check secure_media's value.")
            XCTAssert(object.linkFlairText == "")
            XCTAssert(object.id == "32wnhw")
            XCTAssert(object.gilded == 0)
            XCTAssert(object.archived == false)
            XCTAssert(object.clicked == false)
            XCTAssert(object.reportReasons.count == 0)
            XCTAssert(object.author == "habnpam")
            XCTAssert(object.numComments == 10)
            XCTAssert(object.score == 2)
            XCTAssert(object.approvedBy == "")
            XCTAssert(object.over18 == false)
            XCTAssert(object.hidden == false)
            XCTAssert(object.thumbnail == "")
            XCTAssert(object.subredditId == "t5_2qizd")
            XCTAssert(object.edited == false)
            XCTAssert(object.linkFlairCssClass == "")
            XCTAssert(object.authorFlairCssClass == "")
            XCTAssert(object.downs == 0)
            XCTAssert(object.modReports.count == 0)
            XCTAssertTrue((object.secureMediaEmbed == nil), "check secure_media_embed's value.")
            XCTAssert(object.saved == false)
            XCTAssert(object.isSelf == true)
            XCTAssert(object.name == "t3_32wnhw")
            XCTAssert(object.permalink == "/r/redditdev/comments/32wnhw/praw_comment_stream_messes_up_when_getting/")
            XCTAssert(object.stickied == false)
            XCTAssert(object.created == 1429292148)
            XCTAssert(object.url == "http://www.reddit.com/r/redditdev/comments/32wnhw/praw_comment_stream_messes_up_when_getting/")
            XCTAssert(object.authorFlairText == "")
            XCTAssert(object.title == "[PRAW] comment_stream() messes up when getting comments from a certain subreddit.")
            XCTAssert(object.createdUtc == 1429263348)
            XCTAssert(object.ups == 2)
            XCTAssert(object.upvoteRatio == 0.75)
            XCTAssert(object.visited == false)
            XCTAssert(object.numReports == 0)
            XCTAssert(object.distinguished == false)
            
            // media
            XCTAssertTrue((object.media != nil), "check media's value.")
            if let media = object.media {
                XCTAssert(media.type == "i.imgur.com")
                XCTAssert(media.oembed.width == 320)
                XCTAssert(media.oembed.height == 568)
                XCTAssert(media.oembed.thumbnailWidth == 320)
                XCTAssert(media.oembed.thumbnailHeight == 568)
                
                XCTAssert(media.oembed.providerUrl == "http://i.imgur.com")
                XCTAssert(media.oembed.description == "The Internet's visual storytelling community. Explore, share, and discuss the best visual stories the Internet has to offer.")
                XCTAssert(media.oembed.title == "Imgur GIF")
                XCTAssert(media.oembed.html == "<iframe class=\"embedly-embed\" src=\"//cdn.embedly.com/widgets/media.html?src=https%3A%2F%2Fi.imgur.com%2FnN5D1BT.mp4&src_secure=1&url=http%3A%2F%2Fi.imgur.com%2FnN5D1BT.gifv&image=http%3A%2F%2Fi.imgur.com%2FnN5D1BT.gif&key=2aa3c4d5f3de4f5b9120b660ad850dc9&type=video%2Fmp4&schema=imgur\" width=\"320\" height=\"568\" scrolling=\"no\" frameborder=\"0\" allowfullscreen></iframe>")
                XCTAssert(media.oembed.version == "1.0")
                XCTAssert(media.oembed.providerName == "Imgur")
                XCTAssert(media.oembed.thumbnailUrl == "http://i.imgur.com/nN5D1BT.gif")
                XCTAssert(media.oembed.type == "video")
            } else {
                XCTFail("media has not been load correctly.")
            }
            
            // media embed
            XCTAssertTrue((object.mediaEmbed != nil), "check media_embed's value.")
            if let media_embed = object.mediaEmbed {
                XCTAssert(media_embed.content == "<iframe class=\"embedly-embed\" src=\"//cdn.embedly.com/widgets/media.html?src=https%3A%2F%2Fi.imgur.com%2FnN5D1BT.mp4&src_secure=1&url=http%3A%2F%2Fi.imgur.com%2FnN5D1BT.gifv&image=http%3A%2F%2Fi.imgur.com%2FnN5D1BT.gif&key=2aa3c4d5f3de4f5b9120b660ad850dc9&type=video%2Fmp4&schema=imgur\" width=\"320\" height=\"568\" scrolling=\"no\" frameborder=\"0\" allowfullscreen></iframe>")
                XCTAssert(media_embed.width == 320)
                XCTAssert(media_embed.height == 568)
                XCTAssert(media_embed.scrolling == false)
            } else {
                XCTFail("media has not been load correctly.")
            }
        }
    }
    
    func testParsingT4JsonFile() {
        print("Each property of t4 has been loaded correctly")
        if let json = self.jsonFromFileName("t4.json") as? JSONDictionary {
            let object = Message(data:json)
            XCTAssert(object.body == "Hello! [Hola!](https://www.reddit.com/r/reddit.com/wiki/templat.....")
            XCTAssert(object.wasComment == false)
            XCTAssert(object.firstMessage == "")
            XCTAssert(object.name == "t4_36sfhx")
            XCTAssert(object.firstMessageName == "")
            XCTAssert(object.created == 1427126074)
            XCTAssert(object.dest == "sonson_twit")
            XCTAssert(object.author == "reddit")
            XCTAssert(object.createdUtc == 1427122474)
            XCTAssert(object.bodyHtml == "<!-- SC_.....")
            XCTAssert(object.subreddit == "")
            XCTAssert(object.parentId == "")
            XCTAssert(object.context == "")
            XCTAssert(object.replies == "")
            XCTAssert(object.id == "36sfhx")
            XCTAssert(object.new == false)
            XCTAssert(object.distinguished == "admin")
            XCTAssert(object.subject == "Hello, /u/sonson_twit! Welcome to reddit!")
        }
    }
    
    func testParsingT5JsonFile() {
        print("Each property of t5 has been loaded correctly")
        if let json = self.jsonFromFileName("t5.json") as? JSONDictionary {
            let object = Subreddit(data:json)
            XCTAssert(object.bannerImg == "")
            XCTAssert(object.userSrThemeEnabled == true)
            XCTAssert(object.submitTextHtml == "<!-- SC_OFF --><div class=\"md\"><p><strong>GIFs are banned.</strong>\nIf you want to post a GIF, please <a href=\"http://imgur.com\">rehost it as a GIFV</a> instead. <a href=\"http://www.reddit.com/r/woahdude/wiki/html5\">(Read more)</a></p>\n\n<p><strong>Link flair is mandatory.</strong>\nClick &quot;Add flair&quot; button after you submit. The button will be located under your post title. <a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_flair_is_mandatory\">(read more)</a></p>\n\n<p><strong>XPOST labels are banned.</strong>\nCrossposts are fine, just don&#39;t label them as such. <a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_.5Bxpost.5D_tags.2Flabels_are_banned\">(read more)</a></p>\n\n<p><strong>Trippy or Mesmerizing content only!</strong>\nWhat is WoahDude-worthy content? <a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_what_is_.22woahdude_material.22.3F\">(Read more)</a></p>\n</div><!-- SC_ON -->")
            XCTAssert(object.userIsBanned == false)
            XCTAssert(object.id == "2r8tu")
            XCTAssert(object.submitText == "**GIFs are banned.**\nIf you want to post a GIF, please [rehost it as a GIFV](http://imgur.com) instead. [(Read more)](http://www.reddit.com/r/woahdude/wiki/html5)\n\n**Link flair is mandatory.**\nClick \"Add flair\" button after you submit. The button will be located under your post title. [(read more)](http://www.reddit.com/r/woahdude/wiki/index#wiki_flair_is_mandatory)\n\n**XPOST labels are banned.**\nCrossposts are fine, just don't label them as such. [(read more)](http://www.reddit.com/r/woahdude/wiki/index#wiki_.5Bxpost.5D_tags.2Flabels_are_banned)\n\n**Trippy or Mesmerizing content only!**\nWhat is WoahDude-worthy content? [(Read more)](http://www.reddit.com/r/woahdude/wiki/index#wiki_what_is_.22woahdude_material.22.3F)")
            XCTAssert(object.displayName == "woahdude")
            XCTAssert(object.headerImg == "http://b.thumbs.redditmedia.com/fnO6IreM4s_Em4dTIU2HtmZ_NTw7dZdlCoaLvtKwbzM.png")
            XCTAssert(object.descriptionHtml == "<!-- SC_OFF --><div class=\"md\"><h5><a href=\"https://www.reddit.com/r/woahdude/comments/2qi1jh/best_of_rwoahdude_2014_results/?\">Best of WoahDude 2014 ⇦</a></h5>\n\n<p><a href=\"#nyanbro\"></a></p>\n\n<h4><strong>What is WoahDude?</strong></h4>\n\n<p><em>The best links to click while you&#39;re stoned!</em> </p>\n\n<p>Trippy &amp; mesmerizing games, video, audio &amp; images that make you go &#39;woah dude!&#39;</p>\n\n<p>No one wants to have to sift through the entire internet for fun links when they&#39;re stoned - so make this your one-stop shop!</p>\n\n<p>⇨ <a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_what_is_.22woahdude_material.22.3F\">more in-depth explanation here</a> ⇦</p>\n\n<h4><strong>Filter WoahDude by flair</strong></h4>\n\n<p><a href=\"http://www.reddit.com/r/woahdude/search?q=flair:picture&amp;sort=top&amp;restrict_sr=on\">picture</a> - Static images</p>\n\n<p><a href=\"http://www.reddit.com/r/woahdude/search?q=flair:wallpaper+OR+%5BWALLPAPER%5D&amp;sort=top&amp;restrict_sr=on\">wallpaper</a> - PC or Smartphone</p>\n\n<p><a href=\"http://www.reddit.com/r/woahdude/search?q=flair%3Agifv+OR+flair%3Awebm&amp;restrict_sr=on&amp;sort=top&amp;t=all\">gifv</a> - Animated images</p>\n\n<p><a href=\"http://www.reddit.com/r/woahdude/search?q=flair:audio&amp;sort=top&amp;restrict_sr=on\">audio</a> - Non-musical audio </p>\n\n<p><a href=\"http://www.reddit.com/r/woahdude/search?q=flair:music&amp;sort=top&amp;restrict_sr=on\">music</a>  - Include: Band &amp; Song Title</p>\n\n<p><a href=\"http://www.reddit.com/r/woahdude/search?q=flair:musicvideo&amp;sort=top&amp;restrict_sr=on\">music video</a> - If slideshow, tag [music] </p>\n\n<p><a href=\"http://www.reddit.com/r/woahdude/search?q=flair:video&amp;sort=top&amp;restrict_sr=on\">video</a> - Non-musical video</p>\n\n<p><a href=\"http://redd.it/29owi1#movies\">movies</a> - Movies</p>\n\n<p><a href=\"http://www.reddit.com/r/woahdude/search?q=flair:game&amp;restrict_sr=on&amp;sort=top&amp;t=all\">game</a> - Goal oriented games</p>\n\n<p><a href=\"http://www.reddit.com/r/woahdude/search?q=flair%3Ainteractive+OR+sandbox&amp;sort=top&amp;restrict_sr=on&amp;t=all\">interactive</a> - Interactive pages</p>\n\n<p><a href=\"http://www.reddit.com/r/woahdude/comments/1jri9s/woahdude_featured_apps_get_free_download_codes/\">mobile app</a> - Mod-curated selection of apps</p>\n\n<p><a href=\"http://www.reddit.com/r/WoahDude/search?q=flair%3Atext&amp;restrict_sr=on&amp;sort=top&amp;t=all\">text</a> - Articles, selfposts &amp; textpics</p>\n\n<p><a href=\"http://www.reddit.com/r/woahdude/search?q=flair%3Awoahdude%2Bapproved&amp;sort=new&amp;restrict_sr=on&amp;t=all\">WOAHDUDE APPROVED</a> - Mod-curated selection of the best WoahDude submissions.</p>\n\n<h4>RULES  <a href=\"http://www.reddit.com/r/woahdude/wiki\">⇨ FULL VERSION</a></h4>\n\n<blockquote>\n<ol>\n<li>LINK FLAIR <strong>is <a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_flair_is_mandatory\">mandatory</a>.</strong></li>\n<li>XPOST <strong>labels are <a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_.5Bxpost.5D_tags.2Flabels_are_banned\">banned</a>. Crossposts are fine, just don&#39;t label them as such.</strong></li>\n<li> NO <strong>hostility!</strong> PLEASE <strong>giggle like a giraffe :)</strong></li>\n</ol>\n</blockquote>\n\n<p>Certain reposts are allowed. <a href=\"http://www.reddit.com/r/woahdude/wiki/index#wiki_reposts\">Learn more</a>. Those not allowed may be reported via this form:</p>\n\n<p><a href=\"http://www.reddit.com/message/compose?to=%2Fr%2Fwoahdude&amp;subject=Repost%20Report&amp;message=Here%20%5bLINK%5d%20is%20an%20illegitimate%20repost,%20and%20here%20%5bLINK%5d%20is%20proof%20that%20the%20original%20woahdude%20post%20had%201500%2b%20upvotes.#reportwarning\"></a> <a href=\"http://www.reddit.com/message/compose?to=%2Fr%2Fwoahdude&amp;subject=Repost%20Report&amp;message=Here%20%5bLINK%5d%20is%20an%20illegitimate%20repost,%20and%20here%20%5bLINK%5d%20is%20proof%20that%20the%20original%20woahdude%20post%20had%201500%2b%20upvotes.\"><strong>REPORT AN ILLEGITIMATE REPOST</strong></a></p>\n\n<h4>WoahDude community</h4>\n\n<ul>\n<li><a href=\"/r/WoahDude\">/r/WoahDude</a> - All media</li>\n<li><a href=\"/r/WoahTube\">/r/WoahTube</a> - Videos only</li>\n<li><a href=\"/r/WoahTunes\">/r/WoahTunes</a> - Music only</li>\n<li><a href=\"/r/StonerPhilosophy\">/r/StonerPhilosophy</a> - Text posts only</li>\n<li><a href=\"/r/WoahPoon\">/r/WoahPoon</a> - NSFW</li>\n<li><strong><a href=\"http://www.reddit.com/user/rWoahDude/m/woahdude\">MULTIREDDIT</a></strong></li>\n</ul>\n\n<h5><a href=\"http://facebook.com/rWoahDude\"></a></h5>\n\n<h5><a href=\"http://twitter.com/rWoahDude\"></a></h5>\n\n<h5><a href=\"http://emilydavis.bandcamp.com/track/sagans-song\">http://emilydavis.bandcamp.com/track/sagans-song</a></h5>\n</div><!-- SC_ON -->")
            XCTAssert(object.title == "The BEST links to click while you're STONED")
            XCTAssert(object.collapseDeletedComments == true)
            XCTAssert(object.over18 == false)
            XCTAssert(object.publicDescriptionHtml == "<!-- SC_OFF --><div class=\"md\"><p>The best links to click while you&#39;re stoned!</p>\n\n<p>Trippy, mesmerizing, and mindfucking games, video, audio &amp; images that make you go &#39;woah dude!&#39;</p>\n\n<p>If you like to look at amazing stuff while smoking weed or doing other drugs, come inside for some Science, Philosophy, Mindfucks, Math, Engineering, Illusions and Cosmic weirdness.</p>\n</div><!-- SC_ON -->")
            XCTAssert(object.iconSize == [145, 60])
            XCTAssert(object.iconImg == "")
            XCTAssert(object.headerTitle == "Turn on the stylesheet and click Carl Sagan's head")
            XCTAssert(object.description == "#####[Best of WoahDude 2014 ⇦](https://www.reddit.com/r/woahdude/comments/2qi1jh/best_of_rwoahdude_2014_results/?)\n\n[](#nyanbro)\n\n####**What is WoahDude?**\n\n*The best links to click while you're stoned!* \n\nTrippy & mesmerizing games, video, audio & images that make you go 'woah dude!'\n\nNo one wants to have to sift through the entire internet for fun links when they're stoned - so make this your one-stop shop!\n\n⇨ [more in-depth explanation here](http://www.reddit.com/r/woahdude/wiki/index#wiki_what_is_.22woahdude_material.22.3F) ⇦\n\n####**Filter WoahDude by flair**\n\n[picture](http://www.reddit.com/r/woahdude/search?q=flair:picture&sort=top&restrict_sr=on) - Static images\n\n[wallpaper](http://www.reddit.com/r/woahdude/search?q=flair:wallpaper+OR+[WALLPAPER]&sort=top&restrict_sr=on) - PC or Smartphone\n\n[gifv](http://www.reddit.com/r/woahdude/search?q=flair%3Agifv+OR+flair%3Awebm&restrict_sr=on&sort=top&t=all) - Animated images\n\n[audio](http://www.reddit.com/r/woahdude/search?q=flair:audio&sort=top&restrict_sr=on) - Non-musical audio \n\n[music](http://www.reddit.com/r/woahdude/search?q=flair:music&sort=top&restrict_sr=on)  - Include: Band & Song Title\n\n[music video](http://www.reddit.com/r/woahdude/search?q=flair:musicvideo&sort=top&restrict_sr=on) - If slideshow, tag [music] \n\n[video](http://www.reddit.com/r/woahdude/search?q=flair:video&sort=top&restrict_sr=on) - Non-musical video\n\n[movies](http://redd.it/29owi1#movies) - Movies\n\n[game](http://www.reddit.com/r/woahdude/search?q=flair:game&restrict_sr=on&sort=top&t=all) - Goal oriented games\n\n[interactive](http://www.reddit.com/r/woahdude/search?q=flair%3Ainteractive+OR+sandbox&sort=top&restrict_sr=on&t=all) - Interactive pages\n\n[mobile app](http://www.reddit.com/r/woahdude/comments/1jri9s/woahdude_featured_apps_get_free_download_codes/) - Mod-curated selection of apps\n\n[text](http://www.reddit.com/r/WoahDude/search?q=flair%3Atext&restrict_sr=on&sort=top&t=all) - Articles, selfposts & textpics\n\n[WOAHDUDE APPROVED](http://www.reddit.com/r/woahdude/search?q=flair%3Awoahdude%2Bapproved&sort=new&restrict_sr=on&t=all) - Mod-curated selection of the best WoahDude submissions.\n\n####RULES  [⇨ FULL VERSION](http://www.reddit.com/r/woahdude/wiki) \n\n> 1. LINK FLAIR **is [mandatory](http://www.reddit.com/r/woahdude/wiki/index#wiki_flair_is_mandatory).**\n2. XPOST **labels are [banned](http://www.reddit.com/r/woahdude/wiki/index#wiki_.5Bxpost.5D_tags.2Flabels_are_banned). Crossposts are fine, just don't label them as such.**\n3.  NO **hostility!** PLEASE **giggle like a giraffe :)**\n\nCertain reposts are allowed. [Learn more](http://www.reddit.com/r/woahdude/wiki/index#wiki_reposts). Those not allowed may be reported via this form:\n\n[](http://www.reddit.com/message/compose?to=%2Fr%2Fwoahdude&subject=Repost%20Report&message=Here%20%5bLINK%5d%20is%20an%20illegitimate%20repost,%20and%20here%20%5bLINK%5d%20is%20proof%20that%20the%20original%20woahdude%20post%20had%201500%2b%20upvotes.#reportwarning) [**REPORT AN ILLEGITIMATE REPOST**](http://www.reddit.com/message/compose?to=%2Fr%2Fwoahdude&subject=Repost%20Report&message=Here%20%5bLINK%5d%20is%20an%20illegitimate%20repost,%20and%20here%20%5bLINK%5d%20is%20proof%20that%20the%20original%20woahdude%20post%20had%201500%2b%20upvotes.)\n\n####WoahDude community\n\n* /r/WoahDude - All media\n* /r/WoahTube - Videos only\n* /r/WoahTunes - Music only\n* /r/StonerPhilosophy - Text posts only\n* /r/WoahPoon - NSFW\n* **[MULTIREDDIT](http://www.reddit.com/user/rWoahDude/m/woahdude)**\n\n#####[](http://facebook.com/rWoahDude)\n#####[](http://twitter.com/rWoahDude)\n\n#####http://emilydavis.bandcamp.com/track/sagans-song")
            XCTAssert(object.submitLinkLabel == "SUBMIT LINK")
            XCTAssert(object.accountsActive == 0)
            XCTAssert(object.publicTraffic == false)
            XCTAssert(object.headerSize == [145, 60])
            XCTAssert(object.subscribers == 778611)
            XCTAssert(object.submitTextLabel == "SUBMIT TEXT")
            XCTAssert(object.userIsModerator == false)
            XCTAssert(object.name == "t5_2r8tu")
            XCTAssert(object.created == 1254666760)
            XCTAssert(object.url == "/r/woahdude/")
            XCTAssert(object.hideAds == false)
            XCTAssert(object.createdUtc == 1254663160)
            XCTAssert(object.bannerSize == [])
            XCTAssert(object.userIsContributor == false)
            XCTAssert(object.publicDescription == "The best links to click while you're stoned!\n\nTrippy, mesmerizing, and mindfucking games, video, audio & images that make you go 'woah dude!'\n\nIf you like to look at amazing stuff while smoking weed or doing other drugs, come inside for some Science, Philosophy, Mindfucks, Math, Engineering, Illusions and Cosmic weirdness.\n\n")
            XCTAssert(object.commentScoreHideMins == 0)
            XCTAssert(object.subredditType == "public")
            XCTAssert(object.submissionType == "any")
            XCTAssert(object.userIsSubscriber == true)
        }
    }
    
    func testParsingMoreJsonFile() {
        print("Each property of more has been loaded correctly")
        if let json = self.jsonFromFileName("more.json") as? JSONDictionary {
            let object = More(data:json)
            XCTAssert(object.count == 0)
            XCTAssert(object.parentId == "t1_cp88kh5")
            XCTAssert(object.children == ["cpddp7v", "cp8jvj8", "cp8cv4b"])
            XCTAssert(object.name == "t1_cpddp7v")
            XCTAssert(object.id == "cpddp7v")
        }
    }
    
    func testParsingLabeledMultiJsonFile() {
        print("Each property of more has been loaded correctly")
        if let json = self.jsonFromFileName("LabeledMulti.json") as? JSONDictionary {
            let object = Multireddit(json:json)
            XCTAssert(object.canEdit == true)
            XCTAssert(object.displayName == "english")
            XCTAssert(object.name == "english")
            XCTAssert(object.descriptionHtml == "")
            XCTAssert(object.created == 1432028681)
            XCTAssert(object.copiedFrom == "")
            XCTAssert(object.iconUrl == "")
            XCTAssert(object.subreddits == ["redditdev", "swift"])
            XCTAssert(object.createdUtc == 1431999881)
            XCTAssert(object.keyColor == "#cee3f8")
            XCTAssert(object.visibility == MultiredditVisibility.Private)
            XCTAssert(object.iconName == MultiredditIconName.None)
            XCTAssert(object.weightingScheme == MultiredditWeightingScheme.Classic)
            XCTAssert(object.path == "/user/sonson_twit/m/english")
            XCTAssert(object.descriptionMd == "")
        }
    }
    
    func testParsingLabeledMultiDescriptionJsonFile() {
        print("Each property of more has been loaded correctly")
        if let json = self.jsonFromFileName("LabeledMultiDescription.json") as? JSONDictionary {
            let object = MultiredditDescription(json:json)
            XCTAssert(object.bodyHtml == "<!-- SC_OFF --><div class=\"md\"><p>updated</p>\n</div><!-- SC_ON -->")
            XCTAssert(object.bodyMd == "updated")
        }
    }
    
    func testParsingNeedsCAPTHCAResponseStringTest() {
        print("is true or false")
        var isSucceeded = false
        if let path = NSBundle(forClass: self.classForCoder).pathForResource("api_needs_captcha.json", ofType:nil) {
            if let data = NSData(contentsOfFile: path) {
                let result = data2Bool(data)
                switch result {
                case .Failure:
                    print(result.error!.description)
                case .Success:
                    isSucceeded = true
                }
            }
        }
        XCTAssert(isSucceeded == true)
    }
    
    func testParsingCAPTHCAIdenResponseJSONTest() {
        print("Each property of more has been loaded correctly")
        var isSucceeded = false
        if let thing = self.jsonFromFileName("api_new_captcha.json") as? JSONDictionary {
            let result = idenJSON2String(thing)
            switch result {
            case .Failure(let error):
                print(error.description)
            case .Success:
                isSucceeded = true
            }
        }
        XCTAssert(isSucceeded == true)
    }
}
