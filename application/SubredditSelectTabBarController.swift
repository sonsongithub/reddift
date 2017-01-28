//
//  SubredditSelectViewController.swift
//  reddift
//
//  Created by sonson on 2015/12/14.
//  Copyright © 2015年 sonson. All rights reserved.
//

import UIKit

let SubredditSelectTabBarControllerDidOpenSubredditName = Notification.Name(rawValue: "SubredditSelectTabBarControllerDidOpenSubredditName")

/**
 View controller to select a favorite subreddit among list.
 The list is generated from reddit
 This view controller is shown when right bar bottom item is pushed.
 */
class SubredditSelectTabBarController: UITabBarController {

    /**
     Show view controllers acording to the NSFW flag.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        let showsNSFW = true
        var navigationControllers: [UIViewController] = []
        let viewControllers: [(UIViewController, Bool)] = [
            (NewsokurCategoryViewController(), showsNSFW),
            (SubredditListNSFWCategoryViewController(), showsNSFW),
            (SubredditListSFWCategoryViewController(), true),
            (SubredditListAllRankingViewController(), showsNSFW),
            (SubredditListNSFWRankingViewController(), true),
            (SubredditListSFWRankingViewController(), true)
        ]
        viewControllers.forEach { (vc, flag) in
            if flag {
                navigationControllers.append(UINavigationController(rootViewController: vc))
            }
        }
        self.viewControllers = navigationControllers
    }
}
