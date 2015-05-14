//
//  HttpStatus.swift
//  reddift
//
//  Created by HttpStatusGenerator.rb
//  Generated from wikipedia http://en.wikipedia.org/wiki/List_of_HTTP_status_codes
//
//  https://gist.github.com/sonsongithub/2fc372c869abfdb2719b
//

import Foundation

enum HttpStatus:Int {
    case Continue = 100
    case SwitchingProtocols = 101
    case Processing = 102
    case OK = 200
    case Created = 201
    case Accepted = 202
    case NonAuthoritativeInformation = 203
    case NoContent = 204
    case ResetContent = 205
    case PartialContent = 206
    case MultiStatus = 207
    case AlreadyReported = 208
    case IMUsed = 226
    case MultipleChoices = 300
    case NotModified = 304
    case UseProxy = 305
    case SwitchProxy = 306
    case TemporaryRedirect = 307
    case PermanentRedirect = 308
    case BadRequest = 400
    case Unauthorized = 401
    case PaymentRequired = 402
    case Forbidden = 403
    case NotFound = 404
    case MethodNotAllowed = 405
    case NotAcceptable = 406
    case ProxyAuthenticationRequired = 407
    case RequestTimeout = 408
    case Conflict = 409
    case Gone = 410
    case LengthRequired = 411
    case PreconditionFailed = 412
    case RequestEntityTooLarge = 413
    case RequestURITooLong = 414
    case UnsupportedMediaType = 415
    case RequestedRangeNotSatisfiable = 416
    case ExpectationFailed = 417
    case ImATeapot = 418
    case AuthenticationTimeout = 419
    case MethodFailure = 420
    case MisdirectedRequest = 421
    case UnprocessableEntity = 422
    case Locked = 423
    case FailedDependency = 424
    case UpgradeRequired = 426
    case PreconditionRequired = 428
    case TooManyRequests = 429
    case RequestHeaderFieldsTooLarge = 431
    case LoginTimeout = 440
    case NoResponse = 444
    case RetryWith = 449
    case BlockedByWindowsParentalControls = 450
    case RequestHeaderTooLarge = 494
    case CertError = 495
    case NoCert = 496
    case HTTPToHTTPS = 497
    case TokenExpiredinvalid = 498
    case ClientClosedRequest = 499
    case InternalServerError = 500
    case NotImplemented = 501
    case BadGateway = 502
    case ServiceUnavailable = 503
    case GatewayTimeout = 504
    case HTTPVersionNotSupported = 505
    case VariantAlsoNegotiates = 506
    case InsufficientStorage = 507
    case LoopDetected = 508
    case BandwidthLimitExceeded = 509
    case NotExtended = 510
    case NetworkAuthenticationRequired = 511
    case NetworkReadTimeoutError = 598
    case NetworkConnectTimeoutError = 599
    case Unknown = -1
    
    init(_ statusCode:Int) {
        let status = HttpStatus(rawValue:statusCode)
        if let status:HttpStatus = status {
            self = status
        }
        else {
            self = .Unknown
        }
    }

    var error:NSError {
        return NSError.errorWithCode(self.rawValue, self.description)
    }

    var description:String {
        switch self{
        case .Continue:
            return "Continue"
        case .SwitchingProtocols:
            return "Switching Protocols"
        case .Processing:
            return "Processing"
        case .OK:
            return "OK"
        case .Created:
            return "Created"
        case .Accepted:
            return "Accepted"
        case .NonAuthoritativeInformation:
            return "Non-Authoritative Information"
        case .NoContent:
            return "No Content"
        case .ResetContent:
            return "Reset Content"
        case .PartialContent:
            return "Partial Content"
        case .MultiStatus:
            return "Multi-Status"
        case .AlreadyReported:
            return "Already Reported"
        case .IMUsed:
            return "IM Used"
        case .MultipleChoices:
            return "Multiple Choices"
        case .NotModified:
            return "Not Modified"
        case .UseProxy:
            return "Use Proxy"
        case .SwitchProxy:
            return "Switch Proxy"
        case .TemporaryRedirect:
            return "Temporary Redirect"
        case .PermanentRedirect:
            return "Permanent Redirect"
        case .BadRequest:
            return "Bad Request"
        case .Unauthorized:
            return "Unauthorized"
        case .PaymentRequired:
            return "Payment Required"
        case .Forbidden:
            return "Forbidden"
        case .NotFound:
            return "NotFound"
        case .MethodNotAllowed:
            return "Method Not Allowed"
        case .NotAcceptable:
            return "Not Acceptable"
        case .ProxyAuthenticationRequired:
            return "Proxy Authentication Required"
        case .RequestTimeout:
            return "Request Timeout"
        case .Conflict:
            return "Conflict"
        case .Gone:
            return "Gone"
        case .LengthRequired:
            return "Length Required"
        case .PreconditionFailed:
            return "Precondition Failed"
        case .RequestEntityTooLarge:
            return "Request Entity Too Large"
        case .RequestURITooLong:
            return "Request-URI Too Long"
        case .UnsupportedMediaType:
            return "Unsupported Media Type"
        case .RequestedRangeNotSatisfiable:
            return "Requested Range Not Satisfiable"
        case .ExpectationFailed:
            return "Expectation Failed"
        case .ImATeapot:
            return "I'm a teapot"
        case .AuthenticationTimeout:
            return "Authentication Timeout"
        case .MethodFailure:
            return "Method Failure"
        case .MisdirectedRequest:
            return "Misdirected Request"
        case .UnprocessableEntity:
            return "Unprocessable Entity"
        case .Locked:
            return "Locked"
        case .FailedDependency:
            return "Failed Dependency"
        case .UpgradeRequired:
            return "Upgrade Required"
        case .PreconditionRequired:
            return "Precondition Required"
        case .TooManyRequests:
            return "Too Many Requests"
        case .RequestHeaderFieldsTooLarge:
            return "Request Header Fields Too Large"
        case .LoginTimeout:
            return "Login Timeout"
        case .NoResponse:
            return "No Response"
        case .RetryWith:
            return "Retry With"
        case .BlockedByWindowsParentalControls:
            return "Blocked by Windows Parental Controls"
        case .RequestHeaderTooLarge:
            return "Request Header Too Large"
        case .CertError:
            return "Cert Error"
        case .NoCert:
            return "No Cert"
        case .HTTPToHTTPS:
            return "HTTP to HTTPS"
        case .TokenExpiredinvalid:
            return "Token expired/invalid"
        case .ClientClosedRequest:
            return "Client Closed Request"
        case .InternalServerError:
            return "Internal Server Error"
        case .NotImplemented:
            return "Not Implemented"
        case .BadGateway:
            return "Bad Gateway"
        case .ServiceUnavailable:
            return "Service Unavailable"
        case .GatewayTimeout:
            return "Gateway Timeout"
        case .HTTPVersionNotSupported:
            return "HTTP Version Not Supported"
        case .VariantAlsoNegotiates:
            return "Variant Also Negotiates"
        case .InsufficientStorage:
            return "Insufficient Storage"
        case .LoopDetected:
            return "Loop Detected"
        case .BandwidthLimitExceeded:
            return "Bandwidth Limit Exceeded"
        case .NotExtended:
            return "Not Extended"
        case .NetworkAuthenticationRequired:
            return "Network Authentication Required"
        case .NetworkReadTimeoutError:
            return "Network read timeout error"
        case .NetworkConnectTimeoutError:
            return "Network connect timeout error"
        default:
            return "HTTP Error - Unknown"
        }
    }
}
