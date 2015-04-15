//
//  Comment.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-15 11:23:32 +0900
//

import UIKit

class Comment {
    /** 
    who approved this comment. null if nobody or you are not a mod
    */
    let approved_by:String
    /** 
    the account name of the poster
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
    who removed this comment. null if nobody or you are not a mod
    */
    let banned_by:String
    /** 
    the raw text.  this is the unformatted text which includes the raw markup characters such as ** for bold. &lt;, &gt;, and &amp; are escaped.
    */
    let body:String
    /** 
    the formatted HTML text as displayed on reddit. For example, text that is emphasised by * will now have &lt;em&gt; tags wrapping it. Additionally, bullets and numbered lists will now be in HTML list format. NOTE: The HTML string will be escaped. You must unescape to get the raw HTML.
    */
    let body_html:String
    /** 
    false if not edited, edit date in UTC epoch-seconds otherwise. NOTE: for some old edited comments on reddit.com, this will be set to true instead of edit date.
    */
//  let edited:[AnyObject]
    /** 
    the number of times this comment received reddit gold
    */
    let gilded:Int
    /** 
    how the logged-in user has voted on the comment - True = upvoted, False = downvoted, null = no vote
    */
    let likes:Bool
    /** 
    present if the comment is being displayed outside its thread (user pages, /r/subreddit/comments/.json, etc.). Contains the author of the parent link
    */
    let link_author:String
    /** 
    ID of the link this comment is in
    */
    let link_id:String
    /** 
    present if the comment is being displayed outside its thread (user pages, /r/subreddit/comments/.json, etc.). Contains the title of the parent link
    */
    let link_title:String
    /** 
    present if the comment is being displayed outside its thread (user pages, /r/subreddit/comments/.json, etc.). Contains the URL of the parent link
    */
    let link_url:String
    /** 
    how many times this comment has been reported, null if not a mod
    */
    let num_reports:Int
    /** 
    ID of the thing this comment is a reply to, either the link or a comment in it
    */
    let parent_id:String
    /** 
    A list of replies to this comment
    */
//  let replies:[AnyObject]
    /** 
    true if this post is saved by the logged in user
    */
    let saved:Bool
    /** 
    the net-score of the comment
    */
    let score:Int
    /** 
    Whether the comment's score is currently hidden.
    */
    let score_hidden:Bool
    /** 
    subreddit of thing excluding the /r/ prefix. "pics"
    */
    let subreddit:String
    /** 
    the id of the subreddit in which the thing is located
    */
    let subreddit_id:String
    /** 
    to allow determining whether they have been distinguished by moderators/admins. null = not distinguished. moderator = the green [M]. admin = the red [A]. special = various other special distinguishes http://redd.it/19ak1b
    */
    let distinguished:String
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
        if let temp = json["approved_by"] as? String {
            self.approved_by = temp
            updates++
        }
        else {
            self.approved_by = ""
        }
        properties++
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
        if let temp = json["banned_by"] as? String {
            self.banned_by = temp
            updates++
        }
        else {
            self.banned_by = ""
        }
        properties++
        if let temp = json["body"] as? String {
            self.body = temp
            updates++
        }
        else {
            self.body = ""
        }
        properties++
        if let temp = json["body_html"] as? String {
            self.body_html = temp
            updates++
        }
        else {
            self.body_html = ""
        }
        properties++
//      if let temp = json["edited"] as?  {
//          self.edited = temp
//      }
//      else {
//          self.edited = 
//      }
        if let temp = json["gilded"] as? Int {
            self.gilded = temp
            updates++
        }
        else {
            self.gilded = 0
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
        if let temp = json["link_author"] as? String {
            self.link_author = temp
            updates++
        }
        else {
            self.link_author = ""
        }
        properties++
        if let temp = json["link_id"] as? String {
            self.link_id = temp
            updates++
        }
        else {
            self.link_id = ""
        }
        properties++
        if let temp = json["link_title"] as? String {
            self.link_title = temp
            updates++
        }
        else {
            self.link_title = ""
        }
        properties++
        if let temp = json["link_url"] as? String {
            self.link_url = temp
            updates++
        }
        else {
            self.link_url = ""
        }
        properties++
        if let temp = json["num_reports"] as? Int {
            self.num_reports = temp
            updates++
        }
        else {
            self.num_reports = 0
        }
        properties++
        if let temp = json["parent_id"] as? String {
            self.parent_id = temp
            updates++
        }
        else {
            self.parent_id = ""
        }
        properties++
//      if let temp = json["replies"] as?  {
//          self.replies = temp
//      }
//      else {
//          self.replies = 
//      }
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
        if let temp = json["score_hidden"] as? Bool {
            self.score_hidden = temp
            updates++
        }
        else {
            self.score_hidden = false
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
        if let temp = json["distinguished"] as? String {
            self.distinguished = temp
            updates++
        }
        else {
            self.distinguished = ""
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
        return "approved_by=>\(approved_by) author=>\(author) author_flair_css_class=>\(author_flair_css_class) author_flair_text=>\(author_flair_text) banned_by=>\(banned_by) body=>\(body) body_html=>\(body_html) gilded=>\(gilded) likes=>\(likes) link_author=>\(link_author) link_id=>\(link_id) link_title=>\(link_title) link_url=>\(link_url) num_reports=>\(num_reports) parent_id=>\(parent_id) saved=>\(saved) score=>\(score) score_hidden=>\(score_hidden) subreddit=>\(subreddit) subreddit_id=>\(subreddit_id) distinguished=>\(distinguished) id=>\(id) name=>\(name) kind=>\(kind) created=>\(created) created_utc=>\(created_utc) ups=>\(ups) downs=>\(downs) "
    }
}


