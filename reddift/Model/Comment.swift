//
//  Comment.swift
//  reddift
//
//  Created by generator.rb via from https://github.com/reddit/reddit/wiki/JSON
//  Created at 2015-04-15 11:23:32 +0900
//

import Foundation

/// import to use NSFont/UIFont
#if os(iOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

/// Shared font and color class
#if os(iOS)
    private typealias _Font = UIFont
    private typealias _Color = UIColor
#elseif os(OSX)
    private typealias _Font = NSFont
    private typealias _Color = NSColor
#endif

extension String {
    public func preprocessedHTMLStringBeforeNSAttributedStringParsing() -> String {
        var temp = self.stringByReplacingOccurrencesOfString("<del>", withString: "<font size=\"5\">")
        temp = temp.stringByReplacingOccurrencesOfString("<blockquote>", withString: "<cite>")
        temp = temp.stringByReplacingOccurrencesOfString("</blockquote>", withString: "</cite>")
        return temp.stringByReplacingOccurrencesOfString("</del>", withString: "</font>")
    }
}

/// Enum, attributes for NSAttributedString
private enum Attribute {
    case Link(NSURL, Int, Int)
    case Bold(Int, Int)
    case Italic(Int, Int)
    case Superscript(Int, Int)
    case Strike(Int, Int)
    case Code(Int, Int)
}

/// Regular expression to check whether the file extension is image's one.
private let regexForHasImageFileExtension = try! NSRegularExpression(pattern: "^/.+\\.(jpg|jpeg|gif|png)$", options: NSRegularExpressionOptions.CaseInsensitive)

extension NSURLComponents {
    /// Returns true when URL's filename has image's file extension(like gif, jpg, png).
    private var hasImageFileExtension : Bool {
        if let path = self.path {
            if let r = regexForHasImageFileExtension.firstMatchInString(path, options: NSMatchingOptions(), range: NSMakeRange(0, path.characters.count)) {
                return r.rangeAtIndex(1).length > 0
            }
        }
        return false
    }
}

/// Extension for NSAttributedString
extension NSAttributedString {
    /// Returns list of URLs that were included in NSAttributedString as NSLinkAttributeName.
    public var includedURL : [NSURL] {
        get {
            var values:[AnyObject] = []
            self.enumerateAttribute(NSLinkAttributeName, inRange: NSMakeRange(0, self.length), options: NSAttributedStringEnumerationOptions(), usingBlock: { (value:AnyObject?, range:NSRange, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                if let value = value {
                    values.append(value)
                }
            })
            return values.flatMap { $0 as? NSURL }
        }
    }
    
    /// Returns list of image URLs(like gif, jpg, png) that were included in NSAttributedString as NSLinkAttributeName.
    public var includedImageURL : [NSURL] {
        get {
            return self
                .includedURL
                .flatMap {NSURLComponents(URL: $0, resolvingAgainstBaseURL: false)}
                .flatMap {($0.hasImageFileExtension && $0.scheme != "applewebdata") ? $0.URL : nil}
        }
    }
    
#if os(iOS)
    /// Reconstruct attributed string
    public func reconstructAttributedString(normalFont:UIFont, color:UIColor, linkColor:UIColor, codeBackgroundColor:UIColor = UIColor.lightGrayColor()) -> NSAttributedString {
        return __reconstructAttributedString(normalFont, color:color, linkColor:linkColor, codeBackgroundColor:codeBackgroundColor)
    }
#elseif os(OSX)
    /// Reconstruct attributed string
    public func reconstructAttributedString(normalFont:NSFont, color:NSColor, linkColor:NSColor, codeBackgroundColor:NSColor = NSColor.lightGrayColor()) -> NSAttributedString {
        return __reconstructAttributedString(normalFont, color:color, linkColor:linkColor, codeBackgroundColor:codeBackgroundColor)
    }
#endif
    
    /// Reconstruct attributed string, intrinsic function.
    /// This function is for encapsulating difference of font and color class.
    private func __reconstructAttributedString(normalFont:_Font, color:_Color, linkColor:_Color, codeBackgroundColor:_Color) -> NSAttributedString {
        let attributes:[Attribute] = self.attributesForReddift()
        let (italicFont, boldFont, codeFont, superscriptFont) = createFonts(normalFont)
        
        let output = NSMutableAttributedString(string: string)
        output.addAttribute(NSFontAttributeName, value: normalFont, range: NSMakeRange(0, output.length))
        output.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, output.length))
        
        attributes.forEach {
            switch $0 {
            case .Link(let URL, let loc, let len):
                output.addAttribute(NSLinkAttributeName, value:URL, range: NSMakeRange(loc, len))
                output.addAttribute(NSForegroundColorAttributeName, value: linkColor, range: NSMakeRange(loc, len))
            case .Bold(let loc, let len):
                output.addAttribute(NSFontAttributeName, value:boldFont, range: NSMakeRange(loc, len))
            case .Italic(let loc, let len):
                output.addAttribute(NSFontAttributeName, value:italicFont, range: NSMakeRange(loc, len))
            case .Superscript(let loc, let len):
                output.addAttribute(NSFontAttributeName, value:superscriptFont, range: NSMakeRange(loc, len))
            case .Strike(let loc, let len):
                output.addAttribute(NSStrikethroughStyleAttributeName, value:NSNumber(int:1), range: NSMakeRange(loc, len))
            case .Code(let loc, let len):
                output.addAttribute(NSFontAttributeName, value:codeFont, range: NSMakeRange(loc, len))
                output.addAttribute(NSBackgroundColorAttributeName, value: codeBackgroundColor, range: NSMakeRange(loc, len))
            }
        }
        return output
    }
    
    /// Create fonts for NSAttributedString
    private func createFonts(normalFont:_Font) -> (_Font, _Font, _Font, _Font) {
        #if os(iOS)
            let traits = normalFont.fontDescriptor().symbolicTraits
            
            let italicFontDescriptor = normalFont.fontDescriptor().fontDescriptorWithSymbolicTraits([traits, .TraitItalic])
            let boldFontDescriptor = normalFont.fontDescriptor().fontDescriptorWithSymbolicTraits([traits, .TraitBold])
            
            let italicFont = _Font(descriptor: italicFontDescriptor, size: normalFont.fontDescriptor().pointSize)
            let boldFont = _Font(descriptor: boldFontDescriptor, size: normalFont.fontDescriptor().pointSize)
            let codeFont = _Font(name: "Courier", size: normalFont.fontDescriptor().pointSize) ?? normalFont
            let superscriptFont = _Font(descriptor: normalFont.fontDescriptor(), size: normalFont.fontDescriptor().pointSize/2)
            #elseif os(OSX)
            let traits:NSFontSymbolicTraits = normalFont.fontDescriptor.symbolicTraits
            
            let italicFontDescriptor = normalFont.fontDescriptor.fontDescriptorWithSymbolicTraits(traits & NSFontSymbolicTraits(NSFontItalicTrait))
            let boldFontDescriptor = normalFont.fontDescriptor.fontDescriptorWithSymbolicTraits(traits & NSFontSymbolicTraits(NSFontBoldTrait))
            
            let italicFont = _Font(descriptor: italicFontDescriptor, size: normalFont.fontDescriptor.pointSize) ?? normalFont
            let boldFont = _Font(descriptor: boldFontDescriptor, size: normalFont.fontDescriptor.pointSize) ?? normalFont
            let codeFont = _Font(name: "Courier", size: normalFont.fontDescriptor.pointSize) ?? normalFont
            let superscriptFont = _Font(descriptor: normalFont.fontDescriptor, size: normalFont.fontDescriptor.pointSize/2) ?? normalFont
        #endif
        return (italicFont, boldFont, codeFont, superscriptFont)
    }
    
    /// Extract attributes from NSAttributedString in order to set attributes and values for rendering
    private func attributesForReddift() -> [Attribute] {
        var attributes:[Attribute] = []
        
        self.enumerateAttribute(NSLinkAttributeName, inRange: NSMakeRange(0, self.length), options: NSAttributedStringEnumerationOptions(), usingBlock: { (value:AnyObject?, range:NSRange, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            if let URL = value as? NSURL {
                attributes.append(Attribute.Link(URL, range.location, range.length))
            }
        })
        
        self.enumerateAttribute(NSFontAttributeName, inRange: NSMakeRange(0, self.length), options: NSAttributedStringEnumerationOptions(), usingBlock: { (value:AnyObject?, range:NSRange, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            if let font = value as? _Font {
                switch font.fontName {
                case "TimesNewRomanPS-BoldItalicMT":
                    attributes.append(Attribute.Italic(range.location, range.length))
                case "TimesNewRomanPS-ItalicMT":
                    attributes.append(Attribute.Italic(range.location, range.length))
                case "TimesNewRomanPS-BoldMT":
                    attributes.append(Attribute.Bold(range.location, range.length))
                case "Courier":
                    attributes.append(Attribute.Code(range.location, range.length))
                default:
                    do {}
                }
                if font.pointSize < 12 {
                    attributes.append(Attribute.Superscript(range.location, range.length))
                }
                else if font.pointSize > 12 {
                    attributes.append(Attribute.Strike(range.location, range.length))
                }
            }
        })
        
        return attributes
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
        let tempBodyHtml = data["body_html"] as? String ?? ""
//        print("------------------------")
        bodyHtml = tempBodyHtml.gtm_stringByUnescapingFromHTML()
        print(bodyHtml)
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


