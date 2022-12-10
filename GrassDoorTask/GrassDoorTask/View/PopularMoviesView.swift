//
//  MoviesView.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 10/12/22.
//

import SwiftUI

struct PopularMoviesView: View {
    @ObservedObject var movieManager = MovieServiceDownloader(type: .popular)
    var body: some View {
        MoviesView(movieManager: movieManager)
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        PopularMoviesView()
    }
}


struct MoviesView: View {
    @ObservedObject var movieManager: MovieServiceDownloader
    
    var body: some View {
        VStack {
            List {
                ForEach(movieManager.movies, id: \.movie.id) { movieViewModel in
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
            .refreshable {
                movieManager.getMovies()
            }
            
            Spacer()
        }
    }
}
