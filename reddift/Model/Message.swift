//
//  Message.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-15 11:23:32 +0900
//

import UIKit

class Message : Thing {
	/**
	the message itself
	example: Hello! [Hola!](http....
	*/
	var body = ""
	/**
	
	example: false
	*/
	var was_comment = false
	/**
	
	example:
	*/
	var first_message = ""
	/**
	either null or the first message's fullname
	example:
	*/
	var first_message_name = ""
	/**
	
	example: 1427126074
	*/
	var created = 0
	/**
	
	example: sonson_twit
	*/
	var dest = ""
	/**
	
	example: reddit
	*/
	var author = ""
	/**
	
	example: 1427122474
	*/
	var created_utc = 0
	/**
	the message itself with HTML formatting
	example: &lt;!-- SC_OFF --&gt;&l....
	*/
	var body_html = ""
	/**
	null if not a comment.
	example:
	*/
	var subreddit = ""
	/**
	null if no parent is attached
	example:
	*/
	var parent_id = ""
	/**
	if the message is a comment, then the permalink to the comment with ?context=3 appended to the end, otherwise an empty string
	example:
	*/
	var context = ""
	/**
	Again, an empty string if there are no replies.
	example:
	*/
	var replies = ""
	/**
	unread?  not sure
	example: false
	*/
	var new = false
	/**
	
	example: admin
	*/
	var distinguished = ""
	/**
	subject of message
	example: Hello, /u/sonson_twit! Welcome to reddit!
	*/
	var subject = ""
}


