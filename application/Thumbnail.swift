//
//  Thumbnail.swift
//  reddift
//
//  Created by sonson on 2016/03/26.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

enum Thumbnail {
    case Image(imageURL: URL, parentID:String)
    case Movie(movieURL: URL, thumbnailURL: URL, parentID:String)
    
    var thumbnailURL: URL {
        switch self {
        case .Image(let imageURL, _):
            return imageURL
        case .Movie( _, let thumbnailURL, _):
            return thumbnailURL
        }
    }
    
    var url: URL {
        switch self {
        case .Image(let imageURL, _):
            return imageURL
        case .Movie(let movieURL, _, _):
            return movieURL
        }
    }
    
    var parentID: String {
        switch self {
        case .Image(_, let parentID):
            return parentID
        case .Movie(_, _, let parentID):
            return parentID
        }
    }
}
