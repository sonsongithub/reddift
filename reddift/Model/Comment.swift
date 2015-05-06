//
//  Comment.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-15 11:23:32 +0900
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
    
    public var path:String {
        get {
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
    }
    
    public var type:String {
        get {
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
}

/**
Expand child comments which are included in Comment objects, recursively.

:param: comment Comment object will be expanded.

:returns: Array contains Comment objects which are expaned from specified Comment object.
*/
public func extendAllReplies(comment:Comment) -> [Thing] {
    var comments:[Thing] = [comment]
    if let listing = comment.replies {
        for obj in listing.children {
            if let obj = obj as? Comment {
                comments.extend(extendAllReplies(obj))
            }
        }
        if let more = listing.more {
            comments.append(more)
        }
        comment.replies = nil
    }
    return comments
}

/**
Comment object.
*/
public class Comment : Thing {
    /**
    the id of the subreddit in which the thing is located
    example: t5_2qizd
    */
    public var subreddit_id = ""
    /**
    example:
    */
    public var banned_by = ""
    /**
    example: t3_32wnhw
    */
    public var link_id = ""
    /**
    how the logged-in user has voted on the link - True = upvoted, False = downvoted, null = no vote
    example:
    */
    public var likes = ""
    /**
    example: {"kind"=>"Listing", "data"=>{"modhash"=>nil, "children"=>[{"kind"=>"more", "data"=>{"count"=>0, "parent_id"=>"t1_cqfhkcb", "children"=>["cqfmmpp"], "name"=>"t1_cqfmmpp", "id"=>"cqfmmpp"}}], "after"=>nil, "before"=>nil}}
    */
    public var replies:Listing? = nil
    /**
    example: []
    */
    public var user_reports:[AnyObject] = []
    /**
    true if this post is saved by the logged in user
    example: false
    */
    public var saved = false
    /**
    example: 0
    */
    public var gilded = 0
    /**
    example: false
    */
    public var archived = false
    /**
    example:
    */
    public var report_reasons:[AnyObject] = []
    /**
    the account name of the poster. null if this is a promotional link
    example: Icnoyotl
    */
    public var author = ""
    /**
    example: t1_cqfh5kz
    */
    public var parent_id = ""
    /**
    the net-score of the link.  note: A submission's score is simply the number of upvotes minus the number of downvotes. If five users like the submission and three users don't it will have a score of 2. Please note that the vote numbers are not "real" numbers, they have been "fuzzed" to prevent spam bots etc. So taking the above example, if five users upvoted the submission, and three users downvote it, the upvote/downvote numbers may say 23 upvotes and 21 downvotes, or 12 upvotes, and 10 downvotes. The points score is correct, but the vote totals are "fuzzed".
    example: 1
    */
    public var score = 0
    /**
    example:
    */
    public var approved_by = ""
    /**
    example: 0
    */
    public var controversiality = 0
    /**
    example: The bot has been having this problem for awhile, there have been thousands of new comments since it last worked properly, so it seems like this must be something recurring? Could it have something to do with our AutoModerator?
    */
    public var body = ""
    /**
    example: false
    */
    public var edited = false
    /**
    the CSS class of the author's flair.  subreddit specific
    example:
    */
    public var author_flair_css_class = ""
    /**
    example: 0
    */
    public var downs = 0
    /**
    example: &lt;div class="md"&gt;&lt;p&gt;The bot has been having this problem for awhile, there have been thousands of new comments since it last worked properly, so it seems like this must be something recurring? Could it have something to do with our AutoModerator?&lt;/p&gt;
    &lt;/div&gt;
    */
    public var body_html = ""
    /**
    subreddit of thing excluding the /r/ prefix. "pics"
    example: redditdev
    */
    public var subreddit = ""
    /**
    example: false
    */
    public var score_hidden = false
    /**
    example: 1429284845
    */
    public var created = 0
    /**
    the text of the author's flair.  subreddit specific
    example:
    */
    public var author_flair_text = ""
    /**
    example: 1429281245
    */
    public var created_utc = 0
    /**
    example:
    */
    public var distinguished = false
    /**
    example: []
    */
    public var mod_reports:[AnyObject] = []
    /**
    example:
    */
    public var num_reports = 0
    /**
    example: 1
    */
    public var ups = 0
}


