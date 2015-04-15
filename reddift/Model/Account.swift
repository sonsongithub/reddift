//
//  Account.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-15 11:23:32 +0900
//

import UIKit

class Account {
    /** 
    user's comment karma
    */
    let comment_karma:Int
    /** 
    user has unread mail? null if not your account
    */
    let has_mail:Bool
    /** 
    user has unread mod mail? null if not your account
    */
    let has_mod_mail:Bool
    /** 
    user has provided an email address and got it verified?
    */
    let has_verified_email:Bool
    /** 
    ID of the account; prepend t2_ to get fullname
    */
    let id:String
    /** 
    Number of unread messages in the inbox. Not present if not your account
    */
    let inbox_count:Int
    /** 
    whether the logged-in user has this user set as a friend
    */
    let is_friend:Bool
    /** 
    reddit gold status
    */
    let is_gold:Bool
    /** 
    whether this account moderates any subreddits
    */
    let is_mod:Bool
    /** 
    user's link karma
    */
    let link_karma:Int
    /** 
    current modhash. not present if not your account
    */
    let modhash:String
    /** 
    The username of the account in question.  This attribute overrides the superclass's name attribute.  Do not confuse an account's name which is the account's username with a thing's name which is the thing's FULLNAME.  See API: Glossary for details on what FULLNAMEs are.
    */
    let name:String
    /** 
    whether this account is set to be over 18
    */
    let over_18:Bool
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
        if let temp = json["comment_karma"] as? Int {
            self.comment_karma = temp
            updates++
        }
        else {
            self.comment_karma = 0
        }
        properties++
        if let temp = json["has_mail"] as? Bool {
            self.has_mail = temp
            updates++
        }
        else {
            self.has_mail = false
        }
        properties++
        if let temp = json["has_mod_mail"] as? Bool {
            self.has_mod_mail = temp
            updates++
        }
        else {
            self.has_mod_mail = false
        }
        properties++
        if let temp = json["has_verified_email"] as? Bool {
            self.has_verified_email = temp
            updates++
        }
        else {
            self.has_verified_email = false
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
        if let temp = json["inbox_count"] as? Int {
            self.inbox_count = temp
            updates++
        }
        else {
            self.inbox_count = 0
        }
        properties++
        if let temp = json["is_friend"] as? Bool {
            self.is_friend = temp
            updates++
        }
        else {
            self.is_friend = false
        }
        properties++
        if let temp = json["is_gold"] as? Bool {
            self.is_gold = temp
            updates++
        }
        else {
            self.is_gold = false
        }
        properties++
        if let temp = json["is_mod"] as? Bool {
            self.is_mod = temp
            updates++
        }
        else {
            self.is_mod = false
        }
        properties++
        if let temp = json["link_karma"] as? Int {
            self.link_karma = temp
            updates++
        }
        else {
            self.link_karma = 0
        }
        properties++
        if let temp = json["modhash"] as? String {
            self.modhash = temp
            updates++
        }
        else {
            self.modhash = ""
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
        if let temp = json["over_18"] as? Bool {
            self.over_18 = temp
            updates++
        }
        else {
            self.over_18 = false
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
        return "comment_karma=>\(comment_karma) has_mail=>\(has_mail) has_mod_mail=>\(has_mod_mail) has_verified_email=>\(has_verified_email) id=>\(id) inbox_count=>\(inbox_count) is_friend=>\(is_friend) is_gold=>\(is_gold) is_mod=>\(is_mod) link_karma=>\(link_karma) modhash=>\(modhash) name=>\(name) over_18=>\(over_18) kind=>\(kind) created=>\(created) created_utc=>\(created_utc) "
    }
}


