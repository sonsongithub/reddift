//
//  User.swift
//  reddift
//
//  Created by sonson on 2015/11/12.
//  Copyright © 2015年 sonson. All rights reserved.
//

import Foundation

/**
 */
public enum UserModPermission : String {
    case All     = "all"
    case Wiki    = "wiki"
    case Posts   = "posts"
    case Mail    = "mail"
    case Flair   = "flair"
    case Unknown = "unknown"
    
    public init(_ value:String) {
        switch(value) {
        case "all":
            self = .All
        case "wiki":
            self = .Wiki
        case "posts":
            self = .Posts
        case "mail":
            self = .Mail
        case "flair":
            self = .Flair
        default:
            self = .Unknown
        }
    }
}

/**
 User object
 */
public struct User {
    let date:NSTimeInterval
    let modPermissions:[UserModPermission]
    let name:String
    let id:String
    
    init(date:Double, permissions:[String], name:String, id:String) {
        self.date = date
        self.modPermissions = permissions.map({UserModPermission($0)})
        self.name = name
        self.id = id
    }
}