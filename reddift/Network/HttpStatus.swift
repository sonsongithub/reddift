enum HttpStatus {
    case Continue
    case SwitchingProtocols
    case Processing
    case OK
    case Created
    case Accepted
    case NonAuthoritativeInformation
    case NoContent
    case ResetContent
    case PartialContent
    case MultiStatus
    case AlreadyReported
    case IMUsed
    case MultipleChoices
    case NotModified
    case UseProxy
    case SwitchProxy
    case TemporaryRedirect
    case PermanentRedirect
    case BadRequest
    case Unauthorized
    case PaymentRequired
    case MethodNotAllowed
    case NotAcceptable
    case ProxyAuthenticationRequired
    case RequestTimeout
    case Conflict
    case Gone
    case LengthRequired
    case PreconditionFailed
    case RequestEntityTooLarge
    case RequestURITooLong
    case UnsupportedMediaType
    case RequestedRangeNotSatisfiable
    case ExpectationFailed
    case ImATeapot
    case AuthenticationTimeout
    case MethodFailure
    case MisdirectedRequest
    case UnprocessableEntity
    case Locked
    case FailedDependency
    case UpgradeRequired
    case PreconditionRequired
    case TooManyRequests
    case RequestHeaderFieldsTooLarge
    case LoginTimeout
    case NoResponse
    case RetryWith
    case BlockedByWindowsParentalControls
    case RequestHeaderTooLarge
    case CertError
    case NoCert
    case HTTPToHTTPS
    case TokenExpiredinvalid
    case ClientClosedRequest
    case InternalServerError
    case NotImplemented
    case BadGateway
    case ServiceUnavailable
    case GatewayTimeout
    case HTTPVersionNotSupported
    case VariantAlsoNegotiates
    case InsufficientStorage
    case LoopDetected
    case BandwidthLimitExceeded
    case NotExtended
    case NetworkAuthenticationRequired
    case NetworkReadTimeoutError
    case NetworkConnectTimeoutError
    case Unknown
    
    init(_ code:Int) {
        switch code {
            case 100:
                self = .Continue
            case 101:
                self = .SwitchingProtocols
            case 102:
                self = .Processing
            case 200:
                self = .OK
            case 201:
                self = .Created
            case 202:
                self = .Accepted
            case 203:
                self = .NonAuthoritativeInformation
            case 204:
                self = .NoContent
            case 205:
                self = .ResetContent
            case 206:
                self = .PartialContent
            case 207:
                self = .MultiStatus
            case 208:
                self = .AlreadyReported
            case 226:
                self = .IMUsed
            case 300:
                self = .MultipleChoices
            case 304:
                self = .NotModified
            case 305:
                self = .UseProxy
            case 306:
                self = .SwitchProxy
            case 307:
                self = .TemporaryRedirect
            case 308:
                self = .PermanentRedirect
            case 400:
                self = .BadRequest
            case 401:
                self = .Unauthorized
            case 402:
                self = .PaymentRequired
            case 405:
                self = .MethodNotAllowed
            case 406:
                self = .NotAcceptable
            case 407:
                self = .ProxyAuthenticationRequired
            case 408:
                self = .RequestTimeout
            case 409:
                self = .Conflict
            case 410:
                self = .Gone
            case 411:
                self = .LengthRequired
            case 412:
                self = .PreconditionFailed
            case 413:
                self = .RequestEntityTooLarge
            case 414:
                self = .RequestURITooLong
            case 415:
                self = .UnsupportedMediaType
            case 416:
                self = .RequestedRangeNotSatisfiable
            case 417:
                self = .ExpectationFailed
            case 418:
                self = .ImATeapot
            case 419:
                self = .AuthenticationTimeout
            case 420:
                self = .MethodFailure
            case 421:
                self = .MisdirectedRequest
            case 422:
                self = .UnprocessableEntity
            case 423:
                self = .Locked
            case 424:
                self = .FailedDependency
            case 426:
                self = .UpgradeRequired
            case 428:
                self = .PreconditionRequired
            case 429:
                self = .TooManyRequests
            case 431:
                self = .RequestHeaderFieldsTooLarge
            case 440:
                self = .LoginTimeout
            case 444:
                self = .NoResponse
            case 449:
                self = .RetryWith
            case 450:
                self = .BlockedByWindowsParentalControls
            case 494:
                self = .RequestHeaderTooLarge
            case 495:
                self = .CertError
            case 496:
                self = .NoCert
            case 497:
                self = .HTTPToHTTPS
            case 498:
                self = .TokenExpiredinvalid
            case 499:
                self = .ClientClosedRequest
            case 500:
                self = .InternalServerError
            case 501:
                self = .NotImplemented
            case 502:
                self = .BadGateway
            case 503:
                self = .ServiceUnavailable
            case 504:
                self = .GatewayTimeout
            case 505:
                self = .HTTPVersionNotSupported
            case 506:
                self = .VariantAlsoNegotiates
            case 507:
                self = .InsufficientStorage
            case 508:
                self = .LoopDetected
            case 509:
                self = .BandwidthLimitExceeded
            case 510:
                self = .NotExtended
            case 511:
                self = .NetworkAuthenticationRequired
            case 598:
                self = .NetworkReadTimeoutError
            case 599:
                self = .NetworkConnectTimeoutError
            default:
                self = .Unknown
        }
    }
    
    var error:NSError {
        get {
            return NSError.errorWithCode(self.code, self.description)
        }
    }

    var description:String {
        get {
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
                return "Unknown"
            }
        }
    }

    var code:Int {
        get {
            switch self {
            case .Continue:
                return 100
            case .SwitchingProtocols:
                return 101
            case .Processing:
                return 102
            case .OK:
                return 200
            case .Created:
                return 201
            case .Accepted:
                return 202
            case .NonAuthoritativeInformation:
                return 203
            case .NoContent:
                return 204
            case .ResetContent:
                return 205
            case .PartialContent:
                return 206
            case .MultiStatus:
                return 207
            case .AlreadyReported:
                return 208
            case .IMUsed:
                return 226
            case .MultipleChoices:
                return 300
            case .NotModified:
                return 304
            case .UseProxy:
                return 305
            case .SwitchProxy:
                return 306
            case .TemporaryRedirect:
                return 307
            case .PermanentRedirect:
                return 308
            case .BadRequest:
                return 400
            case .Unauthorized:
                return 401
            case .PaymentRequired:
                return 402
            case .MethodNotAllowed:
                return 405
            case .NotAcceptable:
                return 406
            case .ProxyAuthenticationRequired:
                return 407
            case .RequestTimeout:
                return 408
            case .Conflict:
                return 409
            case .Gone:
                return 410
            case .LengthRequired:
                return 411
            case .PreconditionFailed:
                return 412
            case .RequestEntityTooLarge:
                return 413
            case .RequestURITooLong:
                return 414
            case .UnsupportedMediaType:
                return 415
            case .RequestedRangeNotSatisfiable:
                return 416
            case .ExpectationFailed:
                return 417
            case .ImATeapot:
                return 418
            case .AuthenticationTimeout:
                return 419
            case .MethodFailure:
                return 420
            case .MisdirectedRequest:
                return 421
            case .UnprocessableEntity:
                return 422
            case .Locked:
                return 423
            case .FailedDependency:
                return 424
            case .UpgradeRequired:
                return 426
            case .PreconditionRequired:
                return 428
            case .TooManyRequests:
                return 429
            case .RequestHeaderFieldsTooLarge:
                return 431
            case .LoginTimeout:
                return 440
            case .NoResponse:
                return 444
            case .RetryWith:
                return 449
            case .BlockedByWindowsParentalControls:
                return 450
            case .RequestHeaderTooLarge:
                return 494
            case .CertError:
                return 495
            case .NoCert:
                return 496
            case .HTTPToHTTPS:
                return 497
            case .TokenExpiredinvalid:
                return 498
            case .ClientClosedRequest:
                return 499
            case .InternalServerError:
                return 500
            case .NotImplemented:
                return 501
            case .BadGateway:
                return 502
            case .ServiceUnavailable:
                return 503
            case .GatewayTimeout:
                return 504
            case .HTTPVersionNotSupported:
                return 505
            case .VariantAlsoNegotiates:
                return 506
            case .InsufficientStorage:
                return 507
            case .LoopDetected:
                return 508
            case .BandwidthLimitExceeded:
                return 509
            case .NotExtended:
                return 510
            case .NetworkAuthenticationRequired:
                return 511
            case .NetworkReadTimeoutError:
                return 598
            case .NetworkConnectTimeoutError:
                return 599
            default:
                return -1
            }
        }
    }
}
