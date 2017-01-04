//
//  helper.swift
//  reddift
//
//  Created by sonson on 2015/04/27.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
#elseif os(macOS)
    import Cocoa
#endif

/// Shared color class
#if os(iOS) || os(tvOS)
    public typealias ReddiftColor = UIColor
#elseif os(macOS)
    public typealias ReddiftColor = NSColor
#endif
