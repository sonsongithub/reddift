//
//  Result.swift
//  reddift
//
//  Created by sonson on 2015/05/06.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

public enum Result<A> {
    case success(A)
    case failure(NSError)
    
    public init(value: A) {
        self = .success(value)
    }
    
    public init(error: NSError?) {
        if let error = error {
            self = .failure(error)
        } else {
            self = .failure(NSError.errorWithCode(0, "Fatal error"))
        }
    }
    
    func package<B>(ifSuccess: (A) -> B, ifFailure: (NSError) -> B) -> B {
        switch self {
        case .success(let value):
            return ifSuccess(value)
        case .failure(let value):
            return ifFailure(value)
        }
    }
    
    func map<B>(_ transform: (A) -> B) -> Result<B> {
        return flatMap { .success(transform($0)) }
    }
    
    public func flatMap<B>(_ transform: (A) -> Result<B>) -> Result<B> {
        return package(
            ifSuccess: transform,
            ifFailure: Result<B>.failure)
    }
    
    public var error: NSError? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
    
    public var value: A? {
        switch self {
        case .success(let success):
            return success
        default:
            return nil
        }
    }
}

public func resultFromOptional<A>(_ optional: A?, error: NSError) -> Result<A> {
    if let a = optional {
        return .success(a)
    } else {
        return .failure(error)
    }
}

public func resultFromOptionalError<A>(_ value: A, optionalError: NSError?) -> Result<A> {
    if let error = optionalError {
        return .failure(error)
    } else {
        return .success(value)
    }
}
