//
//  Listing.swift
//  reddift
//
//  Created by sonson on 2015/04/20.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
The sort method for listing.
*/
public enum TimeSort {
    case Hour
    case Day
    case Week
    case Month
    case Year
    case All
    
    public var path:String {
        get {
            switch self{
            case .Hour:
                return "/hour"
            case .Day:
                return "/day"
            case .Year:
                return "/top"
            case .Week:
                return "/week"
            case .Month:
                return "/month"
            case .Year:
                return "/year"
            case .All:
                return "/all"
            }
        }
    }
}

/**
Listing object.
This class has children, paginator and more.
*/
public class Listing {
    public var children:[Thing] = []
    public var paginator:Paginator? = nil
    public var more:More? = nil
}
