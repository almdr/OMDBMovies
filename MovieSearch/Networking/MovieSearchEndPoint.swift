//
//  MovieSearchEndpoint.swift
//  MovieSearchEndpoint
//
//  Created by Alfonso on 12/05/25.
//

import Foundation

enum MovieSearchEndpoint {
    case searchMovie(query: String, page:Int)
    case movieDetail(id: String)
}

extension MovieSearchEndpoint: Endpoint {

    var path: String {
        return ""
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .searchMovie(let query, let page):
            return [
                URLQueryItem(name: "s", value: query),
                URLQueryItem(name: "apikey", value: apiKey),
                URLQueryItem(name: "page", value: String(page))
            ]
        case .movieDetail(let id):
            return [
                URLQueryItem(name: "i", value: id),
                URLQueryItem(name: "apikey", value: apiKey),
            ]
        }
    }

    var method: RequestMethod {
        return .get
    }
}

