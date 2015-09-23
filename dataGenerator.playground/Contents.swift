//: Playground - noun: a place where people can play

import Foundation
import XCPlayground
import reddift

let reg = try! NSRegularExpression(pattern: "\\^|\\[|\\]|/|\\(|\\)|\\*|~|&", options: NSRegularExpressionOptions())

var comments:[Comment] = []
let anonymouseSession = Session()
var counter = 0
let numberOfLinks = 20
do {
//    return
    try anonymouseSession.getList(Paginator(), subreddit: nil, sort: .Controversial, timeFilterWithin: .Week) { (result) -> Void in
        switch result {
        case .Failure(let error):
            print(error)
        case .Success(let listing):
            let links:[Link] = listing.children.flatMap { $0 as? Link }
            for i in 0...numberOfLinks - 1 {
                let link = links[i]
                try! anonymouseSession.getArticles(link, sort:CommentSort.New, comments:nil, completion: { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error)
                    case .Success(let listing1, let listing2):
                        var regs:[NSRegularExpression] = []
                        let patterns = ["\\^", "\\[|\\]", "/", "\\(|\\)", "\\*", "~", "&"]
                        
                        patterns.forEach({ (pattern) -> () in
                            regs.append(try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions()))
                        })
                
                        var newComments:[Comment] = listing2.children.flatMap({$0 as? Comment})
                        
                
                        comments.appendContentsOf(newComments)
                        
                        do {
                            counter = counter + 1
                            if counter == numberOfLinks {
                                
                                var buf:[Comment] = []
                                regs.forEach({ (reg) -> () in
                                    var appendCounter = 0
                                    for i in 0...comments.count - 1 {
                                        let comment = comments[i]
                                        if (reg.firstMatchInString(comment.body, options: NSMatchingOptions(), range: NSMakeRange(0, comment.body.characters.count)) != nil) {
                                            buf.append(comment)
                                            appendCounter = appendCounter + 1
                                            if appendCounter > 5 {
                                                break
                                            }
                                        }
                                    }
                                })
                                
                                let unique = buf.reduce([Comment]()) { (var current:[Comment], comment:Comment) -> [Comment] in
                                    if current.count == 0 {
                                        return [comment]
                                    }
                                    for i in 0...current.count - 1 {
                                        if current[i].id == comment.id || current[i].body == comment.body {
                                            return current
                                        }
                                    }
                                    current.append(comment)
                                    return current
                                }
                                
                                var array:[String] = []
                                unique.forEach({ (comment) -> () in
                                    array.append(comment.body)
                                })
                                
                                let data = try NSJSONSerialization.dataWithJSONObject(array, options: NSJSONWritingOptions())
                                let str = String(data: data, encoding: NSUTF8StringEncoding)!
                                print(str)
                            }
                        }
                        catch { print(error) }
                    }
                })
            }
        }
    }
}
catch { print(error) }

XCPSetExecutionShouldContinueIndefinitely()
