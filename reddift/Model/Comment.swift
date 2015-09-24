//
//  Comment.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-15 11:23:32 +0900
//

import Foundation

private let regex = try! NSRegularExpression(pattern: "(\\n{0,1}\\s*\\*\\s)|(~~([^\\s]+?)~~)|(\\*\\*([^\\s^\\*]+?)\\*\\*)|(\\*([^\\s^\\*]+?)\\*)|(\\[(.+)\\]\\(([%!$&'()*+,-./0123456789:;=?@ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~]+)\\))|(\\^([^\\s\\^]+))|(https{0,1}://[%!$&'()*+,-./0123456789:;=?@ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~]+)", options: NSRegularExpressionOptions.CaseInsensitive)

private enum Attribute {
    case Link(String, Int, Int)
    case Bold(Int, Int)
    case Italic(Int, Int)
    case Superscript(Int, Int)
    case Strike(Int, Int)
}

extension String {
    func simpleRedditMarkdownParse() -> String {
        let casted = self as NSString
        let copied:NSMutableString = (self as NSString).mutableCopy() as! NSMutableString
        
        
        let results = regex.matchesInString(self, options: NSMatchingOptions(), range:NSMakeRange(0, casted.length))
        
        var buf = ""
        var pointer = 0
        
        var attrs = [Attribute]()
        
        results.forEach { (result) -> () in
            if result.rangeAtIndex(1).length > 0 {
                if result.rangeAtIndex(1).location - pointer > 0 {
                    let r0 = NSMakeRange(pointer, result.rangeAtIndex(1).location - pointer)
                    buf.appendContentsOf(copied.substringWithRange(r0))
                }
                buf.appendContentsOf("\n・")
                pointer = (result.rangeAtIndex(1).location + result.rangeAtIndex(1).length)
            }
            if result.rangeAtIndex(2).length > 0 {
                if result.rangeAtIndex(2).location - pointer > 0 {
                    let r0 = NSMakeRange(pointer, result.rangeAtIndex(2).location - pointer)
                    buf.appendContentsOf(copied.substringWithRange(r0))
                }
                // ~~ ~~
                let r2 = NSMakeRange(result.rangeAtIndex(3).location, result.rangeAtIndex(3).length)
                let sub = copied.substringWithRange(r2)
                buf.appendContentsOf(sub)
                
                attrs.append(Attribute.Strike(buf.characters.count - sub.characters.count, sub.characters.count))
                
                pointer = (result.rangeAtIndex(2).location + result.rangeAtIndex(2).length)
            }
            if result.rangeAtIndex(4).length > 0 {
                if result.rangeAtIndex(4).location - pointer > 0 {
                    let r0 = NSMakeRange(pointer, result.rangeAtIndex(4).location - pointer)
                    buf.appendContentsOf(copied.substringWithRange(r0))
                }
                // * *
                let r2 = NSMakeRange(result.rangeAtIndex(5).location, result.rangeAtIndex(5).length)
                let sub = copied.substringWithRange(r2)
                buf.appendContentsOf(sub)
                
                attrs.append(Attribute.Bold(buf.characters.count - result.rangeAtIndex(5).length, result.rangeAtIndex(5).length))
                
                pointer = (result.rangeAtIndex(4).location + result.rangeAtIndex(4).length)
            }
            if result.rangeAtIndex(6).length > 0 {
                if result.rangeAtIndex(6).location - pointer > 0 {
                    let r0 = NSMakeRange(pointer, result.rangeAtIndex(6).location - pointer)
                    buf.appendContentsOf(copied.substringWithRange(r0))
                }
                // * *
                let r2 = NSMakeRange(result.rangeAtIndex(7).location, result.rangeAtIndex(7).length)
                let sub = copied.substringWithRange(r2)
                buf.appendContentsOf(sub)
                
                attrs.append(Attribute.Italic(buf.characters.count - result.rangeAtIndex(7).length, result.rangeAtIndex(7).length))
                
                pointer = (result.rangeAtIndex(6).location + result.rangeAtIndex(6).length)
            }
            if result.rangeAtIndex(8).length > 0 {
                if result.rangeAtIndex(8).location - pointer > 0 {
                    let r0 = NSMakeRange(pointer, result.rangeAtIndex(8).location - pointer)
                    buf.appendContentsOf(copied.substringWithRange(r0))
                }
                let rangeOfTitle = NSMakeRange(result.rangeAtIndex(9).location, result.rangeAtIndex(9).length)
                let rangeOfLink = NSMakeRange(result.rangeAtIndex(10).location, result.rangeAtIndex(10).length)
                let title = copied.substringWithRange(rangeOfTitle)
                let url = copied.substringWithRange(rangeOfLink)
                
                buf.appendContentsOf(title)
                
                attrs.append(Attribute.Link(url, buf.characters.count - title.characters.count, title.characters.count))
                
                pointer = (result.rangeAtIndex(8).location + result.rangeAtIndex(8).length)
            }
            if result.rangeAtIndex(11).length > 0 {
                if result.rangeAtIndex(11).location - pointer > 0 {
                    let r0 = NSMakeRange(pointer, result.rangeAtIndex(11).location - pointer)
                    buf.appendContentsOf(copied.substringWithRange(r0))
                }
                // ^
                let r2 = NSMakeRange(result.rangeAtIndex(12).location, result.rangeAtIndex(12).length)
                let sub = copied.substringWithRange(r2)
                
                buf.appendContentsOf(sub)
                
                attrs.append(Attribute.Superscript(buf.characters.count - sub.characters.count, sub.characters.count))
                
                pointer = (result.rangeAtIndex(11).location + result.rangeAtIndex(11).length)
            }
            if result.rangeAtIndex(13).length > 0 {
                if result.rangeAtIndex(13).location - pointer > 0 {
                    let r0 = NSMakeRange(pointer, result.rangeAtIndex(13).location - pointer)
                    buf.appendContentsOf(copied.substringWithRange(r0))
                }
                // ^
                let r2 = NSMakeRange(result.rangeAtIndex(13).location, result.rangeAtIndex(13).length)
                let sub = copied.substringWithRange(r2)
                buf.appendContentsOf(sub)
                
                attrs.append(Attribute.Link(sub, buf.characters.count - sub.characters.count, sub.characters.count))
                
                pointer = (result.rangeAtIndex(13).location + result.rangeAtIndex(13).length)
            }
        }
        
        if copied.length - pointer > 0 {
            let r0 = NSMakeRange(pointer, copied.length - pointer)
            buf.appendContentsOf(copied.substringWithRange(r0))
        }
        
        attrs.forEach { print($0) }
        
        return buf as String
    }
}

/**
Expand child comments which are included in Comment objects, recursively.

- parameter comment: Comment object will be expanded.

- returns: Array contains Comment objects which are expaned from specified Comment object.
*/
public func extendAllReplies(comment:Thing) -> [Thing] {
    var comments:[Thing] = [comment]
    if let comment = comment as? Comment {
        for obj in comment.replies.children {
            comments.appendContentsOf(extendAllReplies(obj))
        }
    }
    return comments
}

/**
Comment object.
*/
public struct Comment : Thing {
    /// identifier of Thing like 15bfi0.
    public var id:String
    /// name of Thing, that is fullname, like t3_15bfi0.
    public var name:String
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
    public let likes:String
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
    public let saved:Bool
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
    public let score:Int
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
    public let edited:Bool
    /**
    the CSS class of the author's flair.  subreddit specific
    example:
    */
    public let authorFlairCssClass:String
    /**
    example: 0
    */
    public let downs:Int
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
    public let ups:Int
    
    public init(id:String) {
        self.id = id
        self.name = "\(Comment.kind)_\(self.id)"
        
        subredditId = ""
        bannedBy = ""
        linkId = ""
        likes = ""
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
        likes = data["likes"] as? String ?? ""
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
        bodyHtml = data["body_html"] as? String ?? ""
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
        if let temp = data["replies"] as? JSONDictionary {
            if let obj = Parser.parseJSON(temp) as? Listing {
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


