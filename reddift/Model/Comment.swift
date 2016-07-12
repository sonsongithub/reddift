//
//  Comment.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-15 11:23:32 +0900
//

import Foundation

/**
Expand child comments which are included in Comment objects, recursively.
- parameter comment: Comment object will be expanded.
- returns: Array contains Comment objects which are expaned from specified Comment object.
*/
public func extendAllReplies(comment:Thing) -> [Thing] {
    var comments:[Thing] = [comment]
    if let comment = comment as? Comment {
        for obj in comment.replies.children {
            comments.append(contentsOf: extendAllReplies(comment: obj))
        }
    }
    return comments
}

/**
Comment object.
*/
public struct Comment : Thing {
    /// identifier of Thing like 15bfi0.
    public let id:String
    /// name of Thing, that is fullname, like t3_15bfi0.
    public let name:String
    /// type of Thing, like t3.
    static public let kind = "t1"
    
    /**
    the id of the subreddit in which the thing is located
    example: t5_2qizd
    */
    public let subredditId:String
    /**
    example:
    */
    public let bannedBy:String
    /**
    example: t3_32wnhw
    */
    public let linkId:String
    /**
    how the logged-in user has voted on the link - True = upvoted, False = downvoted, null = no vote
    example:
    */
    public var likes:VoteDirection
    /**
    example: {"kind"=>"Listing", "data"=>{"modhash"=>nil, "children"=>[{"kind"=>"more", "data"=>{"count"=>0, "parent_id"=>"t1_cqfhkcb", "children"=>["cqfmmpp"], "name"=>"t1_cqfmmpp", "id"=>"cqfmmpp"}}], "after"=>nil, "before"=>nil}}
    */
    public let replies:Listing
    /**
    example: []
    */
    public let userReports:[AnyObject]
    /**
    true if this post is saved by the logged in user
    example: false
    */
    public var saved:Bool
    /**
    example: 0
    */
    public let gilded:Int
    /**
    example: false
    */
    public let archived:Bool
    /**
    example:
    */
    public let reportReasons:[AnyObject]
    /**
    the account name of the poster. null if this is a promotional link
    example: Icnoyotl
    */
    public let author:String
    /**
    example: t1_cqfh5kz
    */
    public let parentId:String
    /**
    the net-score of the link.  note: A submission's score is simply the number of upvotes minus the number of downvotes. If five users like the submission and three users don't it will have a score of 2. Please note that the vote numbers are not "real" numbers, they have been "fuzzed" to prevent spam bots etc. So taking the above example, if five users upvoted the submission, and three users downvote it, the upvote/downvote numbers may say 23 upvotes and 21 downvotes, or 12 upvotes, and 10 downvotes. The points score is correct, but the vote totals are "fuzzed".
    example: 1
    */
    public var score:Int
    /**
    example:
    */
    public let approvedBy:String
    /**
    example: 0
    */
    public let controversiality:Int
    /**
    example: The bot has been having this problem for awhile, there have been thousands of new comments since it last worked properly, so it seems like this must be something recurring? Could it have something to do with our AutoModerator?
    */
    public let body:String
    /**
    example: false
    */
    public var edited:Bool
    /**
    the CSS class of the author's flair.  subreddit specific
    example:
    */
    public let authorFlairCssClass:String
    /**
    example: 0
    */
    public var downs:Int
    /**
    example: &lt;div class="md"&gt;&lt;p&gt;The bot has been having this problem for awhile, there have been thousands of new comments since it last worked properly, so it seems like this must be something recurring? Could it have something to do with our AutoModerator?&lt;/p&gt;
    &lt;/div&gt;
    */
    public let bodyHtml:String
    /**
    subreddit of thing excluding the /r/ prefix. "pics"
    example: redditdev
    */
    public let subreddit:String
    /**
    example: false
    */
    public let scoreHidden:Bool
    /**
    example: 1429284845
    */
    public let created:Int
    /**
    the text of the author's flair.  subreddit specific
    example:
    */
    public let authorFlairText:String
    /**
    example: 1429281245
    */
    public let createdUtc:Int
    /**
    example:
    */
    public let distinguished:Bool
    /**
    example: []
    */
    public let modReports:[AnyObject]
    /**
    example:
    */
    public let numReports:Int
    /**
    example: 1
    */
    public var ups:Int
	/**
	if the message is a comment, then the permalink to the comment with ?context=3 appended to the end, otherwise an empty string
	example:
	*/
	public let  context:String

	
    public init(id:String) {
        self.id = id
        self.name = "\(Comment.kind)_\(self.id)"
        
        subredditId = ""
        bannedBy = ""
        linkId = ""
        likes = .None
        replies = Listing()
        userReports = []
        saved = false
        gilded = 0
        archived = false
        reportReasons = []
        author = ""
        parentId = ""
        score = 0
        approvedBy = ""
        controversiality = 0
        body = ""
        edited = false
        authorFlairCssClass = ""
        downs = 0
        bodyHtml = ""
        subreddit = ""
        scoreHidden = false
        created = 0
        authorFlairText = ""
        createdUtc = 0
        distinguished = false
        modReports = []
        numReports = 0
        ups = 0
		context = ""
    }
    
    /**
    Parse t1 Thing.
    
    - parameter data: Dictionary, must be generated parsing t1 Thing.
    - returns: Comment object as Thing.
    */
    public init(data:JSONDictionary) {
        id = data["id"] as? String ?? ""
        subredditId = data["subreddit_id"] as? String ?? ""
        bannedBy = data["banned_by"] as? String ?? ""
        linkId = data["link_id"] as? String ?? ""
        if let temp = data["likes"] as? Bool {
            likes = temp ? .Up : .Down
        }
        else {
            likes = .None
        }
        userReports = []
        saved = data["saved"] as? Bool ?? false
        gilded = data["gilded"] as? Int ?? 0
        archived = data["archived"] as? Bool ?? false
        reportReasons = []
        author = data["author"] as? String ?? ""
        parentId = data["parent_id"] as? String ?? ""
        score = data["score"] as? Int ?? 0
        approvedBy = data["approved_by"] as? String ?? ""
        controversiality = data["controversiality"] as? Int ?? 0
        body = data["body"] as? String ?? ""
        edited = data["edited"] as? Bool ?? false
        authorFlairCssClass = data["author_flair_css_class"] as? String ?? ""
        downs = data["downs"] as? Int ?? 0
        let tempBodyHtml = data["body_html"] as? String ?? ""
        bodyHtml = tempBodyHtml.gtm_stringByUnescapingFromHTML()
        subreddit = data["subreddit"] as? String ?? ""
        scoreHidden = data["score_hidden"] as? Bool ?? false
        name = data["name"] as? String ?? ""
        created = data["created"] as? Int ?? 0
        authorFlairText = data["author_flair_text"] as? String ?? ""
        createdUtc = data["created_utc"] as? Int ?? 0
        distinguished = data["distinguished"] as? Bool ?? false
        modReports = []
        numReports = data["num_reports"] as? Int ?? 0
        ups = data["ups"] as? Int ?? 0
		 context = data["context"] as? String ?? ""
		if let temp = data["replies"] as? JSONDictionary {
            if let obj = Parser.parseJSON(json: temp) as? Listing {
                replies = obj
            }
            else {
                replies = Listing()
            }
        }
        else {
            replies = Listing()
        }
    }
}


