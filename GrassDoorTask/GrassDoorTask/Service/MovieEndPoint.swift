//
//  MovieEndPoint.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import Foundation

fileprivate let baseURL = "https://api.themoviedb.org/3"

enum MovieEndPoint: String {
    case topRated = "top_rated"
    case popular
    /// These will be updated later
    var url: URL? {
        return URL(string: "\(baseURL)/movie/\(rawValue)")
    }
}

enum MovieDetailsEndPoint {
    case trailers(id: Int)
    
    var url: URL? {
        switch self {
        case let .trailers(id):
            return URL(string: "\(baseURL)/movie/\(id)/videos")
        }
    }
}
