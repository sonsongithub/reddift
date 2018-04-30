//
//  SubredditListItem.swift
//  reddift
//
//  Created by sonson on 2015/12/28.
//  Copyright © 2015年 sonson. All rights reserved.
//

import Foundation

/**
 Subreddit object which is used by subredditlist.com
 */
struct SubredditListItem {
    /// Subreddit subpath, such as windows in /r/windows
    let subreddit: String
    /// Subreddit's title
    let title: String
    /// Subreddit's content type, sfw or nsfw.
    let type: String
    /// Description of subreddit.
    let description: String
    /// Rank of subreddit.
    let ranking: String
    /// Score of subreddit, is that subscriptors, growth rate and recent activity.
    let score: String
    
    /**
     Initialize SubredditListItem.
     - parameter subreddit: Subreddit subpath, such as windows in /r/windows
     - parameter title: Subreddit's title
     - parameter type: Subreddit's content type, sfw or nsfw.
     - parameter description: Description of subreddit.
     - parameter ranking: Rank of subreddit.
     - parameter score: Score of subreddit, is that subscriptors, growth rate and recent activity.
     - returns: SubredditListItem objects.
    */
    init(subreddit: String, title: String, type: String, description: String, ranking: String, score: String) {
        self.subreddit = subreddit
        self.title = title
        self.type = type
        self.description = description
        self.ranking = ranking
        self.score = score
    }
    
    /**
     Create SubredditListItem with dictionary object which is obtained from api.reddift.net.
     - parameter dict: Dictinay, that is [String:AnyObject], which is extracted from JSON at api.reddift.net.
     - parameter showsNSFW: Filters NSFW contents. Returns nil when the dict's type is "nsfw" and this argument is false. Default is true.
     - returns: SubredditListItem object.
     */
    static func objectFromDictionary(dict: [String: AnyObject], showsNSFW: Bool = true) -> SubredditListItem? {
        let subreddit = dict["subreddit"] as? String ?? ""
        let title = dict["title"] as? String ?? ""
        let type = dict["type"] as? String ?? ""
        let description = dict["description"] as? String ?? ""
        let ranking = dict["ranking"] as? String ?? ""
        let score = dict["score"] as? String ?? ""
        if type == "nsfw" && !showsNSFW { return nil }
        return SubredditListItem(subreddit: subreddit, title: title, type: type, description: description, ranking: ranking, score: score)
    }
    
    /**
     Extracted arrays of SubredditListItem from https://api.reddift.net/all_ranking.json, nsfw_ranking.json, sfw_ranking.json.
     - parameter data: Binary data of JSON object.
     - returns: Tuple object which includes three lists and NSDate which shows last update date. The three lists are ranking of all subreddits, nswf and sfw.
    */
    static func SubredditListJSON2List(data: NSData) -> ([SubredditListItem], [SubredditListItem], [SubredditListItem], NSDate) {
        do {
            let json = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions())
            if let dictionary = json as? [String: AnyObject] {
                guard let data_root = dictionary["data"] as? [String: AnyObject]
                    else { throw NSError(domain: "com.sonson.reddift", code: 0, userInfo: nil) }
                guard let lastUpdateDate = dictionary["lastUpdateDate"] as? Double
                    else { throw NSError(domain: "com.sonson.reddift", code: 0, userInfo: nil) }
                guard let subscribers_json = data_root["Subscribers"] as? [[String: AnyObject]]
                    else { throw NSError(domain: "com.sonson.reddift", code: 0, userInfo: nil) }
                guard let growth_json = data_root["Growth (24Hrs)"] as? [[String: AnyObject]]
                    else { throw NSError(domain: "com.sonson.reddift", code: 0, userInfo: nil) }
                guard let recent_json = data_root["Recent Activity"] as? [[String: AnyObject]]
                    else { throw NSError(domain: "com.sonson.reddift", code: 0, userInfo: nil) }
                let subscribersRankingList = subscribers_json.compactMap({SubredditListItem.objectFromDictionary(dict: $0)})
                let growthRankingList = growth_json.compactMap({SubredditListItem.objectFromDictionary(dict: $0)})
                let recentActivityList = recent_json.compactMap({SubredditListItem.objectFromDictionary(dict: $0)})
                let date = NSDate(timeIntervalSince1970: lastUpdateDate)
                return (subscribersRankingList, growthRankingList, recentActivityList, date)
            }
            return ([], [], [], NSDate())
        } catch {
            return ([], [], [], NSDate())
        }
    }
    
    /**
     Extracted arrays of SubredditListItem from https://api.reddift.net/newsokur.json.
     - parameter data: Binary data of JSON object.
     - parameter showsNSFW: Set true when you do not want filter nsfw contents.
     - returns: Tuple object which includes dictionary, list of category titles and NSDate which shows last update date. The dictionay is with category title keys and SubredditListItem list.
     */
    static func ReddiftJSON2List(data: NSData, showsNSFW: Bool = true) -> ([String: [SubredditListItem]], [String], NSDate) {
        do {
            let json = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions())
            guard let dictionary = json as? [String: AnyObject]
                else { throw NSError(domain: "com.sonson.reddift", code: 0, userInfo: nil) }
            guard let lastUpdateDate = dictionary["lastUpdateDate"] as? Double
                else { throw NSError(domain: "com.sonson.reddift", code: 0, userInfo: nil) }
            guard let categories = dictionary["data"] as? [String: AnyObject]
                else { throw NSError(domain: "", code: 0, userInfo: nil) }
            var categoryLists: [String: [SubredditListItem]] = [:]
            categories.keys.forEach({
                if let list = categories[$0] as? [[String: AnyObject]] {
                    let temp = list.compactMap({SubredditListItem.objectFromDictionary(dict: $0, showsNSFW: showsNSFW)})
                    if temp.count > 0 {
                        categoryLists[$0] = temp
                    }
                }
            })
            let date = NSDate(timeIntervalSince1970: lastUpdateDate)
            let categoryTitles = Array(categoryLists.keys)
            return (categoryLists, categoryTitles, date)
        } catch {
            return ([:], [], NSDate())
        }
    }
}
