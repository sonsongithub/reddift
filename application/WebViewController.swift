//
//  WebViewController.swift
//  Sample3DTouch
//
//  Created by sonson on 2016/09/04.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation
import WebKit

class WebViewController: UIViewController {
    let webView = WKWebView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let views = ["webView": webView]
        
        view.addConstraints (
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[webView]-0-|", options: [], metrics: nil, views: views)
        )
        view.addConstraints (
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[webView]-0-|", options: [], metrics: nil, views: views)
        )
        
        let bar = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(WebViewController.close(sender:)))
        self.navigationItem.rightBarButtonItem = bar
    }
    
    @objc func close(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var url: URL? = nil {
        didSet {
            if let aUrl = url {
                let request = URLRequest(url: aUrl)
                webView.load(request)
            }
        }
    }
}
