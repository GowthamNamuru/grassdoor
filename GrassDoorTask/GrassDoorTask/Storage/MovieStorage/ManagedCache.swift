//
//  ManagedCache.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 10/12/22.
//

import CoreData

@objc(ManagedCache)
class ManagedCache: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var feed: NSOrderedSet
}

extension ManagedCache {
    static func find(in context: NSManagedObjectContext, type: MovieType) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "name = %@", type.rawValue)
        return try context.fetch(request).first
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext, type: MovieType) throws -> ManagedCache {
        try find(in: context, type: type).map (context.delete)
        
        return ManagedCache(context: context)
    }
    
    
    var localFeed: [MovieViewModel] {
        return feed.compactMap({ ($0 as? ManagedMovieFeed)?.local })
    }
}

