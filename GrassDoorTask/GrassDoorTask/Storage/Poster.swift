//
//  Poster.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 10/12/22.
//

import CoreData
import UIKit.UIImage

@objc(Poster)
class Poster: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Poster> {
        return NSFetchRequest<Poster>(entityName: "Poster")
    }

    @NSManaged public var id: String
    @NSManaged public var poster: UIImage?

}

extension Poster : Identifiable {

}
