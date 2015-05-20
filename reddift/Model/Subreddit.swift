//
//  Subreddit.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-15 11:23:32 +0900
//

import Foundation

/// Protocol to integrate a code for subreddit and multireddit.
public protocol SubredditURLPath {
    var path:String {get}
}

/**
Subreddit object.
*/
public class Subreddit : Thing, SubredditURLPath {
    /**
    
    example:
    */
    public var bannerImg = ""
    /**
    
    example: true
    */
    public var userSrThemeEnabled = false
    /**
    
    example: &lt;!-- SC_OFF --&gt;&lt;div class="md"&gt;&lt;p&gt;&lt;strong&gt;GIFs are banned.&lt;/strong&gt;
    If you want to post a GIF, please &lt;a href="http://imgur.com"&gt;rehost it as a GIFV&lt;/a&gt; instead. &lt;a href="http://www.reddit.com/r/woahdude/wiki/html5"&gt;(Read more)&lt;/a&gt;&lt;/p&gt;
    
    &lt;p&gt;&lt;strong&gt;Link flair is mandatory.&lt;/strong&gt;
    Click &amp;quot;Add flair&amp;quot; button after you submit. The button will be located under your post title. &lt;a href="http://www.reddit.com/r/woahdude/wiki/index#wiki_flair_is_mandatory"&gt;(read more)&lt;/a&gt;&lt;/p&gt;
    
    &lt;p&gt;&lt;strong&gt;XPOST labels are banned.&lt;/strong&gt;
    Crossposts are fine, just don&amp;#39;t label them as such. &lt;a href="http://www.reddit.com/r/woahdude/wiki/index#wiki_.5Bxpost.5D_tags.2Flabels_are_banned"&gt;(read more)&lt;/a&gt;&lt;/p&gt;
    
    &lt;p&gt;&lt;strong&gt;Trippy or Mesmerizing content only!&lt;/strong&gt;
    What is WoahDude-worthy content? &lt;a href="http://www.reddit.com/r/woahdude/wiki/index#wiki_what_is_.22woahdude_material.22.3F"&gt;(Read more)&lt;/a&gt;&lt;/p&gt;
    &lt;/div&gt;&lt;!-- SC_ON --&gt;
    */
    public var submitTextHtml = ""
    /**
    whether the logged-in user is banned from the subreddit
    example: false
    */
    public var userIsBanned = false
    /**
    
    example: **GIFs are banned.**
    If you want to post a GIF, please [rehost it as a GIFV](http://imgur.com) instead. [(Read more)](http://www.reddit.com/r/woahdude/wiki/html5)
    
    **Link flair is mandatory.**
    Click "Add flair" button after you submit. The button will be located under your post title. [(read more)](http://www.reddit.com/r/woahdude/wiki/index#wiki_flair_is_mandatory)
    
    **XPOST labels are banned.**
    Crossposts are fine, just don't label them as such. [(read more)](http://www.reddit.com/r/woahdude/wiki/index#wiki_.5Bxpost.5D_tags.2Flabels_are_banned)
    
    **Trippy or Mesmerizing content only!**
    What is WoahDude-worthy content? [(Read more)](http://www.reddit.com/r/woahdude/wiki/index#wiki_what_is_.22woahdude_material.22.3F)
    */
    public var submitText = ""
    /**
    human name of the subreddit
    example: woahdude
    */
    public var displayName = ""
    /**
    full URL to the header image, or null
    example: http://b.thumbs.redditmedia.com/fnO6IreM4s_Em4dTIU2HtmZ_NTw7dZdlCoaLvtKwbzM.png
    */
    public var headerImg = ""
    /**
    sidebar text, escaped HTML format
    example: &lt;!-- SC_OFF --&gt;&lt;div class="md"&gt;&lt;h5&gt;&lt;a href="https://www.reddit.com/r/woahdude/comments/2qi1jh/best_of_rwoahdude_2014_results/?"&gt;Best of WoahDude 2014 ⇦&lt;/a&gt;&lt;/h5&gt;
    
    &lt;p&gt;&lt;a href="#nyanbro"&gt;&lt;/a&gt;&lt;/p&gt;
    
    &lt;h4&gt;&lt;strong&gt;What is WoahDude?&lt;/strong&gt;&lt;/h4&gt;
    
    &lt;p&gt;&lt;em&gt;The best links to click while you&amp;#39;re stoned!&lt;/em&gt; &lt;/p&gt;
    
    &lt;p&gt;Trippy &amp;amp; mesmerizing games, video, audio &amp;amp; images that make you go &amp;#39;woah dude!&amp;#39;&lt;/p&gt;
    
    &lt;p&gt;No one wants to have to sift through the entire internet for fun links when they&amp;#39;re stoned - so make this your one-stop shop!&lt;/p&gt;
    
    &lt;p&gt;⇨ &lt;a href="http://www.reddit.com/r/woahdude/wiki/index#wiki_what_is_.22woahdude_material.22.3F"&gt;more in-depth explanation here&lt;/a&gt; ⇦&lt;/p&gt;
    
    &lt;h4&gt;&lt;strong&gt;Filter WoahDude by flair&lt;/strong&gt;&lt;/h4&gt;
    
    &lt;p&gt;&lt;a href="http://www.reddit.com/r/woahdude/search?q=flair:picture&amp;amp;sort=top&amp;amp;restrict_sr=on"&gt;picture&lt;/a&gt; - Static images&lt;/p&gt;
    
    &lt;p&gt;&lt;a href="http://www.reddit.com/r/woahdude/search?q=flair:wallpaper+OR+%5BWALLPAPER%5D&amp;amp;sort=top&amp;amp;restrict_sr=on"&gt;wallpaper&lt;/a&gt; - PC or Smartphone&lt;/p&gt;
    
    &lt;p&gt;&lt;a href="http://www.reddit.com/r/woahdude/search?q=flair%3Agifv+OR+flair%3Awebm&amp;amp;restrict_sr=on&amp;amp;sort=top&amp;amp;t=all"&gt;gifv&lt;/a&gt; - Animated images&lt;/p&gt;
    
    &lt;p&gt;&lt;a href="http://www.reddit.com/r/woahdude/search?q=flair:audio&amp;amp;sort=top&amp;amp;restrict_sr=on"&gt;audio&lt;/a&gt; - Non-musical audio &lt;/p&gt;
    
    &lt;p&gt;&lt;a href="http://www.reddit.com/r/woahdude/search?q=flair:music&amp;amp;sort=top&amp;amp;restrict_sr=on"&gt;music&lt;/a&gt;  - Include: Band &amp;amp; Song Title&lt;/p&gt;
    
    &lt;p&gt;&lt;a href="http://www.reddit.com/r/woahdude/search?q=flair:musicvideo&amp;amp;sort=top&amp;amp;restrict_sr=on"&gt;music video&lt;/a&gt; - If slideshow, tag [music] &lt;/p&gt;
    
    &lt;p&gt;&lt;a href="http://www.reddit.com/r/woahdude/search?q=flair:video&amp;amp;sort=top&amp;amp;restrict_sr=on"&gt;video&lt;/a&gt; - Non-musical video&lt;/p&gt;
    
    &lt;p&gt;&lt;a href="http://redd.it/29owi1#movies"&gt;movies&lt;/a&gt; - Movies&lt;/p&gt;
    
    &lt;p&gt;&lt;a href="http://www.reddit.com/r/woahdude/search?q=flair:game&amp;amp;restrict_sr=on&amp;amp;sort=top&amp;amp;t=all"&gt;game&lt;/a&gt; - Goal oriented games&lt;/p&gt;
    
    &lt;p&gt;&lt;a href="http://www.reddit.com/r/woahdude/search?q=flair%3Ainteractive+OR+sandbox&amp;amp;sort=top&amp;amp;restrict_sr=on&amp;amp;t=all"&gt;interactive&lt;/a&gt; - Interactive pages&lt;/p&gt;
    
    &lt;p&gt;&lt;a href="http://www.reddit.com/r/woahdude/comments/1jri9s/woahdude_featured_apps_get_free_download_codes/"&gt;mobile app&lt;/a&gt; - Mod-curated selection of apps&lt;/p&gt;
    
    &lt;p&gt;&lt;a href="http://www.reddit.com/r/WoahDude/search?q=flair%3Atext&amp;amp;restrict_sr=on&amp;amp;sort=top&amp;amp;t=all"&gt;text&lt;/a&gt; - Articles, selfposts &amp;amp; textpics&lt;/p&gt;
    
    &lt;p&gt;&lt;a href="http://www.reddit.com/r/woahdude/search?q=flair%3Awoahdude%2Bapproved&amp;amp;sort=new&amp;amp;restrict_sr=on&amp;amp;t=all"&gt;WOAHDUDE APPROVED&lt;/a&gt; - Mod-curated selection of the best WoahDude submissions.&lt;/p&gt;
    
    &lt;h4&gt;RULES  &lt;a href="http://www.reddit.com/r/woahdude/wiki"&gt;⇨ FULL VERSION&lt;/a&gt;&lt;/h4&gt;
    
    &lt;blockquote&gt;
    &lt;ol&gt;
    &lt;li&gt;LINK FLAIR &lt;strong&gt;is &lt;a href="http://www.reddit.com/r/woahdude/wiki/index#wiki_flair_is_mandatory"&gt;mandatory&lt;/a&gt;.&lt;/strong&gt;&lt;/li&gt;
    &lt;li&gt;XPOST &lt;strong&gt;labels are &lt;a href="http://www.reddit.com/r/woahdude/wiki/index#wiki_.5Bxpost.5D_tags.2Flabels_are_banned"&gt;banned&lt;/a&gt;. Crossposts are fine, just don&amp;#39;t label them as such.&lt;/strong&gt;&lt;/li&gt;
    &lt;li&gt; NO &lt;strong&gt;hostility!&lt;/strong&gt; PLEASE &lt;strong&gt;giggle like a giraffe :)&lt;/strong&gt;&lt;/li&gt;
    &lt;/ol&gt;
    &lt;/blockquote&gt;
    
    &lt;p&gt;Certain reposts are allowed. &lt;a href="http://www.reddit.com/r/woahdude/wiki/index#wiki_reposts"&gt;Learn more&lt;/a&gt;. Those not allowed may be reported via this form:&lt;/p&gt;
    
    &lt;p&gt;&lt;a href="http://www.reddit.com/message/compose?to=%2Fr%2Fwoahdude&amp;amp;subject=Repost%20Report&amp;amp;message=Here%20%5bLINK%5d%20is%20an%20illegitimate%20repost,%20and%20here%20%5bLINK%5d%20is%20proof%20that%20the%20original%20woahdude%20post%20had%201500%2b%20upvotes.#reportwarning"&gt;&lt;/a&gt; &lt;a href="http://www.reddit.com/message/compose?to=%2Fr%2Fwoahdude&amp;amp;subject=Repost%20Report&amp;amp;message=Here%20%5bLINK%5d%20is%20an%20illegitimate%20repost,%20and%20here%20%5bLINK%5d%20is%20proof%20that%20the%20original%20woahdude%20post%20had%201500%2b%20upvotes."&gt;&lt;strong&gt;REPORT AN ILLEGITIMATE REPOST&lt;/strong&gt;&lt;/a&gt;&lt;/p&gt;
    
    &lt;h4&gt;WoahDude community&lt;/h4&gt;
    
    &lt;ul&gt;
    &lt;li&gt;&lt;a href="/r/WoahDude"&gt;/r/WoahDude&lt;/a&gt; - All media&lt;/li&gt;
    &lt;li&gt;&lt;a href="/r/WoahTube"&gt;/r/WoahTube&lt;/a&gt; - Videos only&lt;/li&gt;
    &lt;li&gt;&lt;a href="/r/WoahTunes"&gt;/r/WoahTunes&lt;/a&gt; - Music only&lt;/li&gt;
    &lt;li&gt;&lt;a href="/r/StonerPhilosophy"&gt;/r/StonerPhilosophy&lt;/a&gt; - Text posts only&lt;/li&gt;
    &lt;li&gt;&lt;a href="/r/WoahPoon"&gt;/r/WoahPoon&lt;/a&gt; - NSFW&lt;/li&gt;
    &lt;li&gt;&lt;strong&gt;&lt;a href="http://www.reddit.com/user/rWoahDude/m/woahdude"&gt;MULTIREDDIT&lt;/a&gt;&lt;/strong&gt;&lt;/li&gt;
    &lt;/ul&gt;
    
    &lt;h5&gt;&lt;a href="http://facebook.com/rWoahDude"&gt;&lt;/a&gt;&lt;/h5&gt;
    
    &lt;h5&gt;&lt;a href="http://twitter.com/rWoahDude"&gt;&lt;/a&gt;&lt;/h5&gt;
    
    &lt;h5&gt;&lt;a href="http://emilydavis.bandcamp.com/track/sagans-song"&gt;http://emilydavis.bandcamp.com/track/sagans-song&lt;/a&gt;&lt;/h5&gt;
    &lt;/div&gt;&lt;!-- SC_ON --&gt;
    */
    public var descriptionHtml = ""
    /**
    title of the main page
    example: The BEST links to click while you're STONED
    */
    public var  title = ""
    /**
    
    example: true
    */
    public var collapseDeletedComments = false
    /**
    whether the subreddit is marked as NSFW
    example: false
    */
    public var  over18 = false
    /**
    
    example: &lt;!-- SC_OFF --&gt;&lt;div class="md"&gt;&lt;p&gt;The best links to click while you&amp;#39;re stoned!&lt;/p&gt;
    
    &lt;p&gt;Trippy, mesmerizing, and mindfucking games, video, audio &amp;amp; images that make you go &amp;#39;woah dude!&amp;#39;&lt;/p&gt;
    
    &lt;p&gt;If you like to look at amazing stuff while smoking weed or doing other drugs, come inside for some Science, Philosophy, Mindfucks, Math, Engineering, Illusions and Cosmic weirdness.&lt;/p&gt;
    &lt;/div&gt;&lt;!-- SC_ON --&gt;
    */
    public var publicDescriptionHtml = ""
    /**
    
    example:
    */
    public var iconSize:[Int] = []
    /**
    
    example:
    */
    public var iconImg = ""
    /**
    description of header image shown on hover, or null
    example: Turn on the stylesheet and click Carl Sagan's head
    */
    public var headerTitle = ""
    /**
    sidebar text
    example: #####[Best of WoahDude 2014 ⇦](https://www.reddit.com/r/woahdude/comments/2qi1jh/best_of_rwoahdude_2014_results/?)
    
    [](#nyanbro)
    
    ####**What is WoahDude?**
    
    *The best links to click while you're stoned!*
    
    Trippy &amp; mesmerizing games, video, audio &amp; images that make you go 'woah dude!'
    
    No one wants to have to sift through the entire internet for fun links when they're stoned - so make this your one-stop shop!
    
    ⇨ [more in-depth explanation here](http://www.reddit.com/r/woahdude/wiki/index#wiki_what_is_.22woahdude_material.22.3F) ⇦
    
    ####**Filter WoahDude by flair**
    
    [picture](http://www.reddit.com/r/woahdude/search?q=flair:picture&amp;sort=top&amp;restrict_sr=on) - Static images
    
    [wallpaper](http://www.reddit.com/r/woahdude/search?q=flair:wallpaper+OR+[WALLPAPER]&amp;sort=top&amp;restrict_sr=on) - PC or Smartphone
    
    [gifv](http://www.reddit.com/r/woahdude/search?q=flair%3Agifv+OR+flair%3Awebm&amp;restrict_sr=on&amp;sort=top&amp;t=all) - Animated images
    
    [audio](http://www.reddit.com/r/woahdude/search?q=flair:audio&amp;sort=top&amp;restrict_sr=on) - Non-musical audio
    
    [music](http://www.reddit.com/r/woahdude/search?q=flair:music&amp;sort=top&amp;restrict_sr=on)  - Include: Band &amp; Song Title
    
    [music video](http://www.reddit.com/r/woahdude/search?q=flair:musicvideo&amp;sort=top&amp;restrict_sr=on) - If slideshow, tag [music]
    
    [video](http://www.reddit.com/r/woahdude/search?q=flair:video&amp;sort=top&amp;restrict_sr=on) - Non-musical video
    
    [movies](http://redd.it/29owi1#movies) - Movies
    
    [game](http://www.reddit.com/r/woahdude/search?q=flair:game&amp;restrict_sr=on&amp;sort=top&amp;t=all) - Goal oriented games
    
    [interactive](http://www.reddit.com/r/woahdude/search?q=flair%3Ainteractive+OR+sandbox&amp;sort=top&amp;restrict_sr=on&amp;t=all) - Interactive pages
    
    [mobile app](http://www.reddit.com/r/woahdude/comments/1jri9s/woahdude_featured_apps_get_free_download_codes/) - Mod-curated selection of apps
    
    [text](http://www.reddit.com/r/WoahDude/search?q=flair%3Atext&amp;restrict_sr=on&amp;sort=top&amp;t=all) - Articles, selfposts &amp; textpics
    
    [WOAHDUDE APPROVED](http://www.reddit.com/r/woahdude/search?q=flair%3Awoahdude%2Bapproved&amp;sort=new&amp;restrict_sr=on&amp;t=all) - Mod-curated selection of the best WoahDude submissions.
    
    ####RULES  [⇨ FULL VERSION](http://www.reddit.com/r/woahdude/wiki)
    
    &gt; 1. LINK FLAIR **is [mandatory](http://www.reddit.com/r/woahdude/wiki/index#wiki_flair_is_mandatory).**
    2. XPOST **labels are [banned](http://www.reddit.com/r/woahdude/wiki/index#wiki_.5Bxpost.5D_tags.2Flabels_are_banned). Crossposts are fine, just don't label them as such.**
    3.  NO **hostility!** PLEASE **giggle like a giraffe :)**
    
    Certain reposts are allowed. [Learn more](http://www.reddit.com/r/woahdude/wiki/index#wiki_reposts). Those not allowed may be reported via this form:
    
    [](http://www.reddit.com/message/compose?to=%2Fr%2Fwoahdude&amp;subject=Repost%20Report&amp;message=Here%20%5bLINK%5d%20is%20an%20illegitimate%20repost,%20and%20here%20%5bLINK%5d%20is%20proof%20that%20the%20original%20woahdude%20post%20had%201500%2b%20upvotes.#reportwarning) [**REPORT AN ILLEGITIMATE REPOST**](http://www.reddit.com/message/compose?to=%2Fr%2Fwoahdude&amp;subject=Repost%20Report&amp;message=Here%20%5bLINK%5d%20is%20an%20illegitimate%20repost,%20and%20here%20%5bLINK%5d%20is%20proof%20that%20the%20original%20woahdude%20post%20had%201500%2b%20upvotes.)
    
    ####WoahDude community
    
    * /r/WoahDude - All media
    * /r/WoahTube - Videos only
    * /r/WoahTunes - Music only
    * /r/StonerPhilosophy - Text posts only
    * /r/WoahPoon - NSFW
    * **[MULTIREDDIT](http://www.reddit.com/user/rWoahDude/m/woahdude)**
    
    #####[](http://facebook.com/rWoahDude)
    #####[](http://twitter.com/rWoahDude)
    
    #####http://emilydavis.bandcamp.com/track/sagans-song
    */
    public var  description = ""
    /**
    the subreddit's custom label for the submit link button, if any
    example: SUBMIT LINK
    */
    public var submitLinkLabel = ""
    /**
    number of users active in last 15 minutes
    example:
    */
    public var accountsActive = 0
    /**
    whether the subreddit's traffic page is publicly-accessible
    example: false
    */
    public var publicTraffic = false
    /**
    width and height of the header image, or null
    example: [145, 60]
    */
    public var headerSize:[Int] = []
    /**
    the number of redditors subscribed to this subreddit
    example: 778611
    */
    public var  subscribers = 0
    /**
    the subreddit's custom label for the submit text button, if any
    example: SUBMIT TEXT
    */
    public var submitTextLabel = ""
    /**
    whether the logged-in user is a moderator of the subreddit
    example: false
    */
    public var userIsModerator = false
    /**
    
    example: 1254666760
    */
    public var  created = 0
    /**
    The relative URL of the subreddit.  Ex: "/r/pics/"
    example: /r/woahdude/
    */
    public var  url = ""
    /**
    
    example: false
    */
    public var hideAds = false
    /**
    
    example: 1254663160
    */
    public var createdUtc = 0
    /**
    
    example:
    */
    public var bannerSize:[Int] = []
    /**
    whether the logged-in user is an approved submitter in the subreddit
    example: false
    */
    public var userIsContributor = false
    /**
    Description shown in subreddit search results?
    example: The best links to click while you're stoned!
    
    Trippy, mesmerizing, and mindfucking games, video, audio &amp; images that make you go 'woah dude!'
    
    If you like to look at amazing stuff while smoking weed or doing other drugs, come inside for some Science, Philosophy, Mindfucks, Math, Engineering, Illusions and Cosmic weirdness.
    
    
    */
    public var publicDescription = ""
    /**
    number of minutes the subreddit initially hides comment scores
    example: 0
    */
    public var commentScoreHideMins = 0
    /**
    the subreddit's type - one of "public", "private", "restricted", or in very special cases "gold_restricted" or "archived"
    example: public
    */
    public var subredditType = ""
    /**
    the type of submissions the subreddit allows - one of "any", "link" or "self"
    example: any
    */
    public var submissionType = ""
    /**
    whether the logged-in user is subscribed to the subreddit
    example: true
    */
    public var userIsSubscriber = false
    
    public override func toString() -> String {
        return "url=\(url)\ntitle=\(title)"
    }
    
    public var path:String {
        return "/r/\(displayName)"
    }
}


