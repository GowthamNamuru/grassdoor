//
//  Movie.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import Foundation

struct Movie: Decodable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: Date
    let runTime: Int?
    let voteCount: Int
    let voteAverage: Double?
}

struct Trailers: Decodable, Identifiable {
    let id: String
    let name: String
    let key: String
    let site: String
}
