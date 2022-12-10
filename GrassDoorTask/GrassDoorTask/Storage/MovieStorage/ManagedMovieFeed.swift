//
//  ManagedMovieFeed.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 10/12/22.
//

import CoreData

@objc(ManagedMovieFeed)
class ManagedMovieFeed: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedMovieFeed> {
        return NSFetchRequest<ManagedMovieFeed>(entityName: "ManagedMovieFeed")
    }

    @NSManaged public var backdropPath: String?
    @NSManaged public var id: Int32
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var runTime: Int32
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int32
    @NSManaged public var cache: ManagedCache

}

extension ManagedMovieFeed : Identifiable {
    static func movies(from localFeed: [Movie], type: MovieType, in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localFeed.map { local in
            let managed = ManagedMovieFeed(context: context)
            managed.backdropPath = local.backdropPath
            managed.id = Int32(local.id)
            managed.overview = local.overview
            managed.posterPath = local.posterPath
            managed.releaseDate = local.releaseDate
            managed.runTime = Int32(local.runTime ?? 0)
            managed.title = local.title
            managed.type = type.rawValue
            managed.voteAverage = local.voteAverage ?? 0
            managed.voteCount = Int32(local.voteCount)
            return managed
        })
    }
    
    var local: MovieViewModel {
        return MovieViewModel(movie: Movie(id: Int(id), title: title ?? "", overview: overview ?? "", posterPath: posterPath, backdropPath: backdropPath, releaseDate: releaseDate ?? "", runTime: Int(runTime), voteCount: Int(voteCount), voteAverage: voteAverage))
    }
}
