//
//  Votable.swift
//  reddift
//
//  Created by sonson on 2017/01/09.
//  Copyright © 2017年 sonson. All rights reserved.
//

import Foundation

public protocol Votable {
    var ups: Int {get}
    var downs: Int {get}
    var likes: VoteDirection {get}
}
