//
//  MovieEndPoint.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import Foundation

enum MovieEndPoint: String {
    case topRated = "top_rated"
    case popular
    
    private var baseURL: String {
        return "https://api.themoviedb.org/3"
    }
    
    /// These will be updated later
    var url: URL? {
        return URL(string: "\(baseURL)/movie/\(rawValue)")
    }
}
