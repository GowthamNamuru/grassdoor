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
    
    private struct  UnExpectedValueRepresentation: Error {}
    
    func get(from url: URL, completion: @escaping (HTTPURLResult) -> Void) {
        session.dataTask(with: url, completionHandler: {data, response, error in
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

