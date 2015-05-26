//
//  Result.swift
//  reddift
//
//  Created by sonson on 2015/05/06.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

public enum Thing {
    case CommentType(Comment)
    case LinkType(Link)
    case MessageType(Message)
    case MoreType(More)
    case SubredditType(Subreddit)
    case ListingType(Listing)
    case MultiredditType(Multireddit)
    case MultiredditDescriptionType(MultiredditDescription)
    case AccountType(Account)
    case ArrayType([Thing])
    
    public init(_ comment:Comment) {
        self = .CommentType(comment)
    }
    public init(_ link:Link) {
        self = .LinkType(link)
    }
    public init(_ message:Message) {
        self = .MessageType(message)
    }
    public init(_ more:More) {
        self = .MoreType(more)
    }
    public init(_ subreddit:Subreddit) {
        self = .SubredditType(subreddit)
    }
    public init(_ listing:Listing) {
        self = .ListingType(listing)
    }
    public init(_ multireddit:Multireddit) {
        self = .MultiredditType(multireddit)
    }
    public init(_ multiredditdescription:MultiredditDescription) {
        self = .MultiredditDescriptionType(multiredditdescription)
    }
    public init(_ account:Account) {
        self = .AccountType(account)
    }
    public init(_ array:[Thing]) {
        self = .ArrayType(array)
    }
    
    public var comment:Comment? {
        switch self {
        case .CommentType(let comment):
            return comment
        default:
            return nil
        }
    }
    public var link:Link? {
        switch self {
        case .LinkType(let link):
            return link
        default:
            return nil
        }
    }
    public var message:Message? {
        switch self {
        case .MessageType(let message):
            return message
        default:
            return nil
        }
    }
    public var more:More? {
        switch self {
        case .MoreType(let more):
            return more
        default:
            return nil
        }
    }
    public var subreddit:Subreddit? {
        switch self {
        case .SubredditType(let subreddit):
            return subreddit
        default:
            return nil
        }
    }
    public var listing:Listing? {
        switch self {
        case .ListingType(let listing):
            return listing
        default:
            return nil
        }
    }
    public var multireddit:Multireddit? {
        switch self {
        case .MultiredditType(let multireddit):
            return multireddit
        default:
            return nil
        }
    }
    public var multiredditdescription:MultiredditDescription? {
        switch self {
        case .MultiredditDescriptionType(let multiredditdescription):
            return multiredditdescription
        default:
            return nil
        }
    }
    public var account:Account? {
        switch self {
        case .AccountType(let account):
            return account
        default:
            return nil
        }
    }
    public var array:[Thing]? {
        switch self {
        case .ArrayType(let array):
            return array
        default:
            return nil
        }
    }
}

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