//
//  SubmitViewController.swift
//  reddift
//
//  Created by sonson on 2015/05/10.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit
import reddift

class SubmitViewController: UIViewController {
    var session: Session? = nil
    var subreddit: Subreddit? = nil
    var textView: UITextView? = nil
    var bottom: NSLayoutConstraint? = nil
    var captchaView: CAPTCHAView? = nil
    
    @IBAction func close(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func send(_ sender: AnyObject) {
        if let subreddit = subreddit, let captcha = captchaView?.response, let iden = captchaView?.iden {
            do {
                try session?.submitText(subreddit, title: "This is test", text: "テスト,test", captcha: captcha, captchaIden: iden, completion: { (result) -> Void in
                    switch result {
                    case .failure:
                        print(result.error!.description)
                    case .success:
                        print(result.value!)
                    }
                })
            } catch { print(error) }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textView = UITextView(frame: CGRect.zero)
        self.view.addSubview(textView)
        
        textView.text = "DO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\nDO NOT SEND WITHOUT READING THE CODE.\n"
        textView.bounces = true
        textView.alwaysBounceVertical = true
        
        textView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addConstraint(NSLayoutConstraint(item: textView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: textView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: textView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0))
        let bottom = NSLayoutConstraint(item: textView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(bottom)
        self.bottom = bottom
        
        self.textView = textView
        
        let temp = CAPTCHAView.loadFromIdiomNib()
        if let captchaView = temp {
            self.textView?.addSubview(captchaView)
            captchaView.session = session
            captchaView.startLoading()
            captchaView.frame = CGRect(x: 0, y:-50, width: self.view.frame.size.width, height: 50)
            self.captchaView = captchaView
        }
        textView.setNeedsLayout()
        self.view.setNeedsLayout()
        
        self.textView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        NotificationCenter.default().addObserver(self, selector: #selector(SubmitViewController.keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func keyboardWillChangeFrame(_ notification: Notification) {
        let keyboardRect = (notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey]?.cgRectValue
        let r = self.view.convert(keyboardRect!, from: UIApplication.shared().keyWindow)
        let windowFrame = UIApplication.shared().keyWindow?.frame
        let intersect = keyboardRect!.intersection(windowFrame!)
        
        if intersect.size.height > 0 {
            self.bottom?.constant = -r.size.height
        } else {
            self.bottom?.constant = 0
        }
        
        self.view.setNeedsUpdateConstraints()
        self.view.layoutIfNeeded()
    }
    
}
