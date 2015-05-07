//
//  Message.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-15 11:23:32 +0900
//

import Foundation

/**
The type of a message box.
*/
public enum MessageWhere {
    case Inbox
    case Unread
    case Sent
    
    public var  path:String {
        switch self{
        case .Inbox:
            return "/inbox"
        case .Unread:
            return "/unread"
        case .Sent:
            return "/sent"
        }
    }
    
    public var  description:String {
        switch self{
        case .Inbox:
            return "inbox"
        case .Unread:
            return "unread"
        case .Sent:
            return "sent"
        }
    }
}

/**
Message object.
*/
public class Message : Thing {
    /**
    the message itself
    example: Hello! [Hola!](http....
    */
    public var  body = ""
    /**
    
    example: false
    */
    public var wasComment = false
    /**
    
    example:
    */
    public var firstMessage = ""
    /**
    either null or the first message's fullname
    example:
    */
    public var firstMessageName = ""
    /**
    
    example: 1427126074
    */
    public var  created = 0
    /**
    
    example: sonson_twit
    */
    public var  dest = ""
    /**
    
    example: reddit
    */
    public var  author = ""
    /**
    
    example: 1427122474
    */
    public var createdUtc = 0
    /**
    the message itself with HTML formatting
    example: &lt;!-- SC_OFF --&gt;&l....
    */
    public var bodyHtml = ""
    /**
    null if not a comment.
    example:
    */
    public var  subreddit = ""
    /**
    null if no parent is attached
    example:
    */
    public var parentId = ""
    /**
    if the message is a comment, then the permalink to the comment with ?context=3 appended to the end, otherwise an empty string
    example:
    */
    public var  context = ""
    /**
    Again, an empty string if there are no replies.
    example:
    */
    public var  replies = ""
    /**
    unread?  not sure
    example: false
    */
    public var  new = false
    /**
    
    example: admin
    */
    public var  distinguished = ""
    /**
    subject of message
    example: Hello, /u/sonson_twit! Welcome to reddit!
    */
    public var  subject = ""
}


