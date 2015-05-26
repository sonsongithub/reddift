//
//  Result.swift
//  reddift
//
//  Created by sonson on 2015/05/06.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

public final class Box<A> {
    public let value: A
    public init(_ value: A) {
        self.value = value
    }
}

public enum Result<A> {
    case Success(Box<A>)
    case Failure(NSError)
    
    public init(value:A) {
        self = .Success(Box(value))
    }
    
    public init(error: NSError) {
        self = .Failure(error)
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
            return success.value
        default:
            return nil
        }
    }
}

public func resultFromOptional<A>(optional: A?, error: NSError) -> Result<A> {
    if let a = optional {
        return .Success(Box(a))
    } else {
        return .Failure(error)
    }
}

public func resultFromOptionalError<A>(value: A, optionalError: NSError?) -> Result<A> {
    if let error = optionalError {
        return .Failure(error)
    } else {
        return .Success(Box(value))
    }
}

infix operator >>> { associativity left precedence 150 }

public func >>><A, B>(a: Result<A>, f: A -> Result<B>) -> Result<B> {
    switch a {
    case let .Success(x):     return f(x.value)
    case let .Failure(error): return .Failure(error)
    }
}