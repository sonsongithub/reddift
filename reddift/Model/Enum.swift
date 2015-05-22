//
//  Enum.swift
//  reddift
//
//  Created by sonson on 2015/05/12.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
The sort method for listing Comment object when using "/comments/[link_id]", "/api/morechildren".
*/
public enum CommentSort {
	case Confidence
	case Top
	case New
	case Hot
	case Controversial
	case Old
	case Random
	case Qa
	
	/**
	Returns string to create a path of URL.
	*/
	public var path:String {
		switch self{
		case .Confidence:
			return "/confidence"
		case .Top:
			return "/top"
		case .New:
			return "/new"
		case .Hot:
			return "/hot"
		case .Controversial:
			return "/controversial"
		case .Old:
			return "/old"
		case .Random:
			return "/random"
		case .Qa:
			return "/qa"
		}
	}
	
	/**
	Returns string to show titles.
	*/
	public var type:String {
		switch self{
		case .Confidence:
			return "confidence"
		case .Top:
			return "top"
		case .New:
			return "new"
		case .Hot:
			return "hot"
		case .Controversial:
			return "controversial"
		case .Old:
			return "old"
		case .Random:
			return "random"
		case .Qa:
			return "qa"
		}
	}
}

/**
The type of filtering content by timeline.
*/
public enum TimeFilterWithin {
	/// Contents within an hour
	case Hour
	/// Contents within a day
	case Day
	/// Contents within a week
	case Week
	/// Contents within a month
	case Month
	/// Contents within a year
	case Year
	/// All contents
	case All
	
	/// String for URL parameter
	public var param:String {
		switch self{
		case .Hour:
			return "hour"
		case .Day:
			return "day"
		case .Week:
			return "week"
		case .Month:
			return "month"
		case .Year:
			return "year"
		case .All:
			return "all"
		}
	}
}

/**
The sort method for listing Link object, reddift original.
*/
public enum LinkSortOriginalType {
    case Controversial
    case Top
    case Hot
    case New
    
    public var path:String {
        switch self{
        case .Controversial:
            return "/controversial"
        case .Top:
            return "/top"
        case .Hot:
            return "/hot"
        case .New:
            return "/new"
        }
    }
}

/**
The sort method for listing Link object, "/r/[subreddit]/[sort]" or "/[sort]".
*/
public enum LinkSortBy {
	case Controversial
	case Top
	
	public var path:String {
		switch self{
		case .Controversial:
			return "/controversial"
		case .Top:
			return "/hot"
		}
	}
}

/**
The sort method for search Link object, "/r/[subreddit]/search" or "/search".
*/
public enum SearchSortBy {
	case Relevance
	case New
	case Hot
	case Top
	case Comments
	
	var path:String {
		switch self{
		case .Relevance:
			return "relevance"
		case .New:
			return "new"
		case .Hot:
			return "hot"
		case .Top:
			return "top"
		case .Comments:
			return "comments"
		}
	}
}

/**
The sort method for listing user's subreddit object, "/subreddits/mine/[where]".
*/
public enum SubredditsMineWhere {
	case Contributor
	case Moderator
	case Subscriber
	
	public var path:String {
		switch self{
		case .Contributor:
			return "/subreddits/mine/contributor"
		case .Moderator:
			return "/subreddits/mine/moderator"
		case .Subscriber:
			return "/subreddits/mine/subscriber"
		}
	}
}

/**
The sort method for listing user's subreddit object, "/subreddits/[where]".
*/
public enum SubredditsWhere {
	case Popular
	case New
	case Employee
	case Gold
	
	public var path:String {
		switch self{
		case .Popular:
			return "/subreddits/popular"
		case .New:
			return "/subreddits/new"
		case .Employee:
			return "/subreddits/employee"
		case .Gold:
			return "/subreddits/gold"
		}
	}
	
	public var title:String {
		switch self{
		case .Popular:
			return "Popular"
		case .New:
			return "New"
		case .Employee:
			return "Employee"
		case .Gold:
			return "Gold"
		}
	}
}

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
The type of users' contents for "/user/username/where" method.
*/
public enum UserContent {
	case Overview
	case Submitted
	case Comments
	case Liked
	case Disliked
	case Hidden
	case Saved
	case Gilded
	
	var path:String {
		switch self{
		case .Overview:
			return "/overview"
		case .Submitted:
			return "/submitted"
		case .Comments:
			return "/comments"
		case .Liked:
			return "/liked"
		case .Disliked:
			return "/disliked"
		case .Hidden:
			return "/hidden"
		case .Saved:
			return "/saved"
		case .Gilded:
			return "/glided"
		}
	}
}

/**
The type of ordering users' contents for "/user/username/where" method.
*/
public enum UserContentSortBy {
	case Hot
	case New
	case Top
	case Controversial
	
	var param:String {
		switch self{
		case .Hot:
			return "hot"
		case .New:
			return "new"
		case .Top:
			return "top"
		case .Controversial:
			return "controversial"
		}
	}
}

/**
The type of voting direction.
*/
public enum VoteDirection : Int {
	case Up     =  1
	case No     =  0
	case Down   = -1
}