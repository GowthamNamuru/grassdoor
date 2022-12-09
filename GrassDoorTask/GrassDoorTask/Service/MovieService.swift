//
//  MovieService.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import Foundation

protocol MovieService {
    func fetchMovies(_ endPoint: MovieEndPoint, completionHandler: @escaping (Result<MovieResult, Error>) -> ())
}
