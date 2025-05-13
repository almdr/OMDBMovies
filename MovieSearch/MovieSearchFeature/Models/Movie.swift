//
//  Movie.swift
//  Movie
//
//  Created by Alfonso on 12/05/25.
//

import Foundation

struct Movie: Codable, Hashable, Identifiable {
    let id = UUID()
    let Title: String
    let Year: String
    let imdbID: String
    let Poster: String
}


