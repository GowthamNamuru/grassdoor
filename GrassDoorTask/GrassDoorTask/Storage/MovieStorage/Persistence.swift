//
//  Persistence.swift
//  GrassDoorTask
//
//  Created by Gowtham Namuri on 09/12/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "GrassDoorTask")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unable to initialise MovieEntity PersistenceController \(error)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
