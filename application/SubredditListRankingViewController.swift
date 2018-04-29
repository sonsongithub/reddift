//
//  SubredditListRankingViewController.swift
//  reddift
//
//  Created by sonson on 2015/10/26.
//  Copyright © 2015年 sonson. All rights reserved.
//

import UIKit

/**
 View controller to show ranking of all subreddits at redditlist.com.
 */
class SubredditListAllRankingViewController: SubredditListRankingViewController {
}

/**
 View controller to show ranking of SFW subreddits at redditlist.com.
 */
class SubredditListSFWRankingViewController: SubredditListRankingViewController {
}

/**
 View controller to show ranking of NSFW subreddits at redditlist.com.
 */
class SubredditListNSFWRankingViewController: SubredditListRankingViewController {
}

/**
 View controller to show ranking of subreddits at redditlist.com.
 */
class SubredditListRankingViewController: UITableViewController {
    var targetType: SubredditListRankingTargetType = .All
    var orderType: SubredditListRankingOrderType = .RecentActivity
    var type: String = ""
    var list: [String: [SubredditListItem]] = [:]
    var lastUpdateDate = NSDate()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        targetType = SubredditListRankingTargetType(viewController: self)
        self.title = targetType.tabbarTitle
        self.tabBarItem = UITabBarItem(title: self.title, image: UIImage(named: "crown"), selectedImage: UIImage(named: "crown"))
    }
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        targetType = SubredditListRankingTargetType(viewController: self)
        self.title = targetType.tabbarTitle
        self.tabBarItem = UITabBarItem(title: self.title, image: UIImage(named: "crown"), selectedImage: UIImage(named: "crown"))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        targetType = SubredditListRankingTargetType(viewController: self)
        self.title = targetType.tabbarTitle
        self.tabBarItem = UITabBarItem(title: self.title, image: UIImage(named: "crown"), selectedImage: UIImage(named: "crown"))
    }
    
    @IBAction func close(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didChangeSegementedController(sender: AnyObject) {
        if let segmentedController = sender as? UISegmentedControl {
            switch segmentedController.selectedSegmentIndex {
            case 0:
                orderType = .RecentActivity
            case 1:
                orderType = .Subscriber
            case 2:
                orderType = .Growth
            default:
                orderType = .RecentActivity
            }
            tableView.reloadData()
        }
    }
    
    func loadJSON() {
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        let url = targetType.url
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, _, _) -> Void in
            if let data = data {
                let (subscribersRankingList, growthRankingList, recentActivityList, lastUpdateDate) = SubredditListItem.SubredditListJSON2List(data: data as NSData)
                self.lastUpdateDate = lastUpdateDate
                self.list[SubredditListRankingOrderType.RecentActivity.jsonKey] = recentActivityList
                self.list[SubredditListRankingOrderType.Subscriber.jsonKey] = subscribersRankingList
                self.list[SubredditListRankingOrderType.Growth.jsonKey] = growthRankingList
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadData()
            })
        })
        task.resume()
    }
    
    func initializeNavigationBar() {
        // create close button on navigation bar
        let barbutton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SubredditListRankingViewController.close(sender:)))
        self.navigationItem.rightBarButtonItem = barbutton
        
        // set prompt, that is a small title on the top of navigation bar
        navigationItem.prompt = targetType.title
        
        // set segmented control on navigation bar
        let control = UISegmentedControl(items: [#imageLiteral(resourceName: "update"), #imageLiteral(resourceName: "bookmark"), #imageLiteral(resourceName: "trend")])
        navigationItem.titleView = control
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(SubredditListRankingViewController.didChangeSegementedController(sender:)), for: .valueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SubredditListViewRightValueCell.self, forCellReuseIdentifier: "Cell")
        initializeNavigationBar()
        loadJSON()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let list = self.list[orderType.jsonKey] else { return 0 }
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let list = self.list[orderType.jsonKey] else { return }
        let subredditListItem = list[indexPath.row]
        NotificationCenter.default.post(name: SubredditSelectTabBarControllerDidOpenSubredditName, object: nil, userInfo: ["subreddit": subredditListItem.subreddit])
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        guard let list = self.list[orderType.jsonKey] else { return cell }
        
        let subredditListItem = list[indexPath.row]
        cell.textLabel?.text = subredditListItem.title
        cell.detailTextLabel?.text = "\(subredditListItem.score)"
        
        return cell
    }
}
