//
//  MoviesView.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 10/12/22.
//

import SwiftUI

struct MoviesView: View {
    @ObservedObject var movieManager = MovieServiceDownloader()
    enum Tab: Int {
        case popular
        case topRated
    }
    var selectedTab: Tab

    var body: some View {
        VStack {
            List {
                ForEach(movieManager.movies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: MovieViewModel(movie: movie))) {
                        MovieCell(movie: MovieViewModel(movie: movie))
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .onAppear{
                switch selectedTab {
                case .topRated:
                    movieManager.getTopRated()
                case .popular:
                    movieManager.getPopular()
                }
            }
            
            Spacer()
        }
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView(selectedTab: .topRated)
    }
}
