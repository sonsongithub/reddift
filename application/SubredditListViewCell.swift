//
//  SubredditListViewCell.swift
//  reddift
//
//  Created by sonson on 2015/12/29.
//  Copyright © 2015年 sonson. All rights reserved.
//

import UIKit

/**
 Cell for SubredditListViewController.
 It displays a subreddit title.
 */
class SubredditListViewSubtitleCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

/**
 Cell for SubredditListCategoryViewController and SubredditListRankingViewController.
 It displays two values. Left title's color is black and right one is light gray.
 */
class SubredditListViewRightValueCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
