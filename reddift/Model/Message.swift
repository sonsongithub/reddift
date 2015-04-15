//
//  Message.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-15 11:23:32 +0900
//

import UIKit

class Message {
    /** 
    the message itself
    */
    let body:String
    /** 
    the message itself with HTML formatting
    */
    let body_html:String
    /** 
    if the message is a comment, then the permalink to the comment with ?context=3 appended to the end, otherwise an empty string
    */
    let context:String
    /** 
    either null or the first message's ID represented as base 10 (wtf)
    */
//  let first_message:[AnyObject]
    /** 
    either null or the first message's fullname
    */
    let first_message_name:String
    /** 
    how the logged-in user has voted on the message - True = upvoted, False = downvoted, null = no vote
    */
    let likes:Bool
    /** 
    if the message is actually a comment, contains the title of the thread it was posted in
    */
    let link_title:String
    /** 
    ex: "t4_8xwlg"
    */
    let name:String
    /** 
    unread?  not sure
    */
    let new:Bool
    /** 
    null if no parent is attached
    */
    let parent_id:String
    /** 
    Again, an empty string if there are no replies.
    */
    let replies:String
    /** 
    subject of message
    */
    let subject:String
    /** 
    null if not a comment.
    */
    let subreddit:String
    /** 
    this item's identifier, e.g. "8xwlg"
    */
    let id:String
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

    init(json:[String:AnyObject]) {
        var updates = 0
        var properties = 0
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
        if let temp = json["context"] as? String {
            self.context = temp
            updates++
        }
        else {
            self.context = ""
        }
        properties++
//      if let temp = json["first_message"] as?  {
//          self.first_message = temp
//      }
//      else {
//          self.first_message = 
//      }
        if let temp = json["first_message_name"] as? String {
            self.first_message_name = temp
            updates++
        }
        else {
            self.first_message_name = ""
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
        if let temp = json["link_title"] as? String {
            self.link_title = temp
            updates++
        }
        else {
            self.link_title = ""
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
        if let temp = json["new"] as? Bool {
            self.new = temp
            updates++
        }
        else {
            self.new = false
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
        if let temp = json["replies"] as? String {
            self.replies = temp
            updates++
        }
        else {
            self.replies = ""
        }
        properties++
        if let temp = json["subject"] as? String {
            self.subject = temp
            updates++
        }
        else {
            self.subject = ""
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
        if let temp = json["id"] as? String {
            self.id = temp
            updates++
        }
        else {
            self.id = ""
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
        println("update items = \(updates)/\(properties)")
    }

    func toString() -> String {
        return "body=>\(body) body_html=>\(body_html) context=>\(context) first_message_name=>\(first_message_name) likes=>\(likes) link_title=>\(link_title) name=>\(name) new=>\(new) parent_id=>\(parent_id) replies=>\(replies) subject=>\(subject) subreddit=>\(subreddit) id=>\(id) kind=>\(kind) created=>\(created) created_utc=>\(created_utc) "
    }
}


