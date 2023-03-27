//
//  CoreDataStack.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 24/03/23.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static var shared = CoreDataStack()
    
    // container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StoreDataModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let nserror = error as? NSError {
                fatalError("unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        return container
    }()
    
    lazy var mainContext = persistentContainer.viewContext
    
    func saveContext() {
        let context = mainContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
