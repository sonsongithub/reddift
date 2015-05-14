//
//  Listing.swift
//  reddift
//
//  Created by sonson on 2015/04/20.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
Listing object.
This class has children, paginator and more.
*/
public class Listing {
    public var children:[Thing] = []
    public var paginator:Paginator? = nil
    public var more:More? = nil
}
