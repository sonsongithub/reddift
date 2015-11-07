//
//  NSAttributedString+reddift.swift
//  reddift
//
//  Created by sonson on 2015/10/18.
//  Copyright © 2015年 sonson. All rights reserved.
//

import Foundation

/// import to use NSFont/UIFont
#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

/// Shared font and color class
#if os(iOS) || os(tvOS)
    private typealias _Font = UIFont
    private typealias _Color = UIColor
#elseif os(OSX)
    private typealias _Font = NSFont
    private typealias _Color = NSColor
#endif

/// Enum, attributes for NSAttributedString
private enum Attribute {
    case Link(NSURL, Int, Int)
    case Bold(Int, Int)
    case Italic(Int, Int)
    case Superscript(Int, Int)
    case Strike(Int, Int)
    case Code(Int, Int)
}

/// Extension for NSParagraphStyle
extension NSParagraphStyle {
    /**
     Returns default paragraph style for reddift framework.
     - returns: Paragraphyt style, which is created.
     */
    static func defaultReddiftParagraphStyleWithFontSize(fontSize:CGFloat) -> NSParagraphStyle {
        let paragraphStyle:NSMutableParagraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .ByWordWrapping
        paragraphStyle.alignment = .Left
        paragraphStyle.maximumLineHeight = fontSize + 2
        paragraphStyle.minimumLineHeight = fontSize + 2
        paragraphStyle.lineSpacing = 1
        paragraphStyle.paragraphSpacing = 1
        paragraphStyle.paragraphSpacingBefore = 1
        paragraphStyle.lineHeightMultiple = 0
        return paragraphStyle
    }
}

/// Extension for NSAttributedString
extension String {
    /**
    Returns HTML string whose del and blockquote tag is replaced with font size tag in order to extract these tags using NSAttribtedString class method.
    - returns: String, which is processed.
    */
    public func preprocessedHTMLStringBeforeNSAttributedStringParsing() -> String {
        var temp = self.stringByReplacingOccurrencesOfString("<del>", withString: "<font size=\"5\">")
        temp = temp.stringByReplacingOccurrencesOfString("<blockquote>", withString: "<cite>")
        temp = temp.stringByReplacingOccurrencesOfString("</blockquote>", withString: "</cite>")
        return temp.stringByReplacingOccurrencesOfString("</del>", withString: "</font>")
    }
}

/// Regular expression to check whether the file extension is image's one.
private let regexForHasImageFileExtension = try! NSRegularExpression(pattern: "^/.+\\.(jpg|jpeg|gif|png)$", options: NSRegularExpressionOptions.CaseInsensitive)

/// Extension for NSAttributedString.includedImageURL
extension NSURLComponents {
    /// Returns true when URL's filename has image's file extension(such as gif, jpg, png).
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
    /// Returns list of URLs that were included in NSAttributedString as NSLinkAttributeName's array.
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
    
    /// Returns list of image URLs(like gif, jpg, png) that were included in NSAttributedString as NSLinkAttributeName's array.
    public var includedImageURL : [NSURL] {
        get {
            return self
                .includedURL
                .flatMap {NSURLComponents(URL: $0, resolvingAgainstBaseURL: false)}
                .flatMap {($0.hasImageFileExtension && $0.scheme != "applewebdata") ? $0.URL : nil}
        }
    }
    
#if os(iOS) || os(tvOS)
    /**
    Reconstructs attributed string for rendering using UZTextView or UITextView.
    - parameter normalFont : Specified UIFont you want to use when the object is rendered.
    - parameter color : Specified UIColor of strings.
    - parameter linkColor : Specified UIColor of strings have NSLinkAttributeName as an attribute.
    - parameter codeBackgroundColor : Specified UIColor of background of strings that are included in <code>.
    - returns : NSAttributedString object to render using UZTextView or UITextView.
    */
    public func reconstructAttributedString(normalFont:UIFont, color:UIColor, linkColor:UIColor, codeBackgroundColor:UIColor = UIColor.lightGrayColor()) -> NSAttributedString {
        return __reconstructAttributedString(normalFont, color:color, linkColor:linkColor, codeBackgroundColor:codeBackgroundColor)
    }
#elseif os(OSX)
    /**
    Reconstructs attributed string for rendering it.
    - parameter normalFont : Specified NSFont you want to use when the object is rendered.
    - parameter color : Specified NSColor of strings.
    - parameter linkColor : Specified NSColor of strings have NSLinkAttributeName as an attribute.
    - parameter codeBackgroundColor : Specified NSColor of background of strings that are included in <code>.
    - returns : NSAttributedString object.
    */
    public func reconstructAttributedString(normalFont:NSFont, color:NSColor, linkColor:NSColor, codeBackgroundColor:NSColor = NSColor.lightGrayColor()) -> NSAttributedString {
        return __reconstructAttributedString(normalFont, color:color, linkColor:linkColor, codeBackgroundColor:codeBackgroundColor)
    }
#endif
}

/// Private extension for NSAttributedString
extension NSAttributedString {
    /**
    Reconstruct attributed string, intrinsic function. This function is for encapsulating difference of font and color class.
    - parameter normalFont : Specified NSFont/UIFont you want to use when the object is rendered.
    - parameter color : Specified NSColor/UIColor of strings.
    - parameter linkColor : Specified NSColor/UIColor of strings have NSLinkAttributeName as an attribute.
    - parameter codeBackgroundColor : Specified NSColor/UIColor of background of strings that are included in <code>.
    - returns : NSAttributedString object.
    */
    private func __reconstructAttributedString(normalFont:_Font, color:_Color, linkColor:_Color, codeBackgroundColor:_Color) -> NSAttributedString {
        let attributes:[Attribute] = self.attributesForReddift()
        let (italicFont, boldFont, codeFont, superscriptFont, _) = createDerivativeFonts(normalFont)
        
        let output = NSMutableAttributedString(string: string)
        
        // You can set default paragraph style, here.
        // output.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, output.length))
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

    /**
    Create fonts which is derivative of specified font object.
    - parameter normalFont : Source font from which new font objects are generated. The new font objects' size are as same as source one.
    - returns : Four font objects as a tuple, that are italic, bold, code, superscript and pargraph style.
    */
    private func createDerivativeFonts(normalFont:_Font) -> (_Font, _Font, _Font, _Font, NSParagraphStyle) {
#if os(iOS) || os(tvOS)
        let traits = normalFont.fontDescriptor().symbolicTraits
        let italicFontDescriptor = normalFont.fontDescriptor().fontDescriptorWithSymbolicTraits([traits, .TraitItalic])
        let boldFontDescriptor = normalFont.fontDescriptor().fontDescriptorWithSymbolicTraits([traits, .TraitBold])
        let italicFont = _Font(descriptor: italicFontDescriptor, size: normalFont.fontDescriptor().pointSize)
        let boldFont = _Font(descriptor: boldFontDescriptor, size: normalFont.fontDescriptor().pointSize)
        let codeFont = _Font(name: "Courier", size: normalFont.fontDescriptor().pointSize) ?? normalFont
        let superscriptFont = _Font(descriptor: normalFont.fontDescriptor(), size: normalFont.fontDescriptor().pointSize/2)
        let paragraphStyle = NSParagraphStyle.defaultReddiftParagraphStyleWithFontSize(normalFont.fontDescriptor().pointSize)
#elseif os(OSX)
        let traits:NSFontSymbolicTraits = normalFont.fontDescriptor.symbolicTraits
        let italicFontDescriptor = normalFont.fontDescriptor.fontDescriptorWithSymbolicTraits(traits & NSFontSymbolicTraits(NSFontItalicTrait))
        let boldFontDescriptor = normalFont.fontDescriptor.fontDescriptorWithSymbolicTraits(traits & NSFontSymbolicTraits(NSFontBoldTrait))
        let italicFont = _Font(descriptor: italicFontDescriptor, size: normalFont.fontDescriptor.pointSize) ?? normalFont
        let boldFont = _Font(descriptor: boldFontDescriptor, size: normalFont.fontDescriptor.pointSize) ?? normalFont
        let codeFont = _Font(name: "Courier", size: normalFont.fontDescriptor.pointSize) ?? normalFont
        let superscriptFont = _Font(descriptor: normalFont.fontDescriptor, size: normalFont.fontDescriptor.pointSize/2) ?? normalFont
        let paragraphStyle = NSParagraphStyle.defaultReddiftParagraphStyleWithFontSize(normalFont.fontDescriptor.pointSize)
#endif
        return (italicFont, boldFont, codeFont, superscriptFont, paragraphStyle)
    }
    
    /**
    Extract attributes from NSAttributedString in order to set attributes and values again to new NSAttributedString for rendering.
    - returns : Attribute's array to set a new NSAttributedString.
    */
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
                    attributes.append(Attribute.Bold(range.location, range.length))
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