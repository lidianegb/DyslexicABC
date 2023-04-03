//
//  StoryCloudKitData.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 28/03/23.
//

import CloudKit
import CoreData

class StoryCloudKitData: ObservableObject {
    
    let container: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CoreDataModel")
        
        // Create a store description for a local and cloud store
        let address = Bundle.main.path(forResource: "CoreDataModel", ofType: ".momd")
        let localStoreLocation = URL(fileURLWithPath: "\(address!)/Local.sqlite")
        let cloudStoreLocation = URL(fileURLWithPath: "\(address!)/Cloud.sqlite")
        
        let localStoreDescription =
        NSPersistentStoreDescription(url: localStoreLocation)
        localStoreDescription.configuration = "Local"
        
        let cloudStoreDescription =
        NSPersistentStoreDescription(url: cloudStoreLocation)
        cloudStoreDescription.configuration = "Cloud"
        
        // Set the container options on the cloud store
        cloudStoreDescription.cloudKitContainerOptions =
        NSPersistentCloudKitContainerOptions(
            containerIdentifier: "lidiane.gomes.barbosa.DyslexicABC"
        )
        
        // Update the container's list of store descriptions
        container.persistentStoreDescriptions = [
            cloudStoreDescription,
            localStoreDescription
        ]
        return container
    }()
    
    static var preview: StoryCloudKitData = {
        StoryCloudKitData(preview: true)
    }()
    
    init(preview: Bool = false) {
        if preview {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "dev/null")
        }
        
#if DEBUG
        do {
            // Use the container to initialize the development schema.
            try container.initializeCloudKitSchema(options: [.printSchema])
        } catch {
            // Handle any errors.
        }
#endif
        container.loadPersistentStores { (storeDescription, error) in
            if let nserror = error as? NSError {
                fatalError("unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
