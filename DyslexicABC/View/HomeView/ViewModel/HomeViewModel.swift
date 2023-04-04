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
    @Published var homeData: HomeDataModel?
    var dbContext: NSManagedObjectContext = ApplicationData().container.viewContext
   
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
            await saveContext()
        }
    }
    
    private func saveContext() async {
        await dbContext.perform {
            do {
                try self.dbContext.save()
            } catch {
                // TODO: SHOW ERROR
            }
        }
    }
    
    private func fetchData() -> HomeDataModel? {
        let request: NSFetchRequest<HomeDataModel> = HomeDataModel.fetchRequest()
        let list = try? self.dbContext.fetch(request)
        return list?.first
    }
    
    private func createHomeDataModel(_ data: HomeCodableData?) -> HomeDataModel? {
        guard let data else { return nil }
        let newData = HomeDataModel(context: self.dbContext)
        newData.title = data.title
        let filesNames: [String] = data.listHistory.map { $0.file }
        newData.listHistory = NSOrderedSet(array: getListHistoryData(filesNames))
        
        return newData
    }
    
    private func getHomeData() -> HomeCodableData? {
        return ReadJsonData<HomeCodableData>(resourceName: "home").data
    }
    
    private func getListHistoryData(_ fileNames: [String]) -> [StoryDataModel] {
        var historyList: [StoryDataModel] = []
        fileNames.forEach { name in
            if let jsonData = ReadJsonData<StoryCodableData>(resourceName: name).data {
                let newItem = createStoryDataModel(jsonData)
                historyList.append(newItem)
            }
        }
      return historyList
    }
    
    private func createStoryDataModel(_ data: StoryCodableData) -> StoryDataModel {
        let newData = StoryDataModel(context: self.dbContext)
        newData.title = data.title
        newData.image = data.image
        newData.author = data.author
        newData.text = data.text
        
        var storyTimes: [StoryDataTimesModel] = []
        data.times.forEach { time in
            let newTime = createStoryDataTimesModel(time)
            newTime.dataModel = newData
            storyTimes.append(newTime)
        }
        newData.times = NSOrderedSet(array: storyTimes)
        
        var storyWords: [StoryDataWordsModel] = []
        data.words.forEach { word in
            let newWord = createStoryDataWordsModel(word)
            newWord.dataModel = newData
            storyWords.append(newWord)
        }
        newData.words = NSOrderedSet(array: storyWords)
        
        return newData
    }
    
    private func createStoryDataTimesModel(_ data: StoryCodableDataTimes) -> StoryDataTimesModel {
        let newData = StoryDataTimesModel(context: self.dbContext)
        newData.timestamp = data.timestamp
        newData.word = data.word
        return newData
    }
    
    private func createStoryDataWordsModel(_ data: StoryCodableDataWords) -> StoryDataWordsModel {
        let newData = StoryDataWordsModel(context: self.dbContext)
        newData.word = data.word
        newData.syllables = data.syllables
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
