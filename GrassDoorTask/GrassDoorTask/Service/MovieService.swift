//
//  MovieService.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import Foundation

enum LoadMovieResult {
    case success([Movie])
    case failure(Error)
}

protocol MovieService {
    func fetchMovies(endPoint: MovieEndPoint, completionHandler: @escaping (LoadMovieResult) -> ())
}
