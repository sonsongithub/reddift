//: Playground - noun: a place where people can play

import Foundation
import XCPlayground
import reddift

func doit(session: Session) {
    do {
        try session.getSubredditSearchWithErrorHandling("apple", paginator: Paginator(), completion: { (result) -> Void in
            switch result {
            case .Failure(let error):
                print(error)
            case .Success(let listing):
                listing.children.flatMap { $0 as? Subreddit }.forEach { print($0.title) }
            }
        })
    } catch { print(error) }
}

func getAccountInfoFromJSON(json: [String:String]) -> (String, String, String, String)? {
    if let username = json["username"], password = json["password"], client_id = json["client_id"], secret = json["secret"] {
        return (username, password, client_id, secret)
    }
    return nil
}

if let (username, password, clientID, secret) = (NSBundle.mainBundle().URLForResource("test_config.json", withExtension:nil)
    .flatMap { NSData(contentsOfURL: $0) }
    .flatMap { try! NSJSONSerialization.JSONObjectWithData($0, options:NSJSONReadingOptions()) as? [String:String] }
    .flatMap { getAccountInfoFromJSON($0) }) {
    do {
        try OAuth2AppOnlyToken.getOAuth2AppOnlyToken(username: username, password: password, clientID: clientID, secret: secret, completion:({ (result) -> Void in
            switch result {
            case .Failure(let error):
                print(error)
            case .Success(let token):
                let session = Session(token: token)
                doit(session)
            }
        }))
    } catch { print(error) }
}

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
