//
//  FrontCollectionViewController.swift
//  reddift
//
//  Created by sonson on 2015/11/18.
//  Copyright © 2015年 sonson. All rights reserved.
//

import UIKit
import reddift

private let reuseIdentifier = "Cell"

class FrontCollectionViewController: UICollectionViewController {
    let horizontalMargin = CGFloat(400)
    let textViewMargin = CGFloat(10)
    var link: [Link] = []
    var contents: [CellContent] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let anonymouseSession = Session()
        do {
            try anonymouseSession.getList(Paginator(), subreddit: nil, sort: .new, timeFilterWithin: .week) { (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let listing):
                    let incomming = listing.children.flatMap({$0 as? Link})
                    let incommingContents = incomming.map({
                        return CellContent(string:$0.title, width:self.view.frame.size.width - self.horizontalMargin - self.textViewMargin, fontSize: 32)
                    })
                    
                    self.link.append(contentsOf: incomming)
                    self.contents.append(contentsOf: incommingContents)
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.collectionView?.reloadData()
                    })
                }
            }
        } catch { print(error) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(UINib(nibName: "TVUZTextVIewCell", bundle: nil), forCellWithReuseIdentifier: "TVUZTextVIewCell")
        self.collectionView?.contentInset = UIEdgeInsetsMake(0, 0, 100, 0)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contents.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width - horizontalMargin, height: contents[indexPath.row].textHeight + textViewMargin)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TVUZTextVIewCell", for: indexPath as IndexPath)
        if let cell = cell as? TVUZTextVIewCell {
            cell.textView?.attributedString = contents[indexPath.row].attributedString
        }
        return cell
    }
}
