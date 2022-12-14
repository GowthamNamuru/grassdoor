//
//  MovieFeedStore.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 10/12/22.
//

import Foundation

enum MovieType {
    case topRated
    case popular
    case movieTrailers(id: Int)
    
    var description: String {
        switch self {
        case .topRated:
            return "topRated"
        case .popular:
            return "popular"
        case .movieTrailers:
            return ""
        }
    }
}

protocol MovieStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = ([MovieViewModel]?) -> Void
    
    /// The completion handler can be invoked in any thread.
    /// Clents are responsible to dispatch to appropiate thread, if needed.
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clents are responsible to dispatch to appropiate thread, if needed.
    func insert(_ movie: [Movie], type: MovieType, completion: @escaping InsertionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clents are responsible to dispatch to appropiate thread, if needed.
    func retrieveMovies(for type: MovieType, completion: @escaping RetrievalCompletion)
}
