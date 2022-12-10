//
//  MovieDetailView.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 10/12/22.
//

import SwiftUI

struct MovieDetailView: View {
    
    @StateObject private var loader: ImageDownloader
    @ObservedObject private var movieService = MovieServiceDownloader()
    
    var movieViewModel: MovieViewModel
    
    
    init(movie: MovieViewModel) {
        movieViewModel = movie
        let url = URL(string: movieViewModel.posterPath)!
        let imageName = movieViewModel.imageName
        _loader = StateObject(wrappedValue: ImageDownloader(imageName: imageName, url: url, cache: Environment(\.imageCache).wrappedValue))
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            backgroundView
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    headerView
                    moviePosterView
                    movieOverview
                }
                .padding(.top, 84)
                .padding(.horizontal, 32)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private var backgroundView: some View {
        imageView.onAppear{
            loader.load()
        }
        .blur(radius: 100)
    }
    
    private var imageView: some View {
        Group {
            if let loadedImage = loader.image {
                Image(uiImage: loadedImage)
                    .resizable()
            } else {
                Rectangle().foregroundColor(Color.gray.opacity(0.4))
            }
        }
    }
    
    
    private var headerView: some View {
        VStack {
            Text(movieViewModel.title)
                .font(.title)
            
            Text("Release Date: \(movieViewModel.releaseDate)")
                .font(.subheadline)
        }
        .foregroundColor(.white)
    }
    
    private var moviePosterView: some View {
        HStack(alignment: .center) {
            Spacer()
            imageView
                .frame(width: 200, height: 320)
                .cornerRadius(20)
            Spacer()
        }
    }
    
    private var movieOverview: some View {
        Text(movieViewModel.movie.overview)
            .font(.body)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 16)
    }
}
