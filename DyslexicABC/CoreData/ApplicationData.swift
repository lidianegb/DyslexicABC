//
//  ApplicationData.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 25/03/23.
//

import Foundation
import CoreData

class ApplicationData: ObservableObject {
    static let container: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "CoreDataModel")
       
        container.loadPersistentStores { (storeDescription, error) in
            if let nserror = error as? NSError {
                fatalError("unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        return container
    }()
    
    static func saveContext() async {
        await container.viewContext.perform {
            do {
                try self.container.viewContext.save()
            } catch {
                // TODO: SHOW ERROR
            }
        }
    }
    
    static func clearModelData(_ data: NSManagedObject) async {
        await container.viewContext.perform {
            self.container.viewContext.delete(data)
        }
        do {
            try container.viewContext.save()
        } catch {
            print("error deleting objects")
        }
    }
}
