//
//  SubredditListCategoryTargetType.swift
//  reddift
//
//  Created by sonson on 2016/08/11.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

/**
 "Safe For Work" flag type.
 This type is used for creating title for view controller, tab bar title and URL for json.
 This type has NSFW and SFW.
 */
enum SubredditListCategoryTargetType {
    case NSFW
    case SFW
    
    init(viewController: SubredditListCategoryViewController) {
        if viewController.isKind(of: SubredditListNSFWCategoryViewController.self) {
            self = .NSFW
        } else if viewController.isKind(of: SubredditListSFWCategoryViewController.self) {
            self = .SFW
        } else {
            self = .SFW
        }
    }
    
    var tabbarTitle: String {
        switch self {
        case .NSFW:
            return "Category NSFW"
        case .SFW:
            return "Category SFW"
        }
    }
    
    var title: String {
        switch self {
        case .NSFW:
            return "NSFW"
        case .SFW:
            return "SFW"
        }
    }
    
    var url: URL {
        switch self {
        case .NSFW:
            return URL(string: "https://api.reddift.net/nsfw_category_map.json")!
        case .SFW:
            return URL(string: "https://api.reddift.net/sfw_category_map.json")!
        }
    }
}
