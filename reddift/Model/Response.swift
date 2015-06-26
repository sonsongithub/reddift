//
//  Response.swift
//  reddift
//
//  Created by sonson on 2015/06/26.
//  Copyright © 2015年 sonson. All rights reserved.
//

import Foundation

/**
Object to eliminate codes to parse http response object.
*/
struct Response {
    let data:NSData
    let statusCode:Int
    
    init(data: NSData!, urlResponse: NSURLResponse!) {
        if let data = data {
            self.data = data
        }
        else {
            self.data = NSData()
        }
        if let httpResponse = urlResponse as? NSHTTPURLResponse {
            statusCode = httpResponse.statusCode
        }
        else {
            statusCode = 500
        }
    }
}

/**
Function to eliminate codes to parse http response object.
This function filters response object to handle errors.
*/
func parseResponse(response: Response) -> Result<NSData> {
    let successRange = 200..<300
    if !successRange.contains(response.statusCode) {
        return .Failure(HttpStatus(response.statusCode).error)
    }
    return .Success(response.data)
}