// Playground to create test data

import Cocoa
import PlaygroundSupport
import reddift
//
//print("a_aaa".camelCased(givenSeparators: ["_"]))
//
//func download_t2(with session: Session) throws -> Data {
//    do {
//        let task = try session.getUserProfile("sonson_twit", completion: { (result) -> Void in })
//        let data = try downloadRawData(with: task)
//        if let _ = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//            return data
//        } else {
//            throw NSError.error(with: "It's not an expected JSON object.")
//        }
//    } catch { throw error }
//}
//
//do {
//    let rootPath = try getRootPath()
//    let testPath = try getPath(for: "test.json")
//    let session = try setupSession()
//    let data = try download_t2(with: session)
//    let dataEntry = try createDataEntry(from: data)
////    dataEntry.keys.forEach({ print($0.camelCasedWithUnderbarSeparator())})
//    dataEntry.keys.forEach({
//        print(dataEntry[$0])
//        if let flag = dataEntry[$0] as? Bool {
//            print("let \($0.camelCasedWithUnderbarSeparator()): Bool")
//        }
//        if let numi = dataEntry[$0] as? Int {
//            print("let \($0.camelCasedWithUnderbarSeparator()): Int")
//        }
//        if let numf = dataEntry[$0] as? Float {
//            print("let \($0.camelCasedWithUnderbarSeparator()): Float")
//        }
//        if let str = dataEntry[$0] as? String {
//            print("let \($0.camelCasedWithUnderbarSeparator()): String")
//        }
//    })
//    let binary = try createDataEntryBinary(from: data)
//    try binary.write(to: testPath)
//} catch {
//    print(error)
//}

private let detector: NSRegularExpression! = {
    do {
        return try NSRegularExpression(pattern: "<\\/a>(\\w+)[\\w\\(\\)\\|\\s]*?<\\/h3>\\s+<table>(.*?)<\\/table>", options: .dotMatchesLineSeparators)
    } catch {
        assert(false, "Fatal error: \(#file) \(#line) \(error)")
        return nil
    }
}()

private let entryDetector: NSRegularExpression! = {
    do {
        return try NSRegularExpression(pattern: "<tr>\\s<td align=\"left\">(.+?)<\\/td>\\s<td align=\"left\">(.+?)<\\/td>\\s<td align=\"left\">(.+?)<\\/td>\\s<\\/tr>", options: .dotMatchesLineSeparators)
    } catch {
        assert(false, "Fatal error: \(#file) \(#line) \(error)")
        return nil
    }
}()

private let tagDetector: NSRegularExpression! = {
    do {
        return try NSRegularExpression(pattern: "<.+?>", options: [])
    } catch {
        assert(false, "Fatal error: \(#file) \(#line) \(error)")
        return nil
    }
}()

extension String {
    
    func removeHTMLTag() -> String {
        return self.replacingOccurrences(of: "<.+?>", with: "", options: .regularExpression, range: self.startIndex..<self.endIndex)
    }
}

print(Date(timeIntervalSinceNow: 0))
guard let apiUrl = URL(string: "https://github.com/reddit/reddit/wiki/JSON") else { abort() }
let request = URLRequest(url: apiUrl)
let task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
    if let data = data {
        if let str = String(data: data, encoding: .utf8) {
            let source: [(String, String)] = detector.matches(in: str, options: [], range: NSRange(location: 0, length: str.characters.count))
            .map({
                let title = (str as NSString).substring(with: $0.rangeAt(1))
                let html = (str as NSString).substring(with: $0.rangeAt(2))
                return (title, html)
            })
            let r: [[(String, String, String)]] = source.map({ (title, html) -> [(String, String, String)] in
                let entries: [(String, String, String)] = entryDetector.matches(in: html, options: [], range: NSRange(location: 0, length: html.characters.count))
                .map({
                    let type = (html as NSString).substring(with: $0.rangeAt(1)).removeHTMLTag()
                    let name = (html as NSString).substring(with: $0.rangeAt(2)).removeHTMLTag()
                    let description = (html as NSString).substring(with: $0.rangeAt(3)).removeHTMLTag()
                    return (type, name, description)
                })
                return entries
            })
            let b = r.flatMap({$0})
            print(b)
        }
    }
})
task.resume()

PlaygroundPage.current.needsIndefiniteExecution = true
