//
//  RequestError.swift
//  
//
//  Created by Alfonso  on 12/10/23.
//  Copyright © 2023 Alfonso. All rights reserved.
//

import Foundation

enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case serverError
    case other(message: String)
    case unknown
}

extension RequestError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .decode:
            return "Decode error"
        case .invalidURL:
            return "Wrong request"
        case .unauthorized:
            return "Session expired"
        case .serverError:
            return "Server error"
        case .other(let message):
            return message
        default:
            return "Server error"
        }
    }
}
