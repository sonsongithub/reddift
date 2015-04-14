//
//  Subreddit.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-14 23:49:49 +0900
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
    let header_size:[]
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
    let data:[AnyObject]


    init(json:[String:AnyObject]) {
        if let temp = json["accounts_active"] as? Int {
            self.accounts_active = temp
        }
        else {
            self.accounts_active = 0
        }
        if let temp = json["comment_score_hide_mins"] as? Int {
            self.comment_score_hide_mins = temp
        }
        else {
            self.comment_score_hide_mins = 0
        }
        if let temp = json["description"] as? String {
            self.description = temp
        }
        else {
            self.description = ""
        }
        if let temp = json["description_html"] as? String {
            self.description_html = temp
        }
        else {
            self.description_html = ""
        }
        if let temp = json["display_name"] as? String {
            self.display_name = temp
        }
        else {
            self.display_name = ""
        }
        if let temp = json["header_img"] as? String {
            self.header_img = temp
        }
        else {
            self.header_img = ""
        }
        if let temp = json["header_size"] as? [] {
            self.header_size = temp
        }
        else {
            self.header_size = []
        }
        if let temp = json["header_title"] as? String {
            self.header_title = temp
        }
        else {
            self.header_title = ""
        }
        if let temp = json["over18"] as? Bool {
            self.over18 = temp
        }
        else {
            self.over18 = false
        }
        if let temp = json["public_description"] as? String {
            self.public_description = temp
        }
        else {
            self.public_description = ""
        }
        if let temp = json["public_traffic"] as? Bool {
            self.public_traffic = temp
        }
        else {
            self.public_traffic = false
        }
        if let temp = json["subscribers"] as? Int {
            self.subscribers = temp
        }
        else {
            self.subscribers = 0
        }
        if let temp = json["submission_type"] as? String {
            self.submission_type = temp
        }
        else {
            self.submission_type = ""
        }
        if let temp = json["submit_link_label"] as? String {
            self.submit_link_label = temp
        }
        else {
            self.submit_link_label = ""
        }
        if let temp = json["submit_text_label"] as? String {
            self.submit_text_label = temp
        }
        else {
            self.submit_text_label = ""
        }
        if let temp = json["subreddit_type"] as? String {
            self.subreddit_type = temp
        }
        else {
            self.subreddit_type = ""
        }
        if let temp = json["title"] as? String {
            self.title = temp
        }
        else {
            self.title = ""
        }
        if let temp = json["url"] as? String {
            self.url = temp
        }
        else {
            self.url = ""
        }
        if let temp = json["user_is_banned"] as? Bool {
            self.user_is_banned = temp
        }
        else {
            self.user_is_banned = false
        }
        if let temp = json["user_is_contributor"] as? Bool {
            self.user_is_contributor = temp
        }
        else {
            self.user_is_contributor = false
        }
        if let temp = json["user_is_moderator"] as? Bool {
            self.user_is_moderator = temp
        }
        else {
            self.user_is_moderator = false
        }
        if let temp = json["user_is_subscriber"] as? Bool {
            self.user_is_subscriber = temp
        }
        else {
            self.user_is_subscriber = false
        }
        if let temp = json["id"] as? String {
            self.id = temp
        }
        else {
            self.id = ""
        }
        if let temp = json["name"] as? String {
            self.name = temp
        }
        else {
            self.name = ""
        }
        if let temp = json["kind"] as? String {
            self.kind = temp
        }
        else {
            self.kind = ""
        }
//      if let temp = json["data"] as?  {
//          self.data = temp
//      }
//      else {
//          self.data = 
//      }
    }
}


