//
//  MovieService.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import Foundation

enum LoadMovieResult {
    case success([MovieViewModel])
    case failure(Error)
}

enum LoadTrailerResult {
    case success([Trailers])
    case failure(Error)
}

protocol MovieService {
    func fetchMovies(endPoint: MovieEndPoint, params: [String: String]?, completionHandler: @escaping (LoadMovieResult) -> ())
    func fetchMovieTrailers(endPoint: MovieDetailsEndPoint, params: [String: String]?, completionHandler: @escaping (LoadTrailerResult) -> ())
}
