//
//  HomeViewModel.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 27/03/23.
//

import Foundation
import CoreData
import SwiftUI

public class HomeViewModel: ObservableObject {
    @Published var homeData: HomeData?
    
    var dbContext: NSManagedObjectContext = ApplicationData.container.viewContext
   
    public init() {
        homeData = fetchData()
    
        if homeData == nil {
            readDataFromFiles()
        }
    }
    
    // MARK: PRIVATE
    
    private func readDataFromFiles() {
        let codableData = getHomeData()
        homeData = createHomeDataModel(codableData)
        Task(priority: .high) {
            await ApplicationData.saveContext()
        }
    }
    
    private func fetchData() -> HomeData? {
        let request: NSFetchRequest<HomeData> = HomeData.fetchRequest()
        let list = try? self.dbContext.fetch(request)
        return list?.first
    }
    
    private func createHomeDataModel(_ data: HomeCodableData?) -> HomeData? {
        guard let data else { return nil }
        let newData = HomeData(context: self.dbContext)
        newData.title = data.title
        newData.listHistory = NSOrderedSet(array: getListHomeItemData(data.listHistory))
        
        return newData
    }
    
    private func getHomeData() -> HomeCodableData? {
        return ReadJsonData<HomeCodableData>(resourceName: "home").data
    }
    
    private func getListHomeItemData(_ list: [HomeCodableItem]) -> [HomeItem] {
        var historyList: [HomeItem] = []
        list.forEach { data in
            let newItem = createHomeItemModel(data)
            historyList.append(newItem)
        }
      return historyList
    }
    
    private func createHomeItemModel(_ data: HomeCodableItem) -> HomeItem {
        let newData = HomeItem(context: self.dbContext)
        newData.id = UUID().uuidString
        newData.image = data.image
        newData.audio = data.audio
        newData.file = data.file
        newData.title = data.title
        return newData
    }
    
    private func clearAllData() async {
        guard let homeData else { return }
        await dbContext.perform {
            self.dbContext.delete(homeData)
        }
        do {
            try dbContext.save()
        } catch {
            print("error deleting objects")
        }
    }
}
