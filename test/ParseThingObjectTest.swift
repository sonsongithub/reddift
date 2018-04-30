//
//  ParseThingObjectTest.swift
//  reddift
//
//  Created by sonson on 2015/04/22.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import XCTest

extension XCTestCase {
    func jsonFromFileName(_ name: String) -> Any? {
        if let path = Bundle(for: self.classForCoder).path(forResource: name, ofType: nil) {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                do {
                    return try JSONSerialization.jsonObject(with: data, options: [])
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
            let object = Comment(json: json)
            
            XCTAssert(object.subredditId == "t5_2qizd")
            XCTAssert(object.bannedBy == "")
            XCTAssert(object.linkId == "t3_32wnhw")
            XCTAssert(object.likes == .up)
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
            XCTAssert(object.distinguished == .none)
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
            let object = Account(json: json)
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
            let object = Link(json: json)
            XCTAssert(object.domain == "self.redditdev")
            XCTAssert(object.bannedBy == "")
            XCTAssert(object.subreddit == "redditdev")
            XCTAssert(object.selftextHtml == "<!-- SC_OFF --><div class=\"md\"><p>So this is the code I ran:</p>\n\n<pre><code>r = praw.Reddit(&quot;/u/habnpam sflkajsfowifjsdlkfj test test test&quot;)\n\n\nfor c in praw.helpers.comment_stream(reddit_session=r, subreddit=&quot;helpmefind&quot;, limit=500, verbosity=1):\n    print(c.author)\n</code></pre>\n\n<hr/>\n\n<p>From what I understand, comment_stream() gets the most recent comments. So if we specify the limit to be 100, it will initially get the 100 newest comment, and then constantly update to get new comments.  It seems to works appropriately for every subreddit except <a href=\"/r/helpmefind\">/r/helpmefind</a>. For <a href=\"/r/helpmefind\">/r/helpmefind</a>, it fetches around 30 comments, regardless of the limit.</p>\n</div><!-- SC_ON -->")
            XCTAssert(object.selftext == "So this is the code I ran:\n\n    r = praw.Reddit(\"/u/habnpam sflkajsfowifjsdlkfj test test test\")\n    \n\n    for c in praw.helpers.comment_stream(reddit_session=r, subreddit=\"helpmefind\", limit=500, verbosity=1):\n        print(c.author)\n\n\n---\n\nFrom what I understand, comment_stream() gets the most recent comments. So if we specify the limit to be 100, it will initially get the 100 newest comment, and then constantly update to get new comments.  It seems to works appropriately for every subreddit except /r/helpmefind. For /r/helpmefind, it fetches around 30 comments, regardless of the limit.")
            XCTAssertTrue((object.likes == .none), "check likes's value.")
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
            XCTAssert(object.distinguished == .none)
            
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
            let object = Message(json: json)
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
            let object = Subreddit(json: json)
            XCTAssert(object.bannerImg == "http://b.thumbs.redditmedia.com/-LmpT3ePYhuPbM0BKJ05jfsKJQV9YtXun44_ZEuGK7o.png")
            XCTAssert(object.submitTextHtml == "<!-- SC_OFF --><div class=\"md\"><ul>\n<li>No Images.<br/></li>\n<li>Please avoid editorialising link titles — use the original article&#39;s title where possible.<br/></li>\n</ul>\n\n<p>Please consider posting to <a href=\"/r/AppleHelp\">/r/AppleHelp</a> for the following:</p>\n\n<ul>\n<li>Requests for technical help of any kind.</li>\n<li><p>Problems with software or hardware.</p></li>\n<li><p>The worth of software or hardware. (Try Mac2Sell)</p></li>\n<li><p>What software or hardware to buy. (Try MacRumors Buying Guide)</p></li>\n<li><p>When hardware will be updated.</p></li>\n</ul>\n\n<p>See the <a href=\"http://www.reddit.com/r/apple/about/sidebar\">sidebar of the subreddit</a> for other rules and guidelines.  </p>\n\n<p>If you have a question, <a href=\"http://www.reddit.com/message/compose?to=%2Fr%2Fapple\">ask the mods</a> please. </p>\n\n<p>Thank you.</p>\n</div><!-- SC_ON -->")
            XCTAssert(object.userIsBanned == false)
            XCTAssert(object.wikiEnabled == true)
            XCTAssert(object.showMedia == false)
            XCTAssert(object.id == "2qh1f")
            XCTAssert(object.userIsContributor == false)
            XCTAssert(object.submitText == "* No Images.   \n* Please avoid editorialising link titles — use the original article's title where possible.  \n\nPlease consider posting to /r/AppleHelp for the following:\n\n* Requests for technical help of any kind.\n* Problems with software or hardware.\n\n* The worth of software or hardware. (Try Mac2Sell)\n\n* What software or hardware to buy. (Try MacRumors Buying Guide)\n\n* When hardware will be updated.\n\nSee the [sidebar of the subreddit](http://www.reddit.com/r/apple/about/sidebar) for other rules and guidelines.  \n\nIf you have a question, [ask the mods](http://www.reddit.com/message/compose?to=%2Fr%2Fapple) please. \n\nThank you.")
            XCTAssert(object.displayName == "apple")
            XCTAssert(object.headerImg == "http://b.thumbs.redditmedia.com/K_Qtc09EwZKKUbzY.png")
            XCTAssert(object.descriptionHtml == "<!-- SC_OFF --><div class=\"md\"><h1>Welcome!</h1>\n\n<p>Welcome to <a href=\"/r/Apple\">r/Apple</a>, the community for Apple news, rumors, and discussions.  If you have a tech question, please check out <a href=\"/r/applehelp/\">AppleHelp</a>!</p>\n\n<h1>New to Mac?</h1>\n\n<p>Are you a new Mac owner? Check out <a href=\"http://www.reddit.com/r/apple/wiki/appletips\">this user-maintained wiki for helpful tips</a>!</p>\n\n<h1>Not sure what to buy?</h1>\n\n<p>Check out <a href=\"https://www.reddit.com/r/apple/wiki/whatshouldibuy\">this user-maintained wiki</a> or ask in our dedicated sister sub <strong><a href=\"/r/AppleWhatShouldIBuy\">/r/AppleWhatShouldIBuy</a></strong>!</p>\n\n<h1>Rules</h1>\n\n<ol>\n<li>No memes or direct image/video posts.</li>\n<li>No NSFW content.</li>\n<li>Self-Posts Must Foster Reasonable Discussion.</li>\n<li>No editorialized link titles (use the original article’s title when possible).</li>\n<li>No rude, offensive, or hateful comments.</li>\n<li>No posts that aren’t directly related to Apple or the Apple eco-system.</li>\n<li>No simple and/or easily searched support questions. We may approve your post if it is a high-level issue that can&#39;t be found on page 1 of Google.</li>\n<li>No spam. Self-promotion is allowed on Saturdays only.</li>\n<li>No content related to piracy or illegal activities.</li>\n<li>No posts or comments relating to buying, selling, trading, giveaways or asking for advice about any of those topics. The proper place for advice is <a href=\"/r/AppleWhatShouldIBuy\">/r/AppleWhatShouldIBuy</a>.</li>\n<li><strong>No posts about bugs in beta software.</strong> These belong in the beta subreddits listed below.</li>\n</ol>\n\n<h1>Events</h1>\n\n<p><em>Event submissions must be a comment in the weekly stickied megathread, or will be removed.</em></p>\n\n<table><thead>\n<tr>\n<th><strong>Event</strong></th>\n<th>Time</th>\n</tr>\n</thead><tbody>\n<tr>\n<td>Wallpaper Wednesday</td>\n<td>9am ET</td>\n</tr>\n<tr>\n<td>Free Talk Friday</td>\n<td>9am ET</td>\n</tr>\n<tr>\n<td>Self-Promotion Saturday<sup>†</sup></td>\n<td>All Day</td>\n</tr>\n<tr>\n<td>Monthly APPreciation</td>\n<td>First Day of Each Month</td>\n</tr>\n</tbody></table>\n\n<p><sup>†</sup> no mega thread, submit posts as usual</p>\n\n<p><a href=\"https://www.reddit.com/r/apple/search?q=author%3A%27automoderator%27&amp;restrict_sr=on&amp;sort=new&amp;t=all\">Weekly Megathread Archives</a></p>\n\n<h1>IRC Chat</h1>\n\n<ul>\n<li> <strong><a href=\"https://kiwiirc.com/client/irc.snoonet.org/apple?nick=CHANGE_ME\">Join the IRC via web chat</a></strong></li>\n<li>IRC Server: irc.snoonet.org </li>\n<li>Channel: #apple</li>\n</ul>\n\n<h1>Apple Subreddits</h1>\n\n<ul>\n<li><strong><a href=\"/r/applehelp\">Apple Help</a></strong></li>\n<li><a href=\"/r/applemusic\">Apple Music</a></li>\n<li><a href=\"/r/swift\">Swift Programming Language</a></li>\n<li><a href=\"/r/simpleios\">SimpleiOS</a></li>\n<li><a href=\"/r/sirifail\">Siri Fail</a></li>\n</ul>\n\n<h1>Mac Subreddits</h1>\n\n<ul>\n<li><a href=\"/r/MacOS\">MacOS</a>, <a href=\"/r/osx\">OSX</a></li>\n<li><a href=\"/r/Mac\">Mac</a>, <a href=\"/r/Macbook\">MacBook</a></li>\n<li><a href=\"/r/macapps\">MacApps</a></li>\n<li><a href=\"/r/MacGaming\">MacGaming</a></li>\n<li><a href=\"/r/hackintosh\">Hackintosh</a></li>\n<li><a href=\"/r/apple2\">Apple II</a></li>\n<li><a href=\"/r/BootCamp\">BootCamp</a></li>\n<li><a href=\"/r/MacSetups\">MacSetups</a></li>\n<li><a href=\"/r/Retina\">Retina</a></li>\n<li><a href=\"/r/appleswap\">AppleSwap</a> </li>\n<li><a href=\"/r/vintageapple\">VintageApple</a></li>\n</ul>\n\n<h1>iOS Subreddits</h1>\n\n<ul>\n<li><a href=\"/r/iphone\">iPhone</a></li>\n<li><a href=\"/r/ipad\">iPad</a></li>\n<li><a href=\"/r/applewatch\">Apple Watch</a></li>\n<li><a href=\"/r/appletv\">AppleTV</a></li>\n<li><a href=\"/r/ipod\">iPod</a></li>\n<li><a href=\"/r/iOSGaming\">iOSGaming</a></li>\n<li><a href=\"/r/ipadmusic\">iPadMusic</a></li>\n<li><a href=\"/r/apphookup\">AppHookUp</a></li>\n<li><a href=\"/r/iOS7\">iOS7</a>, <a href=\"/r/iOS8\">iOS8</a>, <a href=\"/r/iOS9\">iOS9</a></li>\n<li><a href=\"/r/CarPlay\">CarPlay</a></li>\n<li><a href=\"/r/jailbreak\">Jailbreak</a></li>\n<li><a href=\"/r/iOSThemes\">iOSThemes</a></li>\n<li><a href=\"/r/AlienBlue\">AlienBlue</a></li>\n<li><a href=\"/r/iphonewallpapers/\">iPhone</a>, <a href=\"/r/ipadwallpapers/\">iPad</a> or <a href=\"/r/applewatchwallpapers/\">Apple Watch</a> wallpapers</li>\n<li><a href=\"/r/homekit\">HomeKit</a></li>\n</ul>\n\n<h1>Beta Subreddits</h1>\n\n<ul>\n<li><a href=\"https://www.reddit.com/r/iOSBeta\">iOS</a></li>\n<li><a href=\"/r/osxbeta\">macOS</a></li>\n<li><a href=\"/r/tvOSBeta\">tvOS</a></li>\n<li><a href=\"/r/watchosbeta\">Apple Watch</a></li>\n</ul>\n\n<h1>Tech Subreddits</h1>\n\n<ul>\n<li><a href=\"/r/Technology\">Technology</a></li>\n<li><a href=\"/r/laptops\">Laptops</a></li>\n<li><a href=\"/r/Programming\">Programming</a></li>\n</ul>\n\n<h1>Content Philosophy</h1>\n\n<p>Content which benefits the <strong>community</strong> (news, rumors, and discussions) is valued over content which benefits only the <strong>individual</strong> (technical questions, help buying/selling, rants, etc.).  This fundamental difference in audience is why we support two communities, <a href=\"/r/apple\">r/Apple</a> and <a href=\"/r/applehelp\">r/AppleHelp</a>.  If you&#39;d like to view their content together, click <a href=\"/r/apple+applehelp\">here</a>.</p>\n</div><!-- SC_ON -->")
            XCTAssert(object.title == "Apple")
            XCTAssert(object.collapseDeletedComments == true)
            XCTAssert(object.publicDescription == "Apple devices (iPhone, Apple Watch, Apple TV, iPod) and computers (Mac), software running on them (iOS, macOS, watchOS, tvOS), Apple the company and news, rumors, opinions and analysis pertaining to the company from Cupertino.\n")
            XCTAssert(object.over18 == false)
            XCTAssert(object.publicDescriptionHtml == "<!-- SC_OFF --><div class=\"md\"><p>Apple devices (iPhone, Apple Watch, Apple TV, iPod) and computers (Mac), software running on them (iOS, macOS, watchOS, tvOS), Apple the company and news, rumors, opinions and analysis pertaining to the company from Cupertino.</p>\n</div><!-- SC_ON -->")
            XCTAssert(object.iconSize == [256, 256])
            XCTAssert(object.iconImg == "http://a.thumbs.redditmedia.com/lFTF1eT170AlkGXKosQEgA7bHctvDBv5DWTKUjjCU98.png")
            XCTAssert(object.headerTitle == "")
//            print(object.description)
            do {
                if let data = object.description.data(using: .utf8) {
                    try data.write(to: URL(fileURLWithPath: "/Users/sonson/Desktop/hoge.json"))
                }
            } catch {
                print(error)
            }
            XCTAssert(object.description == "Welcome!\n==\n\nWelcome to r/Apple, the community for Apple news, rumors, and discussions.  If you have a tech question, please check out [AppleHelp](/r/applehelp/)!\n\nNew to Mac?\n==\n\nAre you a new Mac owner? Check out [this user-maintained wiki for helpful tips](http://www.reddit.com/r/apple/wiki/appletips)!\n\n\nNot sure what to buy?\n==\n\nCheck out [this user-maintained wiki](https://www.reddit.com/r/apple/wiki/whatshouldibuy) or ask in our dedicated sister sub **/r/AppleWhatShouldIBuy**!\n\n\nRules\n==\n\n1. No memes or direct image/video posts.\n2. No NSFW content.\n3. Self-Posts Must Foster Reasonable Discussion.\n4. No editorialized link titles (use the original article’s title when possible).\n5. No rude, offensive, or hateful comments.\n6. No posts that aren’t directly related to Apple or the Apple eco-system.\n7. No simple and/or easily searched support questions. We may approve your post if it is a high-level issue that can't be found on page 1 of Google.\n8. No spam. Self-promotion is allowed on Saturdays only.\n9. No content related to piracy or illegal activities.\n10. No posts or comments relating to buying, selling, trading, giveaways or asking for advice about any of those topics. The proper place for advice is /r/AppleWhatShouldIBuy.\n11. **No posts about bugs in beta software.** These belong in the beta subreddits listed below.\n\nEvents\n==\n\n*Event submissions must be a comment in the weekly stickied megathread, or will be removed.*\n\n| **Event** | Time |\n|-----------------------------|---------------------|\n| Wallpaper Wednesday | 9am ET |\n| Free Talk Friday | 9am ET |\n| Self-Promotion Saturday^† | All Day |\n| Monthly APPreciation | First Day of Each Month |\n^† no mega thread, submit posts as usual\n\n[Weekly Megathread Archives](https://www.reddit.com/r/apple/search?q=author%3A%27automoderator%27&restrict_sr=on&sort=new&t=all)\n\nIRC Chat\n==\n\n*  **[Join the IRC via web chat](https://kiwiirc.com/client/irc.snoonet.org/apple?nick=CHANGE_ME)**\n* IRC Server: irc.snoonet.org \n* Channel: #apple\n\nApple Subreddits\n==\n\n* **[Apple Help](/r/applehelp)**\n* [Apple Music](/r/applemusic)\n* [Swift Programming Language](/r/swift)\n* [SimpleiOS](/r/simpleios)\n* [Siri Fail](/r/sirifail)\n\nMac Subreddits\n==\n\n* [MacOS](/r/MacOS), [OSX](/r/osx)\n* [Mac](/r/Mac), [MacBook](/r/Macbook)\n* [MacApps](/r/macapps)\n* [MacGaming](/r/MacGaming)\n* [Hackintosh](/r/hackintosh)\n* [Apple II](/r/apple2)\n* [BootCamp](/r/BootCamp)\n* [MacSetups](/r/MacSetups)\n* [Retina](/r/Retina)\n* [AppleSwap](/r/appleswap) \n* [VintageApple](/r/vintageapple)\n\niOS Subreddits\n==\n\n* [iPhone](/r/iphone)\n* [iPad](/r/ipad)\n* [Apple Watch](/r/applewatch)\n* [AppleTV](/r/appletv)\n* [iPod](/r/ipod)\n* [iOSGaming](/r/iOSGaming)\n* [iPadMusic](/r/ipadmusic)\n* [AppHookUp](/r/apphookup)\n* [iOS7](/r/iOS7), [iOS8](/r/iOS8), [iOS9](/r/iOS9)\n* [CarPlay](/r/CarPlay)\n* [Jailbreak](/r/jailbreak)\n* [iOSThemes](/r/iOSThemes)\n* [AlienBlue](/r/AlienBlue)\n* [iPhone](/r/iphonewallpapers/), [iPad](/r/ipadwallpapers/) or [Apple Watch](/r/applewatchwallpapers/) wallpapers\n* [HomeKit](/r/homekit)\n\nBeta Subreddits\n==\n\n* [iOS](https://www.reddit.com/r/iOSBeta)\n* [macOS](/r/osxbeta)\n* [tvOS](/r/tvOSBeta)\n* [Apple Watch](/r/watchosbeta)\n\nTech Subreddits\n==\n\n* [Technology](/r/Technology)\n* [Laptops](/r/laptops)\n* [Programming](/r/Programming)\n\nContent Philosophy\n=\n\nContent which benefits the **community** (news, rumors, and discussions) is valued over content which benefits only the **individual** (technical questions, help buying/selling, rants, etc.).  This fundamental difference in audience is why we support two communities, [r/Apple](/r/apple) and [r/AppleHelp](/r/applehelp).  If you'd like to view their content together, click [here](/r/apple+applehelp).")
            XCTAssert(object.userIsMuted == false)
            XCTAssert(object.submitLinkLabel == "Submit Link")
            XCTAssert(object.accountsActive == 2050)
            XCTAssert(object.publicTraffic == true)
            XCTAssert(object.headerSize == [1, 1])
            XCTAssert(object.subscribers == 388422)
            XCTAssert(object.submitTextLabel == "Submit Self-Post")
            
            XCTAssert(object.language == "en")
            XCTAssert(object.keyColor == ReddiftColor.color(with: "#545452"))
            
            XCTAssert(object.name == "t5_2qh1f")
            XCTAssert(object.created == 1201261386)
            XCTAssert(object.url == "/r/apple/")
            
            XCTAssert(object.quarantine == false)
            
            XCTAssert(object.hideAds == false)
            XCTAssert(object.createdUtc == 1201232586)
            XCTAssert(object.bannerSize == [1280, 384])
            XCTAssert(object.userIsModerator == false)
            
            XCTAssert(object.userSrThemeEnabled == true)
            XCTAssert(object.showMediaPreview == true)
            
            XCTAssert(object.commentScoreHideMins == 240)
            XCTAssert(object.subredditType == "public")
            XCTAssert(object.submissionType == "any")
            XCTAssert(object.userIsSubscriber == true)
        }
    }
    
    func testParsingMoreJsonFile() {
        print("Each property of more has been loaded correctly")
        if let json = self.jsonFromFileName("more.json") as? JSONDictionary {
            let object = More(json: json)
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
            let object = Multireddit(json: json)
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
            XCTAssert(object.visibility == .private)
            XCTAssert(object.iconName == .none)
            XCTAssert(object.weightingScheme == .classic)
            XCTAssert(object.path == "/user/sonson_twit/m/english")
            XCTAssert(object.descriptionMd == "")
        }
    }
    
    func testParsingLabeledMultiDescriptionJsonFile() {
        print("Each property of more has been loaded correctly")
        if let json = self.jsonFromFileName("LabeledMultiDescription.json") as? JSONDictionary {
            let object = MultiredditDescription(json: json)
            XCTAssert(object.bodyHtml == "<!-- SC_OFF --><div class=\"md\"><p>updated</p>\n</div><!-- SC_ON -->")
            XCTAssert(object.bodyMd == "updated")
        }
    }
    
    func testParsingNeedsCAPTHCAResponseStringTest() {
        print("is true or false")
        var isSucceeded = false
        if let path = Bundle(for: self.classForCoder).path(forResource: "api_needs_captcha.json", ofType: nil) {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                let result = data2Bool(data)
                switch result {
                case .failure:
                    print(result.error!.description)
                case .success:
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
            case .failure(let error):
                print(error.description)
            case .success:
                isSucceeded = true
            }
        }
        XCTAssert(isSucceeded == true)
    }
}
