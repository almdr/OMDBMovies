//
//  MovieSearchService.swift
//  MovieSearch
//
//  Created by Alfonso on 12/05/25.
//

import Foundation

@Observable
class MovieSearchService {

    let networking = MovieSearchHTTPClient()
    var movies: [Movie] = []

    var currentPage: Int = 1
    private var totalPages: Int = 1
    var lastQuery: String = ""

    func fetchMovies(query: String) async {
        if query != lastQuery {
            lastQuery = query
            movies = []
            currentPage = 1
        }
        let endpoint: MovieSearchEndpoint = .searchMovie(query: query, page: currentPage)
        let response = try? await networking.sendRequest(endpoint: endpoint, responseModel: MovieSearchResult.self)
        movies = movies + (response?.Search ?? [])
        totalPages = (Int(response?.totalResults ?? "1") ?? 0) / 10
    }

    func loadNext() {
        if canLoadMore() {
            currentPage += 1
        }
    }

    func canLoadMore() -> Bool {
        return currentPage <= totalPages
    }

    func fetchMovieDetail(id: String) async -> MovieDetailResponse? {
        let endpoint: MovieSearchEndpoint = .movieDetail(id: id)
        let response = try? await networking.sendRequest(endpoint: endpoint, responseModel: MovieDetailResponse.self)
        return response
    }

    func fetchImageWithCache(from url: URL) async -> Data? {
        let request = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            return cachedResponse.data
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                let cachedResponse = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: request)
                return data
            }
        } catch {
            print("Failed to fetch image: \(error)")
        }
        return nil
    }
}

