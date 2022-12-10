//
//  ImageCache.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import UIKit
import CoreData

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}


final class TempCache: ImageCache {
    private var cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100
        return cache
    }()
    
    subscript(url: URL) -> UIImage? {
        get {
            cache.object(forKey: url as NSURL)
        }
        set {
            if let value = newValue {
                cache.setObject(value, forKey: url as NSURL)
            } else {
                cache.removeObject(forKey: url as NSURL)
            }
        }
    }
}


final class LocalImageStore: ImageStore {
    static let shared = LocalImageStore()
    
    private init() { }
    
    private var context = PosterCoreDataManager.shared.persistentContainer.viewContext
    
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
        let request: NSFetchRequest<Poster> = NSFetchRequest(entityName: "Poster")
        request.predicate = NSPredicate(format: "id LIKE %@", imageName)
        request.fetchLimit = 1
        
        do {
            let image = try context.fetch(request).first
            return image?.poster
        } catch {
            print("Failed to retrive image \(imageName)")
        }
        return nil
    }
}
