//
//  SearchController.swift
//  reddift
//
//  Created by sonson on 2016/03/23.
//  Copyright © 2016年 sonson. All rights reserved.
//

import reddift
import UIKit

let SearchControllerDidOpenSubredditName = Notification.Name(rawValue: "SearchControllerDidOpenSubredditName")
let SearchControllerDidSearchSubredditName = Notification.Name(rawValue: "SearchControllerDidSearchSubredditName")

enum SearchCandidateSection: Int {
    case name = 1
    case topic = 2
    case suggest = 0
}

func sectionFromSection(_ section: Int) -> SearchCandidateSection? {
    switch section {
    case SearchCandidateSection.name.rawValue:
        return .name
    case SearchCandidateSection.topic.rawValue:
        return .topic
    case SearchCandidateSection.suggest.rawValue:
        return .suggest
    default:
        return nil
    }
}

class SearchController: UITableViewController {
    static let subredditKey = "subreddit"
    static let queryKey = "query"
    
    var subredditNames: [String] = []
    var subredditSearch: [String] = []
    var suggests: [String] = []
    
    var loadingSubredditNames = false
    var loadingSubredditSearch = false
    var loadingSuggests = false
    
    var subreddit: Subreddit?
    var timer: Timer?
    
    /// Shared session configuration
    var sessionConfiguration: URLSessionConfiguration {
        get {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            configuration.timeoutIntervalForResource = 30
            return configuration
        }
    }
    
    func searchSubredditNames(text: String) {
        do {
            loadingSubredditNames = true
            try UIApplication.appDelegate()?.session?.searchRedditNames(text, exact: false, includeOver18: false, completion: { (result) in
                switch result {
                case .failure(let error):
                    /// Callback
                    print(error)
                case .success(let array):
                    DispatchQueue.main.async(execute: {
                        self.subredditNames.removeAll()
                        self.subredditNames.append(contentsOf: array)
                        self.tableView.reloadData()
                    })
                }
                self.loadingSubredditNames = false
            })
        } catch {
            self.loadingSubredditNames = false
        }
    }
    
    func searchSubredditSearch(text: String) {
        do {
            loadingSubredditSearch = true
            try UIApplication.appDelegate()?.session?.searchSubredditsByTopic(text, completion: { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let names):
                    DispatchQueue.main.async(execute: {
                        self.subredditSearch.removeAll()
                        self.subredditSearch.append(contentsOf: names)
                        self.tableView.reloadData()
                    })
                }
                self.loadingSubredditSearch = false
            })
        } catch {
            self.loadingSubredditSearch = false
        }
    }
    
    func loadGoogleSuggest(text: String) {
        
        let queryEscaped = text.addPercentEncoding
        if let url = URL(string: "https://www.google.com/complete/search?hl=en&output=toolbar&q=" + queryEscaped) {
            var request = URLRequest(url: url)
            request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.1.56 (KHTML, like Gecko) Version/9.0 Safari/601.1.56", forHTTPHeaderField: "User-Agent")
            let session: URLSession = URLSession(configuration: self.sessionConfiguration)
            let task = session.dataTask(with: request, completionHandler: { (data, _, _) -> Void in
                self.loadingSuggests = false
                if let data = data, let string = String(data: data, encoding: .utf8) {
                    do {
                        let regex = try NSRegularExpression(pattern: "<suggestion data=\"(.+?)\"/>", options: NSRegularExpression.Options.caseInsensitive)
                        let results = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
                        let incomming: [String] = results.compactMap({
                            if $0.numberOfRanges == 2 {
                                return (string as NSString).substring(with: $0.range(at: 1))
                            }
                            return nil
                        })
                        DispatchQueue.main.async(execute: {
                            self.suggests.removeAll()
                            self.suggests.append(contentsOf: incomming)
                            self.tableView.reloadData()
                        })
                    } catch {
                    }
                }
            })
            task.resume()
            loadingSuggests = true
        }
    }
    
    func didChangeQuery(text: String) {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            if !self.loadingSubredditNames && !self.loadingSubredditSearch && !self.loadingSuggests {
                self.searchSubredditNames(text: text)
                self.searchSubredditSearch(text: text)
                self.loadGoogleSuggest(text: text)
            }
            self.timer = nil
        })
    
    }
    
    func close(sender: AnyObject) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
            }) { (_) in
                self.view.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = sectionFromSection(indexPath.section) else { return }
        switch section {
        case .name:
            if 0..<subredditNames.count ~= indexPath.row {
                let subreddit = subredditNames[indexPath.row]
                NotificationCenter.default.post(name: SearchControllerDidOpenSubredditName, object: nil, userInfo: [SearchController.subredditKey: subreddit])
            }
        case .topic:
            if 0..<subredditSearch.count ~= indexPath.row {
                let subreddit = subredditSearch[indexPath.row]
                NotificationCenter.default.post(name: SearchControllerDidOpenSubredditName, object: nil, userInfo: [SearchController.subredditKey: subreddit])
            }
        case .suggest:
            if 0..<suggests.count ~= indexPath.row {
                let query = suggests[indexPath.row]
                NotificationCenter.default.post(name: SearchControllerDidSearchSubredditName, object: nil, userInfo: [SearchController.queryKey: query])
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = sectionFromSection(section) else { return 0 }
        switch section {
        case .name:
            return subredditNames.count
        case .topic:
            return subredditSearch.count
        case .suggest:
            return suggests.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        guard let section = sectionFromSection(indexPath.section) else { return cell }
        switch section {
        case .name:
            if 0..<subredditNames.count ~= indexPath.row {
                cell.textLabel?.text = "/r/" + subredditNames[indexPath.row]
            }
        case .topic:
            if 0..<subredditSearch.count ~= indexPath.row {
                cell.textLabel?.text = "/r/" + subredditSearch[indexPath.row]
            }
        case .suggest:
            if 0..<suggests.count ~= indexPath.row {
                cell.textLabel?.text = suggests[indexPath.row]
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = sectionFromSection(section) else { return nil }
        switch section {
        case .name:
            if subredditNames.count > 0 {
                return "Matched subreddit names"
            }
        case .topic:
            if subredditSearch.count > 0 {
                return "Matched subreddit topics"
            }
        case .suggest:
            if suggests.count > 0 {
                return "Search links from all of reddit.com."
            }
        }
        return nil
    }
}
