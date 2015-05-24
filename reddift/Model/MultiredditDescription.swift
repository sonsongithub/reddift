//
//  MultiredditDescription.swift
//  reddift
//
//  Created by sonson on 2015/05/23.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
Multireddit description class.
*/
public struct MultiredditDescription {
    public var bodyHtml = ""
    public var bodyMd = ""
    
    public init(json:JSONDictionary) {
        bodyHtml = json["body_html"] as? String ?? ""
        bodyMd = json["body_md"] as? String ?? ""
    }
}
