//: Playground - noun: a place where people can play

import Foundation
import XCPlayground
import reddift

guard #available(iOS 9, OSX 10.10, *) else { abort() }

func getCAPTCHA(session:Session) {
    session.getCAPTCHA({ (result) -> Void in
        switch result {
        case .Failure(let error):
            print(error)
        case .Success(let captchaImage):
            captchaImage
        }
    })
}

func getReleated(session:Session) {
    session.getDuplicatedArticles(Paginator(), thing: Link(id: "37lhsm")) { (result) -> Void in
        switch result {
        case .Failure(let error):
            print(error)
        case .Success(let listing1, let listing2):
            listing1.children.flatMap { $0 as? Link }.forEach { print($0.title) }
            listing2.children.flatMap { $0 as? Link }.forEach { print($0.title) }
        }
    }
}

func getProfile(session:Session) {
    session.getUserProfile("sonson_twit", completion: { (result) -> Void in
        switch result {
        case .Failure(let error):
            print(error)
        case .Success(let account):
            print(account.name)
        }
    })
}

func getLinksBy(session:Session) {
    let links:[Link] = [Link(id: "37ow7j"), Link(id: "37nvgu")]
    session.getLinksById(links, completion: { (result) -> Void in
        switch result {
        case .Failure(let error):
            print(error)
        case .Success(let listing):
            listing.children.flatMap { $0 as? Link }.forEach { print($0.title) }
        }
    })
}

func getAccountInfoFromJSON(json:[String:String]) -> (String, String, String, String)? {
    if let username = json["username"], password = json["password"], client_id = json["client_id"], secret = json["secret"] {
        return (username, password, client_id, secret)
    }
    return nil
}

if let values = (NSBundle.mainBundle().URLForResource("test_config.json", withExtension:nil)
    .flatMap { NSData(contentsOfURL: $0) }
    .flatMap { try! NSJSONSerialization.JSONObjectWithData($0, options:NSJSONReadingOptions()) as? [String:String] }
    .flatMap { getAccountInfoFromJSON($0) }) {
        OAuth2AppOnlyToken.getOAuth2AppOnlyToken(username: values.0, password: values.1, clientID: values.2, secret: values.3, completion:( { (result) -> Void in
            switch result {
            case .Failure(let error):
                print(error)
            case .Success(let token):
                let session = Session(token: token)
                getLinksBy(session)
                getReleated(session)
                getCAPTCHA(session)
            }
        }))
}

let anonymouseSession = Session()
anonymouseSession.getList(Paginator(), subreddit: nil, sort: .Controversial, timeFilterWithin: .Week) { (result) -> Void in
    switch result {
    case .Failure(let error):
        print(error)
    case .Success(let listing):
        listing.children.flatMap { $0 as? Link }.forEach { print($0.title) }
    }
}

XCPSetExecutionShouldContinueIndefinitely()
