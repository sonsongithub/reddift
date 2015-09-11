//: Playground - noun: a place where people can play

import Foundation
import XCPlayground
import reddift

guard #available(iOS 9, OSX 10.11, *) else { abort() }

func getCAPTCHA(session:Session) {
    session.getCAPTCHA({ (result) -> Void in
        switch result {
        case .Failure(let error):
            print(error.description)
        case .Success(let captchaImage):
            captchaImage
        }
    })
}

func getReleated(session:Session) {
    session.getDuplicatedArticles(Paginator(), thing: Link(id: "37lhsm")) { (result) -> Void in
        switch result {
        case .Failure(let error):
            print(error.description)
        case .Success(let (listing1, listing2)):
            for obj in listing1.children {
                if let link = obj as? Link {
                    print(link.title)
                }
            }
            for obj in listing2.children {
                if let link = obj as? Link {
                    print(link.title)
                }
            }
        }
    }
}

func getProfile(session:Session) {
    session.getUserProfile("sonson_twit", completion: { (result) -> Void in
        switch result {
        case .Failure(let error):
            print(error.description)
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
            print(error.description)
        case .Success(let listing):
            print(listing.children.count)
            for obj in listing.children {
                if let link = obj as? Link {
                    print(link.title)
                }
            }
        }
    })
}

let values = NSBundle.mainBundle().URLForResource("test_config.json", withExtension:nil)
    .flatMap { (url) -> NSData? in
        return NSData(contentsOfURL: url)
    }.flatMap { (data) -> [String:String]? in
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions()) as? [String:String] {
                return json
            }
            return nil
        } catch { return nil }
    }.flatMap { (json) -> (String, String, String, String)? in
        if let username = json["username"],
            password = json["password"],
            client_id = json["client_id"],
            secret = json["secret"] {
            return (username, password, client_id, secret)
        }
        return nil
    }

if let values = values {
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
        for child in listing.children {
            if let link = child as? Link {
                print(link.title)
            }
        }
    }
}

XCPSetExecutionShouldContinueIndefinitely()
