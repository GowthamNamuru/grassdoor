//
//  LocalMovieStore.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 10/12/22.
//

import CoreData

final class LocalMovieStore: MovieStore {
    
    static let shared = LocalMovieStore()
    
    private init() {
        context = container.newBackgroundContext()
    }
    
    private var container = PersistenceController.shared.container
    private var context: NSManagedObjectContext
    
    func insert(_ movie: [Movie], type: MovieType, completion: @escaping InsertionCompletion) {
            perform { context in
                do {
                    let managedCache = try ManagedCache.newUniqueInstance(in: context, type: type)
                    managedCache.name = type.rawValue
                    managedCache.feed = ManagedMovieFeed.movies(from: movie, type: type, in: context)
                    try context.save()
                    completion(nil)
                } catch {
                    completion(error)
                }
            }
    }
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        perform { context in
            do {
                try ManagedCache.find(in: context, type: .popular).map(context.delete).map(context.save)
                try ManagedCache.find(in: context, type: .topRated).map(context.delete).map(context.save)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    func retrieveMovies(for type: String, completion: @escaping RetrievalCompletion) {
        perform { context in
            do {
                if let cache = try ManagedCache.find(in: context, type: MovieType(rawValue: type) ?? .popular) {
                    completion(cache.localFeed)
                } else {
                    completion([])
                }
            } catch {
                print("Failed to retrive with \(error)")
                completion(nil)
            }
        }
    }
    
    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}
