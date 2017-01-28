//
//  SubredditListRankingTargetType.swift
//  reddift
//
//  Created by sonson on 2016/08/11.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

/**
 "Safe For Work" flag type of ranking data at redditlist.com.
 This type is used for creating title for view controller, tab bar title and URL for json.
 This type has NSFW, SFW and all.
 */
enum SubredditListRankingTargetType {
    case All
    case NSFW
    case SFW
    
    init(viewController: SubredditListRankingViewController) {
        if viewController.isKind(of: SubredditListAllRankingViewController.self) {
            self = .All
        } else if viewController.isKind(of: SubredditListNSFWRankingViewController.self) {
            self = .NSFW
        } else if viewController.isKind(of: SubredditListSFWRankingViewController.self) {
            self = .SFW
        } else {
            self = .All
        }
    }
    
    var tabbarTitle: String {
        switch self {
        case .All:
            return "Ranking - All"
        case .NSFW:
            return "Ranking - NSFW"
        case .SFW:
            return "Ranking - SFW"
        }
    }
    
    var title: String {
        switch self {
        case .All:
            return "Ranking - All subreddits"
        case .NSFW:
            return "Ranking - NSFW subreddits"
        case .SFW:
            return "Ranking - SFW subreddits"
        }
    }
    
    var url: URL {
        switch self {
        case .All:
            return URL(string: "https://api.reddift.net/all_ranking.json")!
        case .NSFW:
            return URL(string: "https://api.reddift.net/nsfw_ranking.json")!
        case .SFW:
            return URL(string: "https://api.reddift.net/sfw_ranking.json")!
        }
    }
}
