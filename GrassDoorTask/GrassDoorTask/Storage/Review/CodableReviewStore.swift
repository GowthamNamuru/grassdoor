//
//  CodableReviewStore.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 10/12/22.
//

import Foundation
import SwiftUI

struct Review: Codable, Identifiable {
    let id: String
    let reviews: String
}

//struct ReviewContent: Codable, Identifiable {
//    var id: Int
//    let content: String
//}

enum RetrieveCachedFeedResult {
    case failure(Error)
    case empty
    case found(id: String, feed: Review)
}

protocol ReviewStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCachedFeedResult) -> Void
    
    /// The completion handler can be invoked in any thread.
    /// Clents are responsible to dispatch to appropiate thread, if needed.
    func deleteReview(completion: @escaping DeletionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clents are responsible to dispatch to appropiate thread, if needed.
    func insert(_ review: Review, completion: @escaping InsertionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clents are responsible to dispatch to appropiate thread, if needed.
    func retrieveReview()
}


final class CodableReviewStore: ReviewStore, ObservableObject {
    
    @Published var review: Review = Review(id: "123", reviews: "")
    
    private struct Cache: Codable {
        var review: Review
        var id: String
        
    }
    
    private struct CacheFeedImage: Codable {
        private let id: UUID
        
    }
    private let folderName = "Reviews"
    
    private var storeURL: URL = URL(string: "/dev/null")!
    
    
    
    init(movieId: String) {
        self.storeURL = getURLForReview(id: movieId) ?? URL(string: "/dev/null")!
    }
    
    private let queue = DispatchQueue(label: "\(CodableReviewStore.self)Queue", qos: .userInitiated, attributes: .concurrent)
    
    func retrieveReview() {
        let storeURL = storeURL
        queue.async {
            guard let data = try? Data(contentsOf: storeURL) else {
//                return completion(.empty)
                return
            }
            do {
                let decoder = JSONDecoder()
                let cache = try decoder.decode(Cache.self, from: data)
//                completion(.found(id: cache.id, feed: cache.review))
                DispatchQueue.main.async {
                    self.review = cache.review
                }
            } catch {
//                completion(.failure(error))
            }
        }
    }
    
    func insert(_ review: Review, completion: @escaping InsertionCompletion) {
        let storeURL = storeURL
        queue.async(flags: .barrier) {
            do {
                let encoder = JSONEncoder()
                let feed = Cache(review: review, id: review.id)
                let encoded = try encoder.encode(feed)
                try encoded.write(to: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func deleteReview(completion: @escaping DeletionCompletion) {
        let storeURL = storeURL
        queue.async(flags: .barrier) {
            guard FileManager.default.fileExists(atPath: storeURL.path) else {
                return completion(nil)
            }
            do {
                try FileManager.default.removeItem(at: storeURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}


private extension CodableReviewStore {
    func getURLForFolder() -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }
        
    func getURLForReview(id: String) -> URL? {
        createFolderIfNeeded()
        guard let floderURL = getURLForFolder() else {
            return nil
        }
        return floderURL.appendingPathComponent("\(id).txt")
    }
    
    func createFolderIfNeeded() {
        guard let folderURL = getURLForFolder() else {
            return
        }
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
            } catch {
                print("Failed to create directory \(error)")
            }
        }
    }
}
