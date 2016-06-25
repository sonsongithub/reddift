//
//  NSURLRequest+reddift.swift
//  reddift
//
//  Created by sonson on 2016/06/05.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

extension URLRequest {
    func updateWithOAuth2Token(_ token: OAuth2Token) -> URLRequest {
        if var tempRequest = (self as NSURLRequest).mutableCopy() as? URLRequest {
            tempRequest.setOAuth2Token(token)
            return tempRequest as URLRequest
        } else {
            return self
        }
    }
}
