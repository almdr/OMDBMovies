//
//  ContentView.swift
//  MovieSearch
//
//  Created by Alfonso on 12/05/25.
//

import SwiftUI

struct MovieSearchView: View {

    let vm = MovieSearchService()
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(vm.movies) { movie in
                        VStack {
                            NavigationLink(value: movie) {
                                MovieRow(movie: movie)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                            }
                        }
                    }
                }.scrollTargetLayout()
            }
            .task(id: searchText) {
                await vm.fetchMovies(query: searchText)
            }
            .onScrollTargetVisibilityChange(idType: Movie.ID.self, threshold: 0.3 ) { id in
                if let lastMovie = vm.movies.last, id.contains(where: { $0 == lastMovie.id }) {
                    if vm.canLoadMore() {
                        vm.currentPage += 1
                        Task {
                            await vm.fetchMovies(query: searchText)
                        }
                    }
                }
            }
            .navigationDestination(for: Movie.self) { movie in
                    MovieDetail(movie: movie)
            }
        }
        .searchable(text: $searchText)

    }
}

#Preview {
    MovieSearchView()
}
