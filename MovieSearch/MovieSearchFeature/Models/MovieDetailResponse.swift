//
//  MovieDetailResponse.swift
//  MovieSearch
//
//  Created by Alfonso on 13/05/25.
//

import Foundation

struct MovieDetailResponse: Codable, Hashable, Identifiable {
    let id = UUID()
    let Title: String
    let Plot: String
    let imdbRating: String
    let Poster: String
}
