//
//  Result.swift
//  reddift
//
//  Created by sonson on 2015/05/06.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

public enum Result<A> {
    case Success(A)
    case Failure(NSError)
    
    public init(value:A) {
        self = .Success(value)
    }
    
    public init(error: NSError?) {
        if let error = error {
            self = .Failure(error)
        }
        else {
            self = .Failure(NSError.errorWithCode(code: 0, "Fatal error"))
        }
    }
    
    func package<B>(@noescape ifSuccess: (A) -> B, @noescape ifFailure: (NSError) -> B) -> B {
        switch self {
        case .Success(let value):
            return ifSuccess(value)
        case .Failure(let value):
            return ifFailure(value)
        }
    }
    
    func map<B>(@noescape transform: (A) -> B) -> Result<B> {
        return flatMap { .Success(transform($0)) }
    }
    
    public func flatMap<B>(@noescape transform: (A) -> Result<B>) -> Result<B> {
        return package(
            ifSuccess: transform,
            ifFailure: Result<B>.Failure)
    }
    
    public var error: NSError? {
        switch self {
        case .Failure(let error):
            return error
        default:
            return nil
        }
    }
    
    public var value: A? {
        switch self {
        case .Success(let success):
            return success
        default:
            return nil
        }
    }
}

public func resultFromOptional<A>(optional: A?, error: NSError) -> Result<A> {
    if let a = optional {
        return .Success(a)
    } else {
        return .Failure(error)
    }
}

public func resultFromOptionalError<A>(value: A, optionalError: NSError?) -> Result<A> {
    if let error = optionalError {
        return .Failure(error)
    } else {
        return .Success(value)
    }
}
