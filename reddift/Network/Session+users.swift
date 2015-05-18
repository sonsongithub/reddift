//
//  Session+users.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Session {
    
    /**
    Get Links or Comments that a user liked, saved, commented, hide, diskiked and etc.
    
    :param: username Name of user.
    :param: content The type of user's contents as UserContent.
    :param: paginator Paginator object for paging contents.
    :param: limit The maximum number of comments to return. Default is 25.
    :param: completion The completion handler to call when the load request is complete.
    :returns: Data task which requests search to reddit.com.
    */
    public func getUserContent(username:String, content:UserContent, sort:UserContentSortBy, timeFilterWithin:TimeFilterWithin, paginator:Paginator, limit:Int = 25, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var parameter = ["t":timeFilterWithin.param];
        parameter["limit"] = "\(limit)"
        parameter["show"] = "given"
        parameter["sort"] = sort.param
        // parameter["sr_detail"] = "true"
        parameter.update(paginator.parameters())
        
        var request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(Session.baseURL, path:"/user/" + username + content.path, parameter:parameter, method:"GET", token:token)
        return handleRequest(request, completion:completion)
    }
    
    
    
}