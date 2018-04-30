//
//  String+reddift.swift
//  reddift
//
//  Created by sonson on 2016/07/18.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation
import JavaScriptCore

private let regexFor404: NSRegularExpression! = {
    do {
        return try NSRegularExpression(pattern: "<title>.*?404.*?</title>", options: NSRegularExpression.Options.caseInsensitive)
    } catch {
        assert(true, "Fatal error: \(#file) \(#line)")
        return nil
    }
}()

private let imgurImageURLFromHeaderMetaTag: NSRegularExpression! = {
    do {
        return try NSRegularExpression(pattern: "<meta(\\s+)property=\"og:image\"(\\s+)content=\"(.+?)(\\?.+){0,1}\"(\\s+)/>", options: NSRegularExpression.Options.caseInsensitive)
    } catch {
        assert(true, "Fatal error: \(#file) \(#line)")
        return nil
    }
    
}()

private let imgurVideoURLFromHeaderMetaTag: NSRegularExpression! = {
    do {
        return try NSRegularExpression(pattern: "<meta(\\s+)property=\"og:video\"(\\s+)content=\"(.+?)(\\?.+){0,1}\"(\\s+)/>", options: NSRegularExpression.Options.caseInsensitive)
    } catch {
        assert(true, "Fatal error: \(#file) \(#line)")
        return nil
    }
    
}()

private let regexForImageJSON: NSRegularExpression! = {
    do {
        return try NSRegularExpression(pattern: "window.runSlots = (\\{.+?\\};)", options: [.caseInsensitive, .dotMatchesLineSeparators])
    } catch {
        assert(false, "Fatal error: \(#file) \(#line) - \(error)")
        return nil
    }
}()

extension NSString {
    var fullRange: NSRange {
        get {
            return NSRange(location: 0, length: self.length)
        }
    }
}

extension String {
    
    var md5: String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate()
        
        return String(format: hash as String)
    }
    
    /**
    */
    var fullRange: NSRange {
        get {
            return NSRange(location: 0, length: self.utf16.count)
        }
    }
    
    /**
     Check whether this string includes "```<title>.*?404.*?</title>```" or not.
    */
    var is404OfImgurcom: Bool {
        get {
            let results404 = regexFor404.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            return (results404.count > 0)
        }
    }
    
    /**
     */
    func extractImgurImageURLFromAlbum(parentID: String) -> [Thumbnail] {
        guard let result = regexForImageJSON.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) else { return [] }
        
        let json = (self as NSString).substring(with: result.range(at: 1))
        let script = "var dict = \(json)"
        let js = JSContext()
        guard let _ = js?.evaluateScript(script), let dict = js?.objectForKeyedSubscript("dict").toDictionary() else { return [] }
        guard let items = dict["_item"] as? [String: AnyObject],
            let albumItems = items["album_images"] as? [String: AnyObject],
            let images = albumItems["images"] as? [[String: AnyObject]],
            let _ = albumItems["count"] else { return [] }
        return images.compactMap({
            if let hash = $0["hash"] as? String, let ext = $0["ext"] as? String {
                return "https://i.imgur.com/\(hash)\(ext)" as String
            }
            return nil
        }).compactMap({
            URL(string: $0)
        }).compactMap({
            Thumbnail.Image(imageURL: $0, parentID: parentID)
        })
    }
    
    /**
     */
    func extractImgurImageURLFromSingleImage(parentID: String) -> [Thumbnail] {
        guard let result = imgurImageURLFromHeaderMetaTag.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) else { return [] }
        let range = result.range(at: 3)
        let urlstring = (self as NSString).substring(with: range)
        return [URL(string: urlstring)].compactMap({$0}).compactMap({
            Thumbnail.Image(imageURL: $0, parentID: parentID)
        })
    }
    
    func extractImgurMovieOrImageURL(parentID: String) -> Thumbnail? {
        var thumbnailURL: URL?
        var movieURL: URL?
        
        if let result = imgurImageURLFromHeaderMetaTag.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            let range = result.range(at: 3)
            let urlstring = (self as NSString).substring(with: range)
            thumbnailURL = URL(string: urlstring)
        }
        
        if let result = imgurVideoURLFromHeaderMetaTag.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            let range = result.range(at: 3)
            let urlstring = (self as NSString).substring(with: range)
            movieURL = URL(string: urlstring)
        }
        
        if let thumbnailURL = thumbnailURL, let movieURL = movieURL {
            return Thumbnail.Movie(movieURL: movieURL, thumbnailURL: thumbnailURL, parentID: parentID)
        } else if let thumbnailURL = thumbnailURL {
            return Thumbnail.Image(imageURL: thumbnailURL, parentID: parentID)
        }
        return nil
    }
    
    /**
     Extract image URL from html text of imgur.com.
     Strictly speaking, this method parses javascript source code of html using JavascriptCore.framework.
     - parameter html: HTML text which is downloaded from imgur.com and has image url list.
     - returns: Array of ThumbnailInfo objects. They include image urls.
     */
    func extractImgurImageURL(parentID: String) -> [Thumbnail] {
        let urls = extractImgurImageURLFromAlbum(parentID: parentID)
        if urls.count > 0 {
            return urls
        }
        if let thumbnail = extractImgurMovieOrImageURL(parentID: parentID) {
            return [thumbnail]
        }
        return []
    }
}
