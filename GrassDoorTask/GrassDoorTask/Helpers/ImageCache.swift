//
//  ImageCache.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import UIKit
import CoreData

final class LocalImageStore: ImageStore {
    static let shared = LocalImageStore()
    
    private init() { }
    
    private var context = PosterCoreDataManager.shared.persistentContainer.viewContext
    
    private var fetchedPoster = [Poster]()
    
    private func fetchPosters(name: String) -> Poster? {
        let request: NSFetchRequest<Poster> = NSFetchRequest(entityName: "Poster")
        do {
            fetchedPoster = try context.fetch(request)
            let operation = Set(fetchedPoster)
            return operation.first(where: { $0.id == name })
        } catch {
            print("Failed to retrive image \(name)")
            return nil
        }
    }
    
    func insert(_ imageName: String, _ image: UIImage?, completion: @escaping InsertionCompletion) {
        let poster = Poster(context: context)
        poster.id = imageName
        poster.poster = image
        try? context.save()
    }
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        // Un intentionally not implemented
    }
    
    func retrieve(_ imageName: String) -> UIImage? {
        let operation = Set(fetchedPoster)
        if fetchedPoster.isEmpty, !operation.contains(where: { $0.id == imageName }) {
            return fetchPosters(name: imageName)?.poster
        }
        return operation.first(where: { $0.id == imageName })?.poster
    }
}
