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
	/// elements of the list
	public var children:[Thing] = []
	/// paginator of the list
	public var paginator:Paginator? = nil
	/// more object of the list, includes contents that have not been downloaded.
    public var more:More? = nil
}
