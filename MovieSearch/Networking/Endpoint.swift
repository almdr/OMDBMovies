//
//  Endpoint.swift
//  
//
//  Created by Alfonso  on 12/10/23.
//  Copyright © 2023 Alfonso. All rights reserved.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var authorize: Bool { get }
    var body: Data? { get }
    var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
    
    var scheme: String {
        return "https"
    }

    var host: String {
        return "www.omdbapi.com"
    }
    
    var path: String {
        return ""
    }
    
    var method: RequestMethod {
        return .get
    }
    
    var header: [String: String]? {
        return nil
    }
    
    var authorize: Bool {
        false
    }
    
    var body: Data? {
        return nil
    }

    var queryItems: [URLQueryItem]? {
        return nil
    }
}



