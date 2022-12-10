//
//  MovieServiceDownloader.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import Foundation

final class MovieServiceDownloader: ObservableObject {
    @Published var movies = [MovieViewModel]()
    
    private var serviceProvider = MovieServiceProvider(client: URLSessionHTTPClient(session: URLSession.shared))
    
    func getPopular() {
        getMovies(endPoint: .popular)
    }
    
    func getTopRated() {
        getMovies(endPoint: .topRated)
    }
    
    func getMovies(endPoint: MovieEndPoint) {
        serviceProvider.fetchMovies(endPoint: endPoint) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(movies):
                    self.movies = movies
                    let type = (endPoint == .popular) ? MovieType.popular : MovieType.topRated
                    LocalMovieStore.shared.insert(movies.toModels(), type: type, completion: { error in
                        if let error = error {
                            print("Failed to save on core data for \(type.rawValue) with error \(error)")
                        }
                    })
                case .failure:
                    self.loadFromLocalDB(type: endPoint == .popular ? "popular" : "topRated")
                }
            }
        }
    }
    
    private func loadFromLocalDB(type: String) {
        LocalMovieStore.shared.retrieveMovies(for: type, completion: { movieViewModel in
            if let movieModel = movieViewModel {
                self.movies = movieModel
            }
        })
    }
}
