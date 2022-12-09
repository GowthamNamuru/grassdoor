//
//  Movie.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import Foundation

struct MovieResult: Decodable {
    let results: [Movie]
}

struct Movie: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String
    let runTime: Int?
    let voteCount: Int
}
