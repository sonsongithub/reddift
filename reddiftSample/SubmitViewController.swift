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
    var session:Session? = nil
    var subreddit:Subreddit? = nil
    var textView:UITextView? = nil
    var bottom:NSLayoutConstraint? = nil
    
    @IBAction func close(sender:AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textView = UITextView(frame: CGRectZero)
        self.view.addSubview(textView)
        
        textView.text = "aaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoioiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoi"
        textView.bounces = true
        textView.alwaysBounceVertical = true
        
        textView.backgroundColor = UIColor.redColor()
        
        textView.setTranslatesAutoresizingMaskIntoConstraints(false)

        self.view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1, constant: 0))
        let bottom = NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(bottom)
        self.bottom = bottom
        
        self.textView = textView
        
        var temp = CAPTCHAView.loadFromIdiomNib()
        if let captchaView = temp {
            self.textView?.addSubview(captchaView)
            captchaView.session = session
            captchaView.startLoading()
//            captchaView.setTranslatesAutoresizingMaskIntoConstraints(false)
//            textView.addConstraint(NSLayoutConstraint(item: captchaView, attribute: .Top, relatedBy: .Equal, toItem: textView, attribute: .Top, multiplier: 1, constant: -50))
//            textView.addConstraint(NSLayoutConstraint(item: captchaView, attribute: .Leading, relatedBy: .Equal, toItem: textView, attribute: .Leading, multiplier: 1, constant: 0))
//            textView.addConstraint(NSLayoutConstraint(item: captchaView, attribute: .Trailing, relatedBy: .Equal, toItem: textView, attribute: .Trailing, multiplier: 1, constant: 0))
//            captchaView.addConstraint(NSLayoutConstraint(item: captchaView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 50))
            
            captchaView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        }
        textView.setNeedsLayout()
        self.view.setNeedsLayout()
        
        self.textView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func keyboardWillChangeFrame(notification:NSNotification) {
        let keyboardRect = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue()
        let r = self.view.convertRect(keyboardRect!, fromView: UIApplication.sharedApplication().keyWindow)
        let windowFrame = UIApplication.sharedApplication().keyWindow?.frame
        let intersect = CGRectIntersection(keyboardRect!, windowFrame!)
        
        if intersect.size.height > 0 {
            self.bottom?.constant = -r.size.height
        }
        else {
            self.bottom?.constant = 0
        }
        
        self.view.setNeedsUpdateConstraints()
        self.view.layoutIfNeeded()
    }
    
}
