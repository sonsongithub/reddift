//
//  Link.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-15 11:23:32 +0900
//

import UIKit

class Link {
    /** 
    the account name of the poster. null if this is a promotional link
    */
    let author:String
    /** 
    the CSS class of the author's flair.  subreddit specific
    */
    let author_flair_css_class:String
    /** 
    the text of the author's flair.  subreddit specific
    */
    let author_flair_text:String
    /** 
    probably always returns false
    */
    let clicked:Bool
    /** 
    the domain of this link.  Self posts will be self.reddit.com while other examples include en.wikipedia.org and s3.amazon.com
    */
    let domain:String
    /** 
    true if the post is hidden by the logged in user.  false if not logged in or not hidden.
    */
    let hidden:Bool
    /** 
    true if this link is a selfpost
    */
    let is_self:Bool
    /** 
    how the logged-in user has voted on the link - True = upvoted, False = downvoted, null = no vote
    */
    let likes:Bool
    /** 
    the CSS class of the link's flair.
    */
    let link_flair_css_class:String
    /** 
    the text of the link's flair.
    */
    let link_flair_text:String
    /** 
    Used for streaming video. Detailed information about the video and it's origins are placed here
    */
//  let media:[AnyObject]
    /** 
    Used for streaming video. Technical embed specific information is found here.
    */
//  let media_embed:[AnyObject]
    /** 
    the number of comments that belong to this link. includes removed comments.
    */
    let num_comments:Int
    /** 
    true if the post is tagged as NSFW.  False if otherwise
    */
    let over_18:Bool
    /** 
    relative URL of the permanent link for this link
    */
    let permalink:String
    /** 
    true if this post is saved by the logged in user
    */
    let saved:Bool
    /** 
    the net-score of the link.  note: A submission's score is simply the number of upvotes minus the number of downvotes. If five users like the submission and three users don't it will have a score of 2. Please note that the vote numbers are not "real" numbers, they have been "fuzzed" to prevent spam bots etc. So taking the above example, if five users upvoted the submission, and three users downvote it, the upvote/downvote numbers may say 23 upvotes and 21 downvotes, or 12 upvotes, and 10 downvotes. The points score is correct, but the vote totals are "fuzzed".
    */
    let score:Int
    /** 
    the raw text.  this is the unformatted text which includes the raw markup characters such as ** for bold. &lt;, &gt;, and &amp; are escaped. Empty if not present.
    */
    let selftext:String
    /** 
    the formatted escaped HTML text.  this is the HTML formatted version of the marked up text.  Items that are boldened by ** or *** will now have &lt;em&gt; or *** tags on them. Additionally, bullets and numbered lists will now be in HTML list format. NOTE: The HTML string will be escaped.  You must unescape to get the raw HTML. Null if not present.
    */
    let selftext_html:String
    /** 
    subreddit of thing excluding the /r/ prefix. "pics"
    */
    let subreddit:String
    /** 
    the id of the subreddit in which the thing is located
    */
    let subreddit_id:String
    /** 
    full URL to the thumbnail for this link; "self" if this is a self post; "default" if a thumbnail is not available
    */
    let thumbnail:String
    /** 
    the title of the link. may contain newlines for some reason
    */
    let title:String
    /** 
    the link of this post.  the permalink if this is a self-post
    */
    let url:String
    /** 
    Indicates if link has been edited. Will be the edit timestamp if the link has been edited and return false otherwise. https://github.com/reddit/reddit/issues/581
    */
    let edited:Int
    /** 
    to allow determining whether they have been distinguished by moderators/admins. null = not distinguished. moderator = the green [M]. admin = the red [A]. special = various other special distinguishes http://bit.ly/ZYI47B
    */
    let distinguished:String
    /** 
    true if the post is set as the sticky in its subreddit.
    */
    let stickied:Bool
    /** 
    this item's identifier, e.g. "8xwlg"
    */
    let id:String
    /** 
    Fullname of comment, e.g. "t1_c3v7f8u"
    */
    let name:String
    /** 
    All things have a kind.  The kind is a String identifier that denotes the object's type.  Some examples: Listing, more, t1, t2
    */
    let kind:String
    /** 
    A custom data structure used to hold valuable information.  This object's format will follow the data structure respective of its kind.  See below for specific structures.
    */
//  let data:[AnyObject]
    /** 
    the time of creation in local epoch-second format. ex: 1331042771.0
    */
    let created:Int
    /** 
    the time of creation in UTC epoch-second format. Note that neither of these ever have a non-zero fraction.
    */
    let created_utc:Int
    /** 
    the number of upvotes. (includes own)
    */
    let ups:Int
    /** 
    the number of downvotes. (includes own)
    */
    let downs:Int

    init(json:[String:AnyObject]) {
        var updates = 0
        var properties = 0
        if let temp = json["author"] as? String {
            self.author = temp
            updates++
        }
        else {
            self.author = ""
        }
        properties++
        if let temp = json["author_flair_css_class"] as? String {
            self.author_flair_css_class = temp
            updates++
        }
        else {
            self.author_flair_css_class = ""
        }
        properties++
        if let temp = json["author_flair_text"] as? String {
            self.author_flair_text = temp
            updates++
        }
        else {
            self.author_flair_text = ""
        }
        properties++
        if let temp = json["clicked"] as? Bool {
            self.clicked = temp
            updates++
        }
        else {
            self.clicked = false
        }
        properties++
        if let temp = json["domain"] as? String {
            self.domain = temp
            updates++
        }
        else {
            self.domain = ""
        }
        properties++
        if let temp = json["hidden"] as? Bool {
            self.hidden = temp
            updates++
        }
        else {
            self.hidden = false
        }
        properties++
        if let temp = json["is_self"] as? Bool {
            self.is_self = temp
            updates++
        }
        else {
            self.is_self = false
        }
        properties++
        if let temp = json["likes"] as? Bool {
            self.likes = temp
            updates++
        }
        else {
            self.likes = false
        }
        properties++
        if let temp = json["link_flair_css_class"] as? String {
            self.link_flair_css_class = temp
            updates++
        }
        else {
            self.link_flair_css_class = ""
        }
        properties++
        if let temp = json["link_flair_text"] as? String {
            self.link_flair_text = temp
            updates++
        }
        else {
            self.link_flair_text = ""
        }
        properties++
//      if let temp = json["media"] as?  {
//          self.media = temp
//      }
//      else {
//          self.media = 
//      }
//      if let temp = json["media_embed"] as?  {
//          self.media_embed = temp
//      }
//      else {
//          self.media_embed = 
//      }
        if let temp = json["num_comments"] as? Int {
            self.num_comments = temp
            updates++
        }
        else {
            self.num_comments = 0
        }
        properties++
        if let temp = json["over_18"] as? Bool {
            self.over_18 = temp
            updates++
        }
        else {
            self.over_18 = false
        }
        properties++
        if let temp = json["permalink"] as? String {
            self.permalink = temp
            updates++
        }
        else {
            self.permalink = ""
        }
        properties++
        if let temp = json["saved"] as? Bool {
            self.saved = temp
            updates++
        }
        else {
            self.saved = false
        }
        properties++
        if let temp = json["score"] as? Int {
            self.score = temp
            updates++
        }
        else {
            self.score = 0
        }
        properties++
        if let temp = json["selftext"] as? String {
            self.selftext = temp
            updates++
        }
        else {
            self.selftext = ""
        }
        properties++
        if let temp = json["selftext_html"] as? String {
            self.selftext_html = temp
            updates++
        }
        else {
            self.selftext_html = ""
        }
        properties++
        if let temp = json["subreddit"] as? String {
            self.subreddit = temp
            updates++
        }
        else {
            self.subreddit = ""
        }
        properties++
        if let temp = json["subreddit_id"] as? String {
            self.subreddit_id = temp
            updates++
        }
        else {
            self.subreddit_id = ""
        }
        properties++
        if let temp = json["thumbnail"] as? String {
            self.thumbnail = temp
            updates++
        }
        else {
            self.thumbnail = ""
        }
        properties++
        if let temp = json["title"] as? String {
            self.title = temp
            updates++
        }
        else {
            self.title = ""
        }
        properties++
        if let temp = json["url"] as? String {
            self.url = temp
            updates++
        }
        else {
            self.url = ""
        }
        properties++
        if let temp = json["edited"] as? Int {
            self.edited = temp
            updates++
        }
        else {
            self.edited = 0
        }
        properties++
        if let temp = json["distinguished"] as? String {
            self.distinguished = temp
            updates++
        }
        else {
            self.distinguished = ""
        }
        properties++
        if let temp = json["stickied"] as? Bool {
            self.stickied = temp
            updates++
        }
        else {
            self.stickied = false
        }
        properties++
        if let temp = json["id"] as? String {
            self.id = temp
            updates++
        }
        else {
            self.id = ""
        }
        properties++
        if let temp = json["name"] as? String {
            self.name = temp
            updates++
        }
        else {
            self.name = ""
        }
        properties++
        if let temp = json["kind"] as? String {
            self.kind = temp
            updates++
        }
        else {
            self.kind = ""
        }
        properties++
//      if let temp = json["data"] as?  {
//          self.data = temp
//      }
//      else {
//          self.data = 
//      }
        if let temp = json["created"] as? Int {
            self.created = temp
            updates++
        }
        else {
            self.created = 0
        }
        properties++
        if let temp = json["created_utc"] as? Int {
            self.created_utc = temp
            updates++
        }
        else {
            self.created_utc = 0
        }
        properties++
        if let temp = json["ups"] as? Int {
            self.ups = temp
            updates++
        }
        else {
            self.ups = 0
        }
        properties++
        if let temp = json["downs"] as? Int {
            self.downs = temp
            updates++
        }
        else {
            self.downs = 0
        }
        properties++
        println("update items = \(updates)/\(properties)")
    }

    func toString() -> String {
        return "author=>\(author) author_flair_css_class=>\(author_flair_css_class) author_flair_text=>\(author_flair_text) clicked=>\(clicked) domain=>\(domain) hidden=>\(hidden) is_self=>\(is_self) likes=>\(likes) link_flair_css_class=>\(link_flair_css_class) link_flair_text=>\(link_flair_text) num_comments=>\(num_comments) over_18=>\(over_18) permalink=>\(permalink) saved=>\(saved) score=>\(score) selftext=>\(selftext) selftext_html=>\(selftext_html) subreddit=>\(subreddit) subreddit_id=>\(subreddit_id) thumbnail=>\(thumbnail) title=>\(title) url=>\(url) edited=>\(edited) distinguished=>\(distinguished) stickied=>\(stickied) id=>\(id) name=>\(name) kind=>\(kind) created=>\(created) created_utc=>\(created_utc) ups=>\(ups) downs=>\(downs) "
    }
}


