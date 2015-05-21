//
//  Parser+Multi.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Parser {
    /**
    Parse Multi JSON
    
    :param: data Dictionary, must be generated parsing "LabeledMulti".
    :returns: Subreddit object as Thing.
    */
    class func parseDataInJSON_Multi(data:JSON) -> Result<[Multireddit]> {
        var results:[Multireddit] = []
        if let array = data as? [AnyObject] {
            for element in array {
                if let multi = element as? [String:AnyObject] {
                    if let kind = multi["kind"] as? String {
                        if kind == "LabeledMulti" {
                            if let data = multi["data"] as? [String:AnyObject] {
                                let obj = Multireddit(json: data)
                                results.append(obj)
                            }
                        }
                    }
                }
            }
        }
        return resultFromOptional(results, ReddiftError.ParseThingT2.error)
    }
}