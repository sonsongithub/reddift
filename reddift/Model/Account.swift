//
//  Account.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-14 23:49:49 +0900
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
    let data:[AnyObject]
    /** 
    the time of creation in local epoch-second format. ex: 1331042771.0
    */
    let created:Int
    /** 
    the time of creation in UTC epoch-second format. Note that neither of these ever have a non-zero fraction.
    */
    let created_utc:Int


    init(json:[String:AnyObject]) {
        if let temp = json["comment_karma"] as? Int {
            self.comment_karma = temp
        }
        else {
            self.comment_karma = 0
        }
        if let temp = json["has_mail"] as? Bool {
            self.has_mail = temp
        }
        else {
            self.has_mail = false
        }
        if let temp = json["has_mod_mail"] as? Bool {
            self.has_mod_mail = temp
        }
        else {
            self.has_mod_mail = false
        }
        if let temp = json["has_verified_email"] as? Bool {
            self.has_verified_email = temp
        }
        else {
            self.has_verified_email = false
        }
        if let temp = json["id"] as? String {
            self.id = temp
        }
        else {
            self.id = ""
        }
        if let temp = json["inbox_count"] as? Int {
            self.inbox_count = temp
        }
        else {
            self.inbox_count = 0
        }
        if let temp = json["is_friend"] as? Bool {
            self.is_friend = temp
        }
        else {
            self.is_friend = false
        }
        if let temp = json["is_gold"] as? Bool {
            self.is_gold = temp
        }
        else {
            self.is_gold = false
        }
        if let temp = json["is_mod"] as? Bool {
            self.is_mod = temp
        }
        else {
            self.is_mod = false
        }
        if let temp = json["link_karma"] as? Int {
            self.link_karma = temp
        }
        else {
            self.link_karma = 0
        }
        if let temp = json["modhash"] as? String {
            self.modhash = temp
        }
        else {
            self.modhash = ""
        }
        if let temp = json["name"] as? String {
            self.name = temp
        }
        else {
            self.name = ""
        }
        if let temp = json["over_18"] as? Bool {
            self.over_18 = temp
        }
        else {
            self.over_18 = false
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
        if let temp = json["created"] as? Int {
            self.created = temp
        }
        else {
            self.created = 0
        }
        if let temp = json["created_utc"] as? Int {
            self.created_utc = temp
        }
        else {
            self.created_utc = 0
        }
    }
}


