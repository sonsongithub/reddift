//
//  CommentContainable.swift
//  reddift
//
//  Created by sonson on 2016/09/29.
//  Copyright © 2016年 sonson. All rights reserved.
//

import reddift
import Foundation

class CommentContainable: ThingContainable, ImageDownloadable {
    var depth: Int
    var isCollapsed: Bool = false
    var isLoading: Bool = false
    var numberOfChildren: Int = 0
    var isTop = false
    
    init(with thing: Thing, depth: Int) {
        self.depth = depth
        super.init(with: thing)
    }
    
    /// Method to download attional contents or images when the cell is updated.
    func downloadImages() {
    }
    
    func layout(with width: CGFloat, fontSize: CGFloat) {
    }
    
    static func createContainer(with object: Thing, depth: Int, width: CGFloat, fontSize: CGFloat = 14) throws -> CommentContainable {
        if let comment = object as? Comment {
            return CommentContainer(with: comment, depth: depth, width: width)
        } else if let more = object as? More {
            return MoreContainer(with: more, depth: depth)
        } else {
            throw NSError(domain: "a", code: 0, userInfo: nil)
        }
    }
}
