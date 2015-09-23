//: Playground - noun: a place where people can play

import Foundation
import XCPlayground
import reddift


var comments:[String] = []
let anonymouseSession = Session()
var counter = 0
do {
    try anonymouseSession.getList(Paginator(), subreddit: nil, sort: .Controversial, timeFilterWithin: .Week) { (result) -> Void in
        switch result {
        case .Failure(let error):
            print(error)
        case .Success(let listing):
            let links:[Link] = listing.children.flatMap { $0 as? Link }
            print(links.count)
            for i in 0...24 {
                let link = links[i]
                try! anonymouseSession.getArticles(link, sort:CommentSort.New, comments:nil, completion: { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error)
                    case .Success(let listing1, let listing2):
                        var newComments:[String] = listing2.children.flatMap({$0 as? Comment}).map({$0.body})
                        comments.appendContentsOf(newComments)
                        
                        do {
                            let data = try NSJSONSerialization.dataWithJSONObject(comments, options: NSJSONWritingOptions())
                            let str = String(data: data, encoding: NSUTF8StringEncoding)!
                            counter = counter + 1
                            if counter == 25 {
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