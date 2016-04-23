//
//  CAPTCHAView.swift
//  reddift
//
//  Created by sonson on 2015/05/11.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit
import reddift

class CAPTCHAView: UIView {
    var session: Session? = nil
    private var currentIden = ""
    
    var iden: String {
        return currentIden
    }
    
    var response: String {
        if let text = captchaTextField?.text {
            return text
        }
        return ""
    }
    
    @IBOutlet private var captchaImageView: UIImageView? = nil
    @IBOutlet private var captchaTextField: UITextField? = nil
    @IBOutlet private var activity: UIActivityIndicatorView? = nil
    
    class func loadFromIdiomNib() -> CAPTCHAView? {
        let nib = UINib(nibName: "CAPTCHAView", bundle: nil)
        if let view = nib.instantiateWithOwner(nil, options: nil)[0] as? CAPTCHAView {
            return view
        }
        return nil
    }
    
    @IBAction func reload(sender: AnyObject) {
        startLoading()
    }
    
    func startLoading() {
        captchaImageView?.image = nil
        activity?.startAnimating()
        activity?.hidden = false
        
        do {
            try self.session?.getIdenForNewCAPTCHA({ (result) -> Void in
                switch result {
                case .Failure(let error):
                    print(error.description)
                case .Success(let identifier):
                    do {
                        try self.session?.getCAPTCHA(identifier, completion: { (result) -> Void in
                            switch result {
                            case .Failure(let error):
                                print(error.description)
                            case .Success(let image):
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.currentIden = identifier
                                    if let imageView = self.captchaImageView {
                                        imageView.image = image
                                    }
                                    if let activity = self.activity {
                                        activity.stopAnimating()
                                        activity.hidden = true
                                    }
                                })
                            }
                        })
                    } catch { print(error) }
                }
            })
        } catch { print(error) }
    }
}
