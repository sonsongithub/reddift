//
//  Thing.swift
//  reddift
//
//  Created by sonson on 2015/04/20.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

/**
Root class of all models for reddit contents.
*/
public class Thing {
	/// identifier of Thing like 15bfi0.
	public var id = ""
	/// name of Thing, that is fullname, like t3_15bfi0.
	public var name = ""
	/// type of Thing, like t3.
    public var kind = ""
    
    public init() {
    }
    
    public init(id:String, kind:String) {
        self.id = id
        self.kind = kind
        self.name = kind + "_" + id
    }
	
	public func toString() -> String {
		return "id=\(id)\n name=\(name)\n kind=\(kind)\n"
	}
}
