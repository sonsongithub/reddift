//
//  ImageURLContainer.swift
//  reddift
//
//  Created by sonson on 2016/10/09.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

protocol ImageURLContainer {
    var sourceURL: URL { get set }
    var imageURL: [Thumbnail] { get set }
}

struct ImageURLInComment: ImageURLContainer {
    var sourceURL: URL
    var parentID: String
    var imageURL: [Thumbnail] = []
    
    init(sourceURL: URL, parentID: String) {
        self.sourceURL = sourceURL
        self.parentID = parentID
        imageURL = [Thumbnail.Image(imageURL: sourceURL, parentID: parentID)]
    }
}

struct ImgurURLInComment: ImageURLContainer {
    var sourceURL: URL
    var parentID: String
    var imageURL: [Thumbnail] = []
    
    init(sourceURL: URL, parentID: String) {
        let removed = sourceURL.deletingPathExtension()
        self.parentID = parentID
        self.sourceURL = removed
    }
}

struct MovieURLInComment: ImageURLContainer {
    var sourceURL: URL
    var parentID: String
    var imageURL: [Thumbnail] = []
    
    init(sourceURL: URL, thumbnailURL: URL, parentID: String) {
        self.parentID = parentID
        self.sourceURL = sourceURL
        self.imageURL = [Thumbnail.Movie(movieURL: sourceURL, thumbnailURL: thumbnailURL, parentID: parentID)]
    }
    
}
