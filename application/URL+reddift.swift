//
//  URL+reddift.swift
//  reddift
//
//  Created by sonson on 2016/10/09.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

private let regularExpressionForExchangeSchema: NSRegularExpression! = {
    do {
        return try NSRegularExpression(pattern: "^http\\:\\/\\/", options: [])
    } catch {
        assert(false, "Fatal error: \(#file) \(#line) \(error)")
        return nil
    }
}()

private let regexForYoutube: NSRegularExpression! = {
    do {
        return try NSRegularExpression(pattern: "(http(s){0,1}://youtu.be/([a-zA-Z0-9\\-_\\.\\!'\\(\\)]+).*$)", options: .caseInsensitive)
    } catch {
        assert(false, "Fatal error: \(#file) \(#line) \(error)")
        return nil
    }
}()

private let regexForGfycatMovieURL: NSRegularExpression! = {
    do {
        return try NSRegularExpression(pattern: "http(s){0,1}://([a-zA-Z0-9]+\\.){0,1}gfycat.com/([a-zA-Z0-9]+).*$", options: .caseInsensitive)
    } catch {
        assert(false, "Fatal error: \(#file) \(#line) \(error)")
        return nil
    }
}()

extension URL {
    
    var httpsSchemaURL: URL {
        get {
            let string = regularExpressionForExchangeSchema.stringByReplacingMatches(in: self.absoluteString, options: [], range: NSRange(location: 0, length: self.absoluteString.utf16.count), withTemplate: "https://")
            guard let https_url = URL(string: string) else { return self }
            return https_url
        }
    }
    
    var isImageURL: Bool {
        let pathExtension = self.pathExtension.lowercased()
        if pathExtension == "jpg" || pathExtension == "gif" || pathExtension == "png" {
            return true
        }
        return false
    }
    
    var isYouTubeURL: Bool {
        if let host = self.host {
            if host == "youtu.be" || host == "www.youtube.com" || host == "youtube.com" {
                if let _ = self.extractYouTubeContentID() {
                    return true
                }
            }
        }
        return false
    }
    
    func extractYouTubeURL() -> (URL, URL)? {
        if let contentID = self.extractYouTubeContentID() {
            if let movieURL = URL(string: self.absoluteString + "&feature=youtube_gdata_player"), let thumbnailURL = URL(string: "http://i.ytimg.com/vi/\(contentID)/mqdefault.jpg") {
                return (movieURL, thumbnailURL)
            }
        }
        return nil
    }
    
    func extractYouTubeContentID() -> String? {
        // youtube.com
        if let extractedContentID = URL(string: self.absoluteString).flatMap({URLComponents(url: $0, resolvingAgainstBaseURL: true)}).flatMap({$0.queryItems}).flatMap({ (queryItems) -> String? in
            for item in queryItems {
                if item.name == "v" {
                    return item.value
                }
            }
            return nil
        }) {
            return extractedContentID
        } else {
            // youtu.be
            if let id_result = regexForYoutube.firstMatch(in: self.absoluteString as String, options: [], range: NSRange(location: 0, length: (self.absoluteString as NSString).length)) {
                if id_result.range( at: 3).length > 0 {
                    return (self.absoluteString as NSString).substring(with: id_result.range( at: 3))
                }
            }
        }
        return nil
    }
    
    var isImgurURL: Bool {
        if let host = self.host {
            if let _ = host.range(of: "imgur.com") {
                return true
            }
        }
        return false
    }
    
    var isGfygatURL: Bool {
        if let host = self.host {
            if host == "gfycat.com" {
                return true
            }
        }
        return false
    }
    
    func extractGfycatContentID(urlString: String) -> String? {
        if let result = regexForGfycatMovieURL.firstMatch(in: urlString as String, options: [], range: NSRange(location: 0, length: (urlString as NSString).length)) {
            if result.range(at: 3).length > 0 {
                print((urlString as NSString).substring(with: result.range(at: 3)))
                return (urlString as NSString).substring(with: result.range(at: 3))
            }
        }
        return nil
    }
    
    func extractGfycatURL() -> (URL, URL)? {
        if let name = extractGfycatContentID(urlString: self.absoluteString) {
            if let movieURL = URL(string: "https://thumbs.gfycat.com/\(name)-mobile.mp4"), let thumbnailURL = URL(string: "https://thumbs.gfycat.com/\(name)-mobile.jpg") {
                return (movieURL, thumbnailURL)
            }
        }
        return nil
    }
}
