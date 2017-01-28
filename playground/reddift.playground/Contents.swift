
import Cocoa
import PlaygroundSupport
import reddift

func getReleated(with session: Session) {
    do {
        try session.getDuplicatedArticles(Paginator(), thing: Link(id: "37lhsm")) { (result) -> Void in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let listing1, let listing2):
                listing1.children.flatMap { $0 as? Link }.forEach { print($0.title) }
                listing2.children.flatMap { $0 as? Link }.forEach { print($0.title) }
            }
        }
    } catch { print(error) }
}

func getProfile(with session: Session) {
    do {
        try session.getUserProfile("sonson_twit", completion: { (result) -> Void in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let account):
                print(account.name)
            }
        })
    } catch { print(error) }
}

func getLinksBy(with session: Session) {
    do {
        let links = [Link(id: "37ow7j"), Link(id: "37nvgu")]
        try session.getLinksById(links, completion: { (result) -> Void in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let listing):
                listing.children.flatMap { $0 as? Link }.forEach { print($0.title) }
            }
        })
    } catch { print(error) }
}

func searchSubreddits(with session: Session) {
    do {
        try session.getSubredditSearch("apple", paginator: Paginator(), completion: { (result) -> Void in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let listing):
                listing.children.flatMap { $0 as? Subreddit }.forEach { print($0.title) }
            }
        })
    } catch { print(error) }
}

func searchContents(with session: Session) {
    do {
        try session.getSearch(nil, query: "apple", paginator: Paginator(), sort: .new, completion: { (result) -> Void in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let listing):
                listing.children.flatMap { $0 as? Link }.forEach { print($0.title) }
            }
        })
    } catch { print(error) }
}

func getAccountInfo(from json: [String:String]) -> (String, String, String, String)? {
    if let username = json["username"], let password = json["password"], let client_id = json["client_id"], let secret = json["secret"] {
        return (username, password, client_id, secret)
    }
    return nil
}

func getSubreddits(with session: Session) {
    do {
        try session.getSubreddit(.new, paginator: nil, completion: { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let listing):
                let _ = listing.children.flatMap({ $0 as? Subreddit })
            }
        })
    } catch { print(error) }
}

func loadAccount() -> (String, String, String, String)? {
    return (Bundle.main.url(forResource: "test_config.json", withExtension:nil)
        .flatMap { (url) -> Data? in
            do {
                return try Data(contentsOf: url)
            } catch { return nil }
        }
        .flatMap {
            do {
                return try JSONSerialization.jsonObject(with: $0, options:[]) as? [String:String]
            } catch { return nil }
        }
        .flatMap { getAccountInfo(from: $0) })
}

if let (username, password, clientID, secret) = loadAccount() {
    do {
        try OAuth2AppOnlyToken.getOAuth2AppOnlyToken(username: username, password: password, clientID: clientID, secret: secret, completion:({ (result) -> Void in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let token):
                let session = Session(token: token)
                getProfile(with: session)
                getSubreddits(with: session)
                getLinksBy(with: session)
                getReleated(with: session)
                searchContents(with: session)
                searchSubreddits(with: session)
            }
        }))
    } catch { print(error) }
}

let anonymouseSession = Session()
getSubreddits(with: anonymouseSession)
getLinksBy(with: anonymouseSession)

PlaygroundPage.current.needsIndefiniteExecution = true

    
