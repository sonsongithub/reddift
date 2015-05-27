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
public struct Listing {
	/// elements of the list
	public var children:[Thing]
	/// paginator of the list
    public var paginator:Paginator
    
    public init() {
        children = []
        paginator = Paginator()
    }
}
