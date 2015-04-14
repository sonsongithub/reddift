//
//  More.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-14 23:49:49 +0900
//

import UIKit

class More {
    /** 
    A list of String ids that are the additional things that can be downloaded but are not because there are too many to list.
    */
    let children:[AnyObject]
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
//      if let temp = json["children"] as?  {
//          self.children = temp
//      }
//      else {
//          self.children = 
//      }
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


