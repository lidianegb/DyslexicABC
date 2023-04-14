//
//  StoryViewModel.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 31/01/23.
//

import SwiftUI
import CoreData

public class HistoryViewModel: ObservableObject {
    @Published var historyData: HistoryData?
    @Published var attributedText = AttributedString()
    @Published var isLoadingData: Bool = true

    private enum LocalMetrics {
        static let hundred: CGFloat = 100
        static let offset = 1
    }
    
    private enum Constants {
        static let fileExtension = "mp3"
    }

    private var dbContext: NSManagedObjectContext = ApplicationData.container.viewContext
    private var player: PlayerManager?
    private var textPlayerPositions = [String: Range<String.Index>]()
    
    private var formatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [ .pad ]
        return formatter
    }
   
    public func setupData(_ homeItem: HomeItem) {
        historyData = fetchData(homeItem.id ?? "")

        if historyData == nil {
            readDataFromFiles(homeItem.showFile, id: homeItem.id ?? "")
        }
        
        player =  PlayerManager(resourceName: homeItem.showAudio, resourceType: Constants.fileExtension)
        attributedText = AttributedString(historyData?.showText ?? "")
        populateTextPlayerPositions()
        isLoadingData = false
    }
    
    // MARK: PRIVATE
    
    private func fetchData(_ id: String) -> HistoryData? {
        let predicate = NSPredicate(format: "id == %@", id)
        let fetchRequest = NSFetchRequest<HistoryData>(entityName: "HistoryData")
        fetchRequest.predicate = predicate
        let list = try? self.dbContext.fetch(fetchRequest)
        return list?.first
    }
    
    private func readDataFromFiles(_ fileName: String, id: String) {
        let codableData = getHistoryData(fileName)
        historyData = createStoryDataModel(codableData, id: id)
        Task(priority: .high) {
            await ApplicationData.saveContext()
        }
    }
    
    private func getHistoryData(_ fileName: String) -> HistoryCodableData? {
        return ReadJsonData<HistoryCodableData>(resourceName: fileName).data
    }
    
    private func createStoryDataModel(_ data: HistoryCodableData?, id: String) -> HistoryData? {
        guard let data else { return nil }
        let newData = HistoryData(context: self.dbContext)
        newData.id = id
        newData.title = data.title
        newData.image = data.image
        newData.author = data.author
        newData.text = data.text
        
        var storyTimes: [HistoryTime] = []
        data.times.forEach { time in
            let newTime = createStoryDataTimesModel(time)
            newTime.history = newData
            storyTimes.append(newTime)
        }
        newData.times = NSOrderedSet(array: storyTimes)
        
        var storyWords: [HistoryWord] = []
        data.words.forEach { word in
            let newWord = createStoryDataWordsModel(word)
            newWord.history = newData
            storyWords.append(newWord)
        }
        newData.words = NSOrderedSet(array: storyWords)
        
        return newData
    }
    
    private func createStoryDataTimesModel(_ data: HistoryCodableTime) -> HistoryTime {
        let newData = HistoryTime(context: self.dbContext)
        newData.timestamp = data.timestamp
        newData.word = data.word
        return newData
    }
    
    private func createStoryDataWordsModel(_ data: HistoryCodableWord) -> HistoryWord {
        let newData = HistoryWord(context: self.dbContext)
        newData.word = data.word
        newData.syllables = data.syllables
        return newData
    }
    
    private func generateRanges(with components: [String]) -> [Range<String.Index>]{
        guard let historyData else { return [] }
        var ranges = [Range<String.Index>]()
        var startIndex: String.Index = historyData.showText.startIndex

        for word in components {
            let endIndex = historyData.showText.index(startIndex, offsetBy: word.count)
            let range = startIndex..<endIndex
            
            ranges.append(range)
            if historyData.showText.endIndex > endIndex {
                startIndex = historyData.showText.index(endIndex, offsetBy: LocalMetrics.offset)
            }
        }
      return ranges
    }
    
    private func populateTextPlayerPositions() {
        guard let historyData else { return }
        let textComponents = historyData.showText.components(separatedBy: " ")
        let ranges = generateRanges(with: textComponents)
        
        if ranges.count == historyData.showTimes.count {
            for (index, time) in historyData.showTimes.enumerated() {
                textPlayerPositions[time.timestamp ?? ""] = ranges[index]
            }
        }
    }
    
    private func stringFromTimeInterval(interval: TimeInterval) -> String {
        let ti = CGFloat(interval)
        let doubleValue = Double(round(LocalMetrics.hundred * ti) / LocalMetrics.hundred)
        return String(doubleValue)
    }
    
    private func updateAttributedText(_ range: Range<String.Index>, text: String) -> AttributedString {
        var attributedString = AttributedString(text)
        if let newRange = Range(range, in: attributedString) {
            attributedString[newRange].foregroundColor = .red
        }
        return attributedString
    }
    
    // MARK: PUBLIC
    
    public func updateText() {
        guard let historyData, let audioPlayer = player?.audioPlayer else { return }
        let currentTime = stringFromTimeInterval(interval: audioPlayer.currentTime)
        if let range = textPlayerPositions[currentTime] {
            self.attributedText = updateAttributedText(range, text: historyData.showText)
        }
    }
    
    public func startAudioPlayer() {
        player?.play()
    }
    
    public func pauseAudioPlayer() {
        switch player?.state {
        case .stoped:
            startAudioPlayer()
        case .paused:
            player?.play()
        case .playing:
            player?.pause()
        default: break
        }
    }
    
    public func stopAudioPlayer() {
        guard let historyData else { return }
        attributedText = AttributedString(historyData.showText)
        player?.stop()
    }
}
