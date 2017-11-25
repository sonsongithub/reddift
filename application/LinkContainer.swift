//
//  LinkContainer.swift
//  reddift
//
//  Created by sonson on 2016/09/29.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

class LinkContainer: LinkContainable {
    
    /// Cell identifier for dequeueReusableCellWithIdentifier of FrontViewController class.
    override var cellIdentifier: String {
        get {
            if isHidden {
                return "InvisibleCell"
            } else {
                return "LinkCell"
            }
        }
    }
}
