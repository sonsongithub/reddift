//
//  SubmitViewController.swift
//  reddift
//
//  Created by sonson on 2015/05/10.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class SubmitViewController: UIViewController {
    var textView:UITextView? = nil
    var bottom:NSLayoutConstraint? = nil
    
    @IBAction func close(sender:AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textView = UITextView(frame: CGRectZero)
        self.view.addSubview(textView)
        
        textView.text = "aaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoiaaaafdajf\n;oiweaj\noijfiojfoiajofijafoi"
        
        textView.setTranslatesAutoresizingMaskIntoConstraints(false)

        self.view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1, constant: 0))
        let bottom = NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(bottom)
        self.bottom = bottom
        
        self.view.setNeedsLayout()
        
        self.textView = textView
        
        var temp = CAPTCHAView.loadFromIdiomNib()
        if let captchaView = temp {
            self.textView?.addSubview(captchaView)
            captchaView.frame = CGRectMake(0, -50, 320, 50)
        }
        
        self.textView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
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
