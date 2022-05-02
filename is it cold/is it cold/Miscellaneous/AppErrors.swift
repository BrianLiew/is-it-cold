import Foundation

struct AppErrors: Error {
    var description: String
    var kind: ErrorType
    
    enum ErrorType {
        case LocationError
        case AnimationError
        case ParsingError
    }
}
