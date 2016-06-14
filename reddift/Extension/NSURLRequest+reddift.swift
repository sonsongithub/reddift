//
//  NSURLRequest+reddift.swift
//  reddift
//
//  Created by sonson on 2016/06/05.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

extension NSURLRequest {
    func updateWithOAuth2Token(token: OAuth2Token) -> NSURLRequest {
        if let tempRequest = self.mutableCopy() as? NSMutableURLRequest {
            tempRequest.setOAuth2Token(token)
            return tempRequest
        } else {
            return self
        }
    }
}
