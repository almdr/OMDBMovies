//
//  MovieRow.swift
//  MovieSearch
//
//  Created by Alfonso on 12/05/25.
//

import SwiftUI

struct MovieRow: View {

    let vm = MovieSearchService()
    let movie: Movie
    @State var imageData: Data?

    var body: some View {
        HStack {
            if let imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                        } else {
                            ProgressView()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                        }
            VStack(alignment: .leading) {
                Text(movie.Title)
                    .font(.headline)
                Text(movie.Year)
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding()
        .task {
            if let url = URL(string: movie.Poster) {
                imageData = await vm.fetchImageWithCache(from: url)
            }
        }
    }
}

