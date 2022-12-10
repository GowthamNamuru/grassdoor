//
//  MovieServiceDownloader.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import Foundation

final class MovieServiceDownloader: ObservableObject {
    @Published var movies = [MovieViewModel]()
    @Published var trailers = [Trailers]()
    @Published var trailerFailed: String?
    
    private var serviceProvider = MovieServiceProvider(client: URLSessionHTTPClient(session: URLSession.shared))
    
    private var pageCount = 1
    private var totalPages = 10
    
    private var type: MovieType
    
    init(type: MovieType) {
        self.type = type
    }
    
    func getMovies() {
        switch type {
        case .topRated:
            getTopRated()
        case .popular:
            getPopular()
        case let .movieTrailers(id):
            fetchMovieTrailers(for: id)
        }
    }
    
    private func getPopular() {
        getMovies(endPoint: .popular, pageCount: pageCount)
    }
    
    private func getTopRated() {
        getMovies(endPoint: .topRated, pageCount: pageCount)
    }
    
    func getNextPageOfMovie(currentItem: MovieViewModel) {
        let thresholdIndex = self.movies.last?.id
        if thresholdIndex == currentItem.id, (pageCount + 1) <= totalPages {
            pageCount += 1
            switch type {
            case .topRated:
                getMovies(endPoint: .topRated, pageCount: pageCount)
            case .popular:
                getMovies(endPoint: .popular, pageCount: pageCount)
            case .movieTrailers:
                break
            }
        }
    }
    
    
    func fetchMovieTrailers(for id: Int) {
        serviceProvider.fetchMovieTrailers(endPoint: .trailers(id: id), params: [:]) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(receivedTrailers):
                    self.trailers = receivedTrailers
                    self.trailerFailed = nil
                case let .failure(error):
                    self.trailerFailed = "Failed to load trailers"
                }
            }
        }
    }
    
    func getMovies(endPoint: MovieEndPoint, pageCount: Int) {
        let params = ["page": "\(pageCount)"]
        serviceProvider.fetchMovies(endPoint: endPoint, params: params) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case let .success(movies):
                    if pageCount != 1 {
                        self.movies.append(contentsOf: movies)
                    } else {
                        self.movies = movies
                        
                        /// Store one page of data on the local db
                        let type = (endPoint == .popular) ? MovieType.popular : MovieType.topRated
                        LocalMovieStore.shared.insert(movies.toModels(), type: type, completion: { error in
                            if let error = error {
                                print("Failed to save on core data for  with error \(error)")
                            }
                        })

                    }
                case .failure:
                    self.loadFromLocalDB(type: endPoint == .popular ? MovieType.popular : MovieType.topRated)
                }
            }
        }
    }
    
    private func loadFromLocalDB(type: MovieType) {
        LocalMovieStore.shared.retrieveMovies(for: type, completion: { movieViewModel in
            if let movieModel = movieViewModel {
                self.movies = movieModel
            }
        })
    }
}

struct MainThread {
    static func perform(_ task: @escaping () -> Void) {
        Thread.isMainThread ? task() : DispatchQueue.main.async(execute: task)
    }
}
