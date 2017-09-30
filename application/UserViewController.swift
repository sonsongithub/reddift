//
//  UserViewController.swift
//  reddift
//
//  Created by sonson on 2016/09/13.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

class UserViewController: UIViewController {
    let name: String
    
    class func controller(_ name: String) -> UINavigationController {
        let con = UserViewController(name)
        let nav = UINavigationController(rootViewController: con)
        return nav
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = ""
        super.init(coder: aDecoder)
    }
    
    init(_ aName: String) {
        name = aName
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let barbutton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(UserViewController.close(sender:)))
        self.navigationItem.rightBarButtonItem = barbutton
        view.backgroundColor = UIColor.white
        self.navigationItem.title = name
    }
    
    @objc func close(sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
