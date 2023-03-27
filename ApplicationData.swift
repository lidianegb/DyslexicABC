//
//  ApplicationData.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 25/03/23.
//

import Foundation
import CoreData

class ApplicationData: ObservableObject {
    let container: NSPersistentContainer
    
    static var preview: ApplicationData = {
        ApplicationData(preview: true)
    }()
    
    init(preview: Bool = false) {
        container = NSPersistentContainer(name: "StoryDataModel")
        if preview {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "dev/null")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let nserror = error as? NSError {
                fatalError("unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
