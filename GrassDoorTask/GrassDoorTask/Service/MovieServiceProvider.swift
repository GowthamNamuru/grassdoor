//
//  MovieServiceProvider.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import Foundation

final class MovieServiceProvider: MovieService {
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    public typealias Result = LoadMovieResult
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    func fetchMovies(endPoint: MovieEndPoint, params: [String: String]?, completionHandler: @escaping (LoadMovieResult) -> ()) {
        guard let url = endPoint.url else {
            return
        }
        client.get(from: url, params: params) { [weak self] result in
            guard self != nil else {
                return
            }
            switch result {
            case .failure:
                completionHandler(.failure(Error.connectivity))
            case let .success(data, response):
                completionHandler(MovieServiceProvider.map(data, from: response))
            }
        }
    }
    
    func fetchMovieTrailers(endPoint: MovieDetailsEndPoint, params: [String : String]?, completionHandler: @escaping (LoadTrailerResult) -> ()) {
        guard let url = endPoint.url else {
            return
        }
        client.get(from: url, params: params) { [weak self] result in
            guard self != nil else {
                return
            }
            switch result {
            case .failure:
                completionHandler(.failure(Error.connectivity))
            case let .success(data, response):
                completionHandler(MovieServiceProvider.mapForTrailers(data, from: response))
            }
        }
    }
    
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try MovieResultMapper.map(data, from: response)
            return .success(items)
        } catch {
            return .failure(error)
        }
    }
    
    private static func mapForTrailers(_ data: Data, from response: HTTPURLResponse) -> LoadTrailerResult {
        do {
            let items = try MovieResultMapper.mapTrailers(data, from: response)
            return .success(items)
        } catch {
            return .failure(error)
        }
    }
}

final class MovieResultMapper {
    private struct Root: Decodable {
        let results: [Movie]
    }
    
    private static let OK_200 = 200
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [MovieViewModel] {
        guard response.statusCode == OK_200, let root = try? Utils.jsonDecoder.decode(Root.self, from: data) else {
            throw MovieServiceProvider.Error.invalidData
        }
        return root.results.map({ MovieViewModel.init(movie: $0) })
    }
    
    private struct RootTrailers: Decodable {
        let results: [Trailers]
    }
    
    static func mapTrailers(_ data: Data, from response: HTTPURLResponse) throws -> [Trailers] {
        guard response.statusCode == OK_200, let root = try? Utils.jsonDecoder.decode(RootTrailers.self, from: data) else {
            throw MovieServiceProvider.Error.invalidData
        }
        return root.results
    }
}
