//
//  URLSessionHTTPClient.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import Foundation

class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    enum HTTPClientError: Error {
        case invalidURL
    }
    
    
    private let api = "7f66a4f9aceca93fb08ae8eb41cb05c2"
    
    private struct  UnExpectedValueRepresentation: Error {}
    
    func get(from url: URL, params: [String: String]?, completion: @escaping (HTTPURLResult) -> Void) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(HTTPClientError.invalidURL))
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: api)]
        
        if let params = params {
            queryItems.append(contentsOf: params.map{ URLQueryItem(name: $0.key, value: $0.value) })
        }
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(HTTPClientError.invalidURL))
            return
        }
        session.dataTask(with: finalURL, completionHandler: {data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success(data, response))
            }
            else {
                completion(.failure(UnExpectedValueRepresentation()))
            }
        }).resume()
    }
}

