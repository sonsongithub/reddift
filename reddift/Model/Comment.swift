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
    public var subredditId = ""
    /**
    example:
    */
    public var bannedBy = ""
    /**
    example: t3_32wnhw
    */
    public var linkId = ""
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
    public var userReports:[AnyObject] = []
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
    public var reportReasons:[AnyObject] = []
    /**
    the account name of the poster. null if this is a promotional link
    example: Icnoyotl
    */
    public var author = ""
    /**
    example: t1_cqfh5kz
    */
    public var parentId = ""
    /**
    the net-score of the link.  note: A submission's score is simply the number of upvotes minus the number of downvotes. If five users like the submission and three users don't it will have a score of 2. Please note that the vote numbers are not "real" numbers, they have been "fuzzed" to prevent spam bots etc. So taking the above example, if five users upvoted the submission, and three users downvote it, the upvote/downvote numbers may say 23 upvotes and 21 downvotes, or 12 upvotes, and 10 downvotes. The points score is correct, but the vote totals are "fuzzed".
    example: 1
    */
    public var score = 0
    /**
    example:
    */
    public var approvedBy = ""
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
    public var authorFlairCssClass = ""
    /**
    example: 0
    */
    public var downs = 0
    /**
    example: &lt;div class="md"&gt;&lt;p&gt;The bot has been having this problem for awhile, there have been thousands of new comments since it last worked properly, so it seems like this must be something recurring? Could it have something to do with our AutoModerator?&lt;/p&gt;
    &lt;/div&gt;
    */
    public var bodyHtml = ""
    /**
    subreddit of thing excluding the /r/ prefix. "pics"
    example: redditdev
    */
    public var subreddit = ""
    /**
    example: false
    */
    public var scoreHidden = false
    /**
    example: 1429284845
    */
    public var created = 0
    /**
    the text of the author's flair.  subreddit specific
    example:
    */
    public var authorFlairText = ""
    /**
    example: 1429281245
    */
    public var createdUtc = 0
    /**
    example:
    */
    public var distinguished = false
    /**
    example: []
    */
    public var modReports:[AnyObject] = []
    /**
    example:
    */
    public var numReports = 0
    /**
    example: 1
    */
    public var ups = 0
    
    /**
    Parse t1 Thing.
    
    :param: data Dictionary, must be generated parsing t1 Thing.
    :returns: Comment object as Thing.
    */
    public init(data:[String:AnyObject]) {
        super.init(id: data["id"] as? String ?? "", kind: "t1")
        
        subredditId = data["subreddit_id"] as? String ?? ""
        bannedBy = data["banned_by"] as? String ?? ""
        linkId = data["link_id"] as? String ?? ""
        likes = data["likes"] as? String ?? ""
        saved = data["saved"] as? Bool ?? false
        id = data["id"] as? String ?? ""
        gilded = data["gilded"] as? Int ?? 0
        archived = data["archived"] as? Bool ?? false
        author = data["author"] as? String ?? ""
        parentId = data["parent_id"] as? String ?? ""
        score = data["score"] as? Int ?? 0
        approvedBy = data["approved_by"] as? String ?? ""
        controversiality = data["controversiality"] as? Int ?? 0
        body = data["body"] as? String ?? ""
        edited = data["edited"] as? Bool ?? false
        authorFlairCssClass = data["author_flair_css_class"] as? String ?? ""
        downs = data["downs"] as? Int ?? 0
        bodyHtml = data["body_html"] as? String ?? ""
        subreddit = data["subreddit"] as? String ?? ""
        scoreHidden = data["score_hidden"] as? Bool ?? false
        name = data["name"] as? String ?? ""
        created = data["created"] as? Int ?? 0
        authorFlairText = data["author_flair_text"] as? String ?? ""
        createdUtc = data["created_utc"] as? Int ?? 0
        distinguished = data["distinguished"] as? Bool ?? false
        numReports = data["num_reports"] as? Int ?? 0
        ups = data["ups"] as? Int ?? 0
        if let temp = data["replies"] as? [String:AnyObject] {
            if let obj = Parser.parseJSON(temp) as? Listing {
                replies = obj
            }
        }
    }
}


