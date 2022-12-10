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
        MoviesView(movieManager: movieManager)
    }
}

struct TopRatedMovieView_Previews: PreviewProvider {
    static var previews: some View {
        TopRatedMovieView()
    }
}
