//
//  TopRatedMovieView.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 10/12/22.
//

import SwiftUI

struct TopRatedMovieView: View {
    @ObservedObject var movieManager = MovieServiceDownloader(type: .topRated)
    var body: some View {
        VStack {
            List {
                ForEach(movieManager.movies) { movieViewModel in
                    NavigationLink(destination: MovieDetailView(movie: movieViewModel)) {
                        MovieCell(movie: movieViewModel)
                            .onAppear {
                                movieManager.getNextPageOfMovie(currentItem: movieViewModel)
                            }
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .onAppear{
                movieManager.getMovies()
            }
            
            Spacer()
        }
    }
}

struct TopRatedMovieView_Previews: PreviewProvider {
    static var previews: some View {
        TopRatedMovieView()
    }
}
