//
//  CAPTCHAView.swift
//  reddift
//
//  Created by sonson on 2015/05/11.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import UIKit

class CAPTCHAView : UIView {
    @IBOutlet var captchaImageView:UIImageView? = nil
    @IBOutlet var captchaTextField:UITextField? = nil
    
    class func loadFromIdiomNib() -> CAPTCHAView? {
        let nib = UINib(nibName: "CAPTCHAView", bundle: nil)
        if let view = nib.instantiateWithOwner(nil, options: nil)[0] as? CAPTCHAView {
            return view
        }
        return nil
    }
}