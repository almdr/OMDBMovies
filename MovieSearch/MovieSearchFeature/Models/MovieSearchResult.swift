//
//  MovieSearchResult.swift
//  MovieSearch
//
//  Created by Alfonso on 12/05/25.
//

struct MovieSearchResult: Codable {
    let Search: [Movie]
    let totalResults: String
    let Response: String
}

