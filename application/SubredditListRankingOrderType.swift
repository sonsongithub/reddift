//
//  SubredditListRankingOrderType.swift
//  reddift
//
//  Created by sonson on 2016/08/11.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

/**
 Order type of ranking data at redditlist.com.
 There are three order types.
 */
enum SubredditListRankingOrderType {
    /// Sort by a number of recent activities of the subreddit.
    case RecentActivity
    /// Sort by a number of subscribers of the subreddit.
    case Subscriber
    /// Sort by a rate of growth of subscribers of the subreddit.
    case Growth
    
    /// Title for view controller
    var title: String {
        switch self {
        case .RecentActivity:
            return "Recent Activity"
        case .Subscriber:
            return "SUM"
        case .Growth:
            return "Growth"
        }
    }
    
    /// json key for array value.
    var jsonKey: String {
        switch self {
        case .RecentActivity:
            return "Recent Activity"
        case .Subscriber:
            return "Subscribers"
        case .Growth:
            return "Growth (24Hrs)"
        }
    }
}
