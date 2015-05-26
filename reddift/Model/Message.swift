//
//  Message.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-15 11:23:32 +0900
//

import Foundation

/**
Message object.
*/
public struct Message : Thing {
    /// identifier of Thing like 15bfi0.
    public var id = ""
    /// name of Thing, that is fullname, like t3_15bfi0.
    public var name = ""
    /// type of Thing, like t3.
    public static var kind = "t4"
    
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
    
    
    /**
    Parse t4 object.
    
    :param: data Dictionary, must be generated parsing "t4".
    :returns: Message object as Thing.
    */
    public init(data:JSONDictionary) {
        id = data["id"] as? String ?? ""
        body = data["body"] as? String ?? ""
        wasComment = data["was_comment"] as? Bool ?? false
        firstMessage = data["first_message"] as? String ?? ""
        name = data["name"] as? String ?? ""
        firstMessageName = data["first_message_name"] as? String ?? ""
        created = data["created"] as? Int ?? 0
        dest = data["dest"] as? String ?? ""
        author = data["author"] as? String ?? ""
        createdUtc = data["created_utc"] as? Int ?? 0
        bodyHtml = data["body_html"] as? String ?? ""
        subreddit = data["subreddit"] as? String ?? ""
        parentId = data["parent_id"] as? String ?? ""
        context = data["context"] as? String ?? ""
        replies = data["replies"] as? String ?? ""
        new = data["new"] as? Bool ?? false
        distinguished = data["distinguished"] as? String ?? ""
        subject = data["subject"] as? String ?? ""
    }
}


