//
//  MovieViewModel.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import Foundation

struct MovieViewModel: Identifiable {
    private(set) var movie: Movie
    var id: Int {
        movie.id
    }
    private(set) var title: String
    private(set) var posterPath: String = ""
    private(set) var votingAverage: Double = 0.0
    private(set) var releaseDate: String = ""
    
    var imageName: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() + "\(movie.id)"
    }
    
    init(movie: Movie) {
        self.movie = movie
        title = movie.title
        if let path = movie.posterPath {
            posterPath = "https://image.tmdb.org/t/p/original/\(path)"
        }
        
        if let average = movie.voteAverage {
            let vAverage = average / 10.0
            votingAverage = vAverage
        }
        releaseDate = Utils.dateString(from: movie.releaseDate)
    }
}

extension Array where Element == MovieViewModel {
    func toModels() -> [Movie] {
        return map({ $0.movie })
    }
}
