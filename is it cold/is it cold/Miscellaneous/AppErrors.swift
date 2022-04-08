//
//  AppErrors.swift
//  is it cold
//
//  Created by Brian Liew on 4/7/22.
//

import Foundation

struct AppErrors: Error {
    var description: String
    var kind: ErrorType
    
    enum ErrorType {
        case LocationError
        case AnimationError
    }
}
