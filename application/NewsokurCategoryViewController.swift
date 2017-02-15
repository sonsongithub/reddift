//
//  NewsokurCategoryViewController.swift
//  reddift
//
//  Created by sonson on 2015/12/27.
//  Copyright © 2015年 sonson. All rights reserved.
//

import UIKit

/**
 ViewController to browse ニュー速R list json which is downloaded from api.reddift.net.
*/
class NewsokurCategoryViewController: SubredditListCategoryViewController {
    
    /// Set title for NewsokurCategoryViewController
    override init() {
        super.init(nibName: nil, bundle: nil)
        self.title = NSLocalizedString("ニュー速R", comment: "")
    }
    
    /// Set title for NewsokurCategoryViewController
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        self.title = NSLocalizedString("ニュー速R", comment: "")
    }
    
    /// Set title for NewsokurCategoryViewController
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.title = NSLocalizedString("ニュー速R", comment: "")
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("ニュー速R", comment: ""), image: UIImage(named: "newsokurFolder"), tag: 0)
    }
    
    /// Load json for ニュー速R.
    override func loadJSON() {
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        guard let url = URL(string: "https://api.reddift.net/newsokur.json")
            else { return }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, _, _) -> Void in
            if let data = data {
                (self.categoryLists, self.categoryTitles, self.lastUpdateDate) = SubredditListItem.ReddiftJSON2List(data: data as NSData, showsNSFW: true)
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadData()
            })
        })
        task.resume()
    }
}
