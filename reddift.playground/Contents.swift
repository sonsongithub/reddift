//: Playground - noun: a place where people can play

import Foundation
import reddift
import XCPlayground

XCPSetExecutionShouldContinueIndefinitely()

let url: NSURL = NSBundle.mainBundle().URLForResource("test_config.json", withExtension:nil)!
let data = NSData(contentsOfURL: url)!
let json:AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.allZeros, error: nil)

println(json)

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
                        hoge(session)
                    }
                }
            }))
    }
}

func hoge(session:Session) {
    println(session.token)
}