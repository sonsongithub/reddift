//: Playground - noun: a place where people can play

import Foundation
import XCPlayground
import reddift

guard #available(iOS 9, OSX 10.11, *) else { abort() }

//func getCAPTCHA(session:Session) {
//    session.getCAPTCHA({ (result:Result<CAPTCHA>) -> Void in
//        switch result {
//        case .Failure:
//            print(result.error!.description)
//        case .Success:
//            if let captcha:CAPTCHA = result.value {
//                let img:UIImage = captcha.image
//                print(img)
//            }
//        }
//    })
//}

func getReleated(session:Session) {
    session.getDuplicatedArticles(Paginator(), thing: Link(id: "37lhsm")) { (result) -> Void in
        switch result {
        case .Failure:
            print(result.error!.description)
        case .Success(let (listing1, listing2)):
            print(listing1)
            print(listing2)
//            if let array = result.value as? [RedditAny] {
//                print(array[0])
//                print(array[1])
//                if let listing = array[0] as? Listing {
//                    for obj in listing.children {
//                        if let link = obj as? Link {
//                            print(link.title)
//                        }
//                    }
//                }
//                if let listing = array[1] as? Listing {
//                    print(listing.children.count)
//                    for obj in listing.children {
//                        if let link = obj as? Link {
//                            print(link.title)
//                        }
//                    }
//                }
//            }
        }
    }
}

func getProfile(session:Session) {
    session.getUserProfile("sonson_twit", completion: { (result) -> Void in
        switch result {
        case .Failure:
            print(result.error!.description)
        case .Success(let account):
            print(account.name)
        }
    })
}

func getLinksBy(session:Session) {
    let links:[Link] = [Link(id: "37ow7j"), Link(id: "37nvgu")]
    session.getLinksById(links, completion: { (result) -> Void in
        switch result {
        case .Failure:
            print(result.error!.description)
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

let url: NSURL = NSBundle.mainBundle().URLForResource("test_config.json", withExtension:nil)!
let data = NSData(contentsOfURL: url)!
var json:AnyObject? = nil
do {
    json = try NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions())
    
    if let json = json as? [String:String] {
        if let username = json["username"],
            let password = json["password"],
            let clientID = json["client_id"],
            let secret = json["secret"] {
                OAuth2AppOnlyToken.getOAuth2AppOnlyToken(username: username, password: password, clientID: clientID, secret: secret, completion:( { (result:Result<Token>) -> Void in
                    switch result {
                    case .Failure:
                        print(result.error)
                    case .Success:
                        print(result.value)
                        if let token:Token = result.value {
                            let session = Session(token: token)
                            getLinksBy(session)
                            getReleated(session)
                        }
                    }
                }))
        }
    }
}
catch {
}

XCPSetExecutionShouldContinueIndefinitely()
