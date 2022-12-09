//
//  MovieServiceDownloader.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import Foundation

final class MovieServiceDownloader: ObservableObject {
    @Published var movies = [Movie]()
    
    private var serviceProvider = MovieServiceProvider(client: URLSessionHTTPClient(session: URLSession.shared))
    
    func getPopular() {
        getMovies(endPoint: .popular)
    }
    
    func getTopRated() {
        getMovies(endPoint: .topRated)
    }
    
    func getMovies(endPoint: MovieEndPoint) {
        serviceProvider.fetchMovies(endPoint: endPoint) { result in
            switch result {
            case let .success(movies):
                self.movies = movies
            case .failure:
                break
            }
        }
    }
    
}
