//: Playground - noun: a place where people can play

import Foundation
import reddift
import XCPlayground


func getCAPTCHA(session:Session) {
    session.getCAPTCHA({ (result:Result<CAPTCHA>) -> Void in
        switch result {
        case let .Failure:
            println(result.error!.description)
        case let .Success:
            if let captcha:CAPTCHA = result.value {
                let img:UIImage = captcha.image
            }
        }
    })
}

func getReleated(session:Session) {
    session.getDuplicatedArticles(Paginator(), thing: Link(id: "37lhsm")) { (result) -> Void in
        switch result {
        case let .Failure:
            println(result.error!.description)
        case let .Success:
            println(result.value!)
            if let array = result.value as? [RedditAny] {
                println(array[0])
                println(array[1])
                if let listing = array[0] as? Listing {
                    for obj in listing.children {
                        if let link = obj as? Link {
                            println(link.title)
                        }
                    }
                }
                if let listing = array[1] as? Listing {
                    println(listing.children.count)
                    for obj in listing.children {
                        if let link = obj as? Link {
                            println(link.title)
                        }
                    }
                }
            }
        }
    }
}

func getProfile(session:Session) {
    session.getUserProfile("sonson_twit", completion: { (result) -> Void in
        switch result {
        case let .Failure:
            println(result.error!.description)
        case let .Success:
            if let account = result.value as? Account {
                println(account.name)
            }
        }
    })
}

func getLinksBy(session:Session) {
    let links:[Link] = [Link(id: "37ow7j"), Link(id: "37nvgu")]
    session.getLinksById(links, completion: { (result) -> Void in
        switch result {
        case let .Failure:
            println(result.error!.description)
        case let .Success:
            if let listing = result.value as? Listing {
                println(listing.children.count)
                for obj in listing.children {
                    if let link = obj as? Link {
                        println(link.title)
                    }
                }
            }
        }
    })
}

func getList(session:Session) {
    var subreddit = Subreddit(id: "a")
//    subreddit.displayName = "sandboxtest"
    session.getRandom(subreddit, completion: { (result) in
        switch result {
        case let .Failure:
            println(result.error)
        case let .Success:
            println(result.value)
        }
    })
}

let url: NSURL = NSBundle.mainBundle().URLForResource("test_config.json", withExtension:nil)!
let data = NSData(contentsOfURL: url)!
let json:AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions())

if let json = json as? [String:String] {
    if let username = json["username"],
        let password = json["password"],
        let clientID = json["client_id"],
        let secret = json["secret"] {
            OAuth2AppOnlyToken.getOAuth2AppOnlyToken(username: username, password: password, clientID: clientID, secret: secret, completion:( { (result:Result<Token>) -> Void in
                switch result {
                case let .Failure:
                    println(result.error)
                case let .Success:
                    println(result.value)
                    if let token:Token = result.value {
                        let session = Session(token: token)
                        getList(session)
                    }
                }
            }))
    }
}

XCPSetExecutionShouldContinueIndefinitely()
