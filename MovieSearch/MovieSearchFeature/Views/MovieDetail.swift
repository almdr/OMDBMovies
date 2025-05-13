//
//  MovieDetail.swift
//  MovieDetail
//
//  Created by Alfonso on 12/05/25.
//

import SwiftUI

struct MovieDetail: View {

    let vm = MovieSearchService()
    let movie: Movie
    @State var movieDetail: MovieDetailResponse?
    @State var imageData: Data?

    var body: some View {
        VStack {
            Text(movieDetail?.Title ?? "")
                .font(.largeTitle)
                .padding()

            Text(movieDetail?.Plot ?? "")
                .padding()
            if let imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 300)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 300)
                    .foregroundColor(.gray)
            }

            Text("RatingURLCache: \(movieDetail?.imdbRating ?? "")")
                .padding()

        }
        .task {
            movieDetail = await vm.fetchMovieDetail(id: movie.imdbID)
            if let posterUrl = movieDetail?.Poster, let url = URL(string: posterUrl) {
                imageData = await vm.fetchImageWithCache(from: url)
            }
        }
    }
}
