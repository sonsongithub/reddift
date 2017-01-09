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

guard let apiUrl = URL(string: "https://github.com/reddit/reddit/wiki/JSON") else { abort() }
let request = URLRequest(url: apiUrl)
let task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
    if let data = data {
        if let str = String(data: data, encoding: .utf8) {
            print(str)
        }
    }
})
task.resume()

PlaygroundPage.current.needsIndefiniteExecution = true