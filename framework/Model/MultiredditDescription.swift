//
//  MultiredditDescription.swift
//  reddift
//
//  Created by sonson on 2015/05/23.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation
import HTMLSpecialCharacters

/**
Multireddit description class.
*/
public struct MultiredditDescription {
    public let bodyHtml: String
    public let bodyMd: String
    
    public init(json: JSONDictionary) {
        let tempBodyHtml = json["body_html"] as? String ?? ""
        bodyHtml = tempBodyHtml.unescapeHTML
        bodyMd = json["body_md"] as? String ?? ""
    }
}
