//
//  NSAttributedString+reddift.swift
//  reddift
//
//  Created by sonson on 2015/10/18.
//  Copyright © 2015年 sonson. All rights reserved.
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
    
#if os(iOS)
    /**
    Reconstruct attributed string.
    - parameter normalFont : To be written
    - parameter color : To be written
    - parameter linkColor : To be written
    - parameter codeBackgroundColor : To be written
    - returns : To be written
    */
    public func reconstructAttributedString(normalFont:UIFont, color:UIColor, linkColor:UIColor, codeBackgroundColor:UIColor = UIColor.lightGrayColor()) -> NSAttributedString {
        return __reconstructAttributedString(normalFont, color:color, linkColor:linkColor, codeBackgroundColor:codeBackgroundColor)
    }
#elseif os(OSX)
    /**
    Reconstruct attributed string.
    - parameter normalFont : To be written
    - parameter color : To be written
    - parameter linkColor : To be written
    - parameter codeBackgroundColor : To be written
    - returns : To be written
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
    - parameter normalFont : To be written
    - parameter color : To be written
    - parameter linkColor : To be written
    - parameter codeBackgroundColor : To be written
    - returns : To be written
    */
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

    /**
    Create fonts for NSAttributedString
    - parameter normalFont : To be written
    - returns : To be written
    */
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
    
    /**
    Extract attributes from NSAttributedString in order to set attributes and values again to new NSAttributedString for rendering
    - returns : To be written
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