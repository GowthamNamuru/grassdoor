//
//  PosterCoreDataManager.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 10/12/22.
//

import CoreData


final class PosterCoreDataManager {
    let persistentContainer: NSPersistentContainer
    
    static let shared = PosterCoreDataManager()
    
    private init() {
        
        ValueTransformer.setValueTransformer(UIImageTransformer(), forName: NSValueTransformerName("UIImageTransformer"))
        
        persistentContainer = NSPersistentContainer(name: "Posters")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("Unable to initialise PosterCoreDataManager \(error)")
            }
        }
    }
}
