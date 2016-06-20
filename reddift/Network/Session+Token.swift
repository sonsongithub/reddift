//
//  Session+Token.swift
//  reddift
//
//  Created by sonson on 2015/09/21.
//  Copyright © 2015年 sonson. All rights reserved.
//

import Foundation

extension Session {
    /**
    Refresh own token.
    
    - parameter completion: The completion handler to call when the load request is complete.
    */
    public func refreshToken(completion:(Result<Token>) -> Void) throws -> Void {
        guard let currentToken = token as? OAuth2Token
            else { throw ReddiftError.TokenNotfound.error }
        do {
            try currentToken.refresh(completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    completion(Result(error:error as NSError))
                case .Success(let newToken):
                    DispatchQueue.main.asynchronously(execute: { () -> Void in
                        self.token = newToken
                        do {
                            try OAuth2TokenRepository.saveIntoKeychainToken(token: newToken)
                            completion(Result(value: newToken))
                        }
                        catch { completion(Result(error:error as NSError)) }
                    })
                }
            })
        }
        catch { throw error }
    }
    
    /**
    Revoke own token. After calling this function, this object must be released becuase it has lost any conection.
    
    - parameter completion: The completion handler to call when the load request is complete.
    */
    public func revokeToken(completion:(Result<Token>) -> Void) throws -> Void {
        guard let currentToken = token as? OAuth2Token
            else { throw ReddiftError.TokenNotfound.error }
        do {
            try currentToken.revoke(completion: { (result) -> Void in
                switch result {
                case .Failure(let error):
                    completion(Result(error:error as NSError))
                case .Success:
                    DispatchQueue.main.asynchronously(execute: { () -> Void in
                        do {
                            try OAuth2TokenRepository.removeFromKeychainTokenWithName(name: currentToken.name)
                            completion(Result(value: currentToken))
                        }
                        catch { completion(Result(error:error as NSError)) }
                    })
                }
            })
        }
        catch { throw error }
    }
}
