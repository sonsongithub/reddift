//
//  SubredditListCategoryViewControllerTableViewController.swift
//  reddift
//
//  Created by sonson on 2015/12/14.
//  Copyright © 2015年 sonson. All rights reserved.
//

import UIKit

/**
 View controller to show NSFW categories of subreddits at redditlist.com.
 */
class SubredditListNSFWCategoryViewController: SubredditListCategoryViewController {
}

/**
 View controller to show SFW categories of subreddits at redditlist.com.
 */
class SubredditListSFWCategoryViewController: SubredditListCategoryViewController {
}

/**
 View controller to show categories of subreddits at redditlist.com.
 */
class SubredditListCategoryViewController: UITableViewController {
    var targetType: SubredditListCategoryTargetType = .NSFW
    var categoryLists: [String: [SubredditListItem]] = [:]
    var categoryTitles: [String] = []
    var lastUpdateDate = NSDate()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        targetType = SubredditListCategoryTargetType(viewController: self)
        self.title = targetType.tabbarTitle
        self.tabBarItem = UITabBarItem(title: self.title, image: UIImage(named: "folder"), tag: 0)
    }
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        targetType = SubredditListCategoryTargetType(viewController: self)
        self.title = targetType.tabbarTitle
        self.tabBarItem = UITabBarItem(title: self.title, image: UIImage(named: "folder"), tag: 0)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        targetType = SubredditListCategoryTargetType(viewController: self)
        self.title = targetType.tabbarTitle
        self.tabBarItem = UITabBarItem(title: self.title, image: UIImage(named: "folder"), tag: 0)
    }
    
    @IBAction func close(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func loadJSON() {
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        
        let request = URLRequest(url: targetType.url)
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
    
    override func viewDidLoad() {
        
        let barbutton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(SubredditListCategoryViewController.close(sender:)))
        self.navigationItem.rightBarButtonItem = barbutton
        
        super.viewDidLoad()
        
        tableView.register(SubredditListViewRightValueCell.self, forCellReuseIdentifier: "Cell")
        
        loadJSON()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryTitles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        cell.textLabel?.text = categoryTitles[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        let title = categoryTitles[indexPath.row]
        if let list = categoryLists[title] {
            cell.detailTextLabel?.text = "\(list.count) subreddits"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let title = categoryTitles[indexPath.row] as String?, let list = categoryLists[title] {
            let vc = SubredditListViewController()
            vc.list = list
            vc.title = title
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
