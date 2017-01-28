//
// This file (and all other Swift source files in the Sources directory of this playground) will be precompiled into a framework which is automatically made available to reddift.playground.
//

import Foundation
import reddift

extension NSError {
    public class func error(with description: String) -> NSError {
        return NSError(domain: "com.sonson.reddift", code: 1, userInfo: ["description": description])
    }
}

public func getRootPath() throws -> URL {
    if let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
        return URL(fileURLWithPath: documentsDirectoryPath)
    }
    throw NSError.error(with: "System error, can not get root path.")
}

public func getPath(for filename: String) throws -> URL {
    if let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
        let path = documentsDirectoryPath + "/" + filename
        return URL(fileURLWithPath: path)
    }
    throw NSError.error(with: "System error, can not get root path.")
}

extension String {
    private var onlyFirstCharacterUppercased: String {
        let chars = characters
        guard let firstChar = chars.first else { return self }
        return String(firstChar).uppercased() + String(chars.dropFirst()).lowercased()
    }
    
    public func camelCased(givenSeparators separators: [Character]) -> String {
        let charChunks = characters.split { separators.contains($0) }
        guard let firstChunk = charChunks.first else { return self }
        return String(firstChunk).lowercased() + charChunks.dropFirst()
            .map { String($0).onlyFirstCharacterUppercased }.joined()
    }
    
    public func camelCasedWithUnderbarSeparator() -> String {
        return camelCased(givenSeparators: ["_"])
    }
}

func getAccountInfo(from json: [String:String]) -> (String, String, String, String)? {
    if let username = json["username"], let password = json["password"], let client_id = json["client_id"], let secret = json["secret"] {
        return (username, password, client_id, secret)
    }
    return nil
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

public func setupSession() throws -> Session {
    var resultSession:Session? = nil
    let semaphore = DispatchSemaphore(value: 0)
    if let (username, password, clientID, secret) = loadAccount() {
        do {
            try OAuth2AppOnlyToken.getOAuth2AppOnlyToken(username: username, password: password, clientID: clientID, secret: secret, completion:({ (result) -> Void in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let token):
                    resultSession = Session(token: token)
                }
                semaphore.signal()
            }))
        } catch { print(error) }
    }
    semaphore.wait()
    if let session = resultSession { return session }
    throw NSError.error(with: "Unknown error, can not create session object.")
}

public func downloadRawData(with existingTask: URLSessionDataTask) throws -> Data {
    var result: Data? = nil
    var resultError: Error? = nil
    let semaphore = DispatchSemaphore(value: 0)
    if let request = existingTask.originalRequest {
        let task = URLSession(configuration: URLSessionConfiguration.default).dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            do {
                if let data = data, let _ = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    result = data
                }
            } catch {
                resultError = error
            }
            semaphore.signal()
        })
        task.resume()
    }
    semaphore.wait()
    if let error = resultError {
        throw error
    }
    if let result = result {
        return result
    } else {
        throw NSError.error(with: "Unknown error, can not download any data.")
    }
}

public func extractDataEntry(from json: [String: Any]) throws -> [String: Any] {
    guard let dataEntry = json["data"] as? [String: Any] else { throw NSError(domain: "com.sonson.reddift", code: 0, userInfo: [:]) }
    return dataEntry
}

public func createDataEntry(from data: Data) throws -> [String: Any] {
    do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return try extractDataEntry(from: json)
        } else {
            throw NSError.error(with: "It's not an expected JSON object.")
        }
    } catch {
        throw error
    }
}

public func createDataEntryBinary(from data: Data) throws -> Data {
    do {
        let dataEntry = try createDataEntry(from: data)
        return try JSONSerialization.data(withJSONObject: dataEntry, options: [])
    } catch {
        throw error
    }
}
