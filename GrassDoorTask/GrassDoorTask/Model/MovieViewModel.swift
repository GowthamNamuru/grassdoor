//
//  MovieViewModel.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import Foundation

struct MovieViewModel {
    
    private var movie: Movie
    
    private(set) var title: String
    private(set) var posterPath: String?
    private(set) var votingAverage: String = ""
    
    init(movie: Movie) {
        self.movie = movie
        title = movie.title
        if let path = movie.posterPath {
            posterPath = "https://image.tmdb.org/t/p/original/\(path)"
        }
        
        if let average = movie.voteAverage {
            let vAverage = average / 10.0
            votingAverage = "\(vAverage)"
        }
    }
}
