//
//  Subreddit.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-15 11:23:32 +0900
//

import UIKit

class Subreddit {
    /** 
    number of users active in last 15 minutes
    */
    let accounts_active:Int
    /** 
    number of minutes the subreddit initially hides comment scores
    */
    let comment_score_hide_mins:Int
    /** 
    sidebar text
    */
    let description:String
    /** 
    sidebar text, escaped HTML format
    */
    let description_html:String
    /** 
    human name of the subreddit
    */
    let display_name:String
    /** 
    full URL to the header image, or null
    */
    let header_img:String
    /** 
    width and height of the header image, or null
    */
//  let header_size:[AnyObject]
    /** 
    description of header image shown on hover, or null
    */
    let header_title:String
    /** 
    whether the subreddit is marked as NSFW
    */
    let over18:Bool
    /** 
    Description shown in subreddit search results?
    */
    let public_description:String
    /** 
    whether the subreddit's traffic page is publicly-accessible
    */
    let public_traffic:Bool
    /** 
    the number of redditors subscribed to this subreddit
    */
    let subscribers:Int
    /** 
    the type of submissions the subreddit allows - one of "any", "link" or "self"
    */
    let submission_type:String
    /** 
    the subreddit's custom label for the submit link button, if any
    */
    let submit_link_label:String
    /** 
    the subreddit's custom label for the submit text button, if any
    */
    let submit_text_label:String
    /** 
    the subreddit's type - one of "public", "private", "restricted", or in very special cases "gold_restricted" or "archived"
    */
    let subreddit_type:String
    /** 
    title of the main page
    */
    let title:String
    /** 
    The relative URL of the subreddit.  Ex: "/r/pics/"
    */
    let url:String
    /** 
    whether the logged-in user is banned from the subreddit
    */
    let user_is_banned:Bool
    /** 
    whether the logged-in user is an approved submitter in the subreddit
    */
    let user_is_contributor:Bool
    /** 
    whether the logged-in user is a moderator of the subreddit
    */
    let user_is_moderator:Bool
    /** 
    whether the logged-in user is subscribed to the subreddit
    */
    let user_is_subscriber:Bool
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

    init(json:[String:AnyObject]) {
        var updates = 0
        var properties = 0
        if let temp = json["accounts_active"] as? Int {
            self.accounts_active = temp
            updates++
        }
        else {
            self.accounts_active = 0
        }
        properties++
        if let temp = json["comment_score_hide_mins"] as? Int {
            self.comment_score_hide_mins = temp
            updates++
        }
        else {
            self.comment_score_hide_mins = 0
        }
        properties++
        if let temp = json["description"] as? String {
            self.description = temp
            updates++
        }
        else {
            self.description = ""
        }
        properties++
        if let temp = json["description_html"] as? String {
            self.description_html = temp
            updates++
        }
        else {
            self.description_html = ""
        }
        properties++
        if let temp = json["display_name"] as? String {
            self.display_name = temp
            updates++
        }
        else {
            self.display_name = ""
        }
        properties++
        if let temp = json["header_img"] as? String {
            self.header_img = temp
            updates++
        }
        else {
            self.header_img = ""
        }
        properties++
//      if let temp = json["header_size"] as? [] {
//          self.header_size = temp
//      }
//      else {
//          self.header_size = []
//      }
        if let temp = json["header_title"] as? String {
            self.header_title = temp
            updates++
        }
        else {
            self.header_title = ""
        }
        properties++
        if let temp = json["over18"] as? Bool {
            self.over18 = temp
            updates++
        }
        else {
            self.over18 = false
        }
        properties++
        if let temp = json["public_description"] as? String {
            self.public_description = temp
            updates++
        }
        else {
            self.public_description = ""
        }
        properties++
        if let temp = json["public_traffic"] as? Bool {
            self.public_traffic = temp
            updates++
        }
        else {
            self.public_traffic = false
        }
        properties++
        if let temp = json["subscribers"] as? Int {
            self.subscribers = temp
            updates++
        }
        else {
            self.subscribers = 0
        }
        properties++
        if let temp = json["submission_type"] as? String {
            self.submission_type = temp
            updates++
        }
        else {
            self.submission_type = ""
        }
        properties++
        if let temp = json["submit_link_label"] as? String {
            self.submit_link_label = temp
            updates++
        }
        else {
            self.submit_link_label = ""
        }
        properties++
        if let temp = json["submit_text_label"] as? String {
            self.submit_text_label = temp
            updates++
        }
        else {
            self.submit_text_label = ""
        }
        properties++
        if let temp = json["subreddit_type"] as? String {
            self.subreddit_type = temp
            updates++
        }
        else {
            self.subreddit_type = ""
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
        if let temp = json["user_is_banned"] as? Bool {
            self.user_is_banned = temp
            updates++
        }
        else {
            self.user_is_banned = false
        }
        properties++
        if let temp = json["user_is_contributor"] as? Bool {
            self.user_is_contributor = temp
            updates++
        }
        else {
            self.user_is_contributor = false
        }
        properties++
        if let temp = json["user_is_moderator"] as? Bool {
            self.user_is_moderator = temp
            updates++
        }
        else {
            self.user_is_moderator = false
        }
        properties++
        if let temp = json["user_is_subscriber"] as? Bool {
            self.user_is_subscriber = temp
            updates++
        }
        else {
            self.user_is_subscriber = false
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
        println("update items = \(updates)/\(properties)")
    }

    func toString() -> String {
        return "accounts_active=>\(accounts_active) comment_score_hide_mins=>\(comment_score_hide_mins) description=>\(description) description_html=>\(description_html) display_name=>\(display_name) header_img=>\(header_img) header_title=>\(header_title) over18=>\(over18) public_description=>\(public_description) public_traffic=>\(public_traffic) subscribers=>\(subscribers) submission_type=>\(submission_type) submit_link_label=>\(submit_link_label) submit_text_label=>\(submit_text_label) subreddit_type=>\(subreddit_type) title=>\(title) url=>\(url) user_is_banned=>\(user_is_banned) user_is_contributor=>\(user_is_contributor) user_is_moderator=>\(user_is_moderator) user_is_subscriber=>\(user_is_subscriber) id=>\(id) name=>\(name) kind=>\(kind) "
    }
}


