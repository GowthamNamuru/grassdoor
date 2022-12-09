//
//  HTTPClient.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import Foundation

enum HTTPURLResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}


protocol HTTPClient {
    
    /// The completion handler can be invoked in any thread.
    /// Clents are responsible to dispatch to appropiate thread, if needed.
    func get(from url: URL, params: [String: String]?, completion: @escaping (HTTPURLResult) -> Void)
}
