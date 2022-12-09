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
    
    /// These will be updated later
    var url: URL? {
        switch self {
        case .topRated:
            return URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=7f66a4f9aceca93fb08ae8eb41cb05c2&language=en-US&page=1")
        case .popular:
            return URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=7f66a4f9aceca93fb08ae8eb41cb05c2&language=en-US&page=1")
        }
    }
}
