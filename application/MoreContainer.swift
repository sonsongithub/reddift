//
//  MoreContainer.swift
//  reddift
//
//  Created by sonson on 2016/09/29.
//  Copyright © 2016年 sonson. All rights reserved.
//

import reddift
import Foundation

class MoreContainer: CommentContainable {
    internal var intrinsicMore: More
    var more: More {
        get {
            return intrinsicMore
        }
    }
    
    init(with more: More, depth: Int) {
        self.intrinsicMore = more
        super.init(with: more, depth: depth)
    }
    
    override var height: CGFloat {
        get {
            if isHidden {
                return 0
            }
            return 44
        }
    }
    
    override var intrinsicThing: Thing {
        didSet {
            DispatchQueue.main.async(execute: { () -> Void in
                if let more = self.intrinsicThing as? More {
                    self.intrinsicMore = more
                    NotificationCenter.default.post(name: ThingContainableDidUpdate, object: nil, userInfo: ["contents": self])
                }
            })
        }
    }
    
    override var cellIdentifier: String {
        get {
            if isHidden {
                return "InvisibleCell"
            }
            if isLoading {
                return "LoadingCell"
            }
            return "MoreCell"
        }
    }
}
