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
	public var id = ""
	public var name = ""
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
