//
//  StoryViewModel.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 31/01/23.
//

import SwiftUI
import CoreData

public class StoryViewModel: ObservableObject {
    @Published var attributedText: AttributedString
    
    private let storyData: StoryData?
    private let jsonData: ReadJsonData<StoryData>
    private var player: PlayerManager
    private var textPlayerPositions = [String: Range<String.Index>]()
    private var formatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [ .pad ]
        return formatter
    }
    
    init(resourceName: String, playerName: String) {
        jsonData = ReadJsonData<StoryData>(resourceName: resourceName)
        player =  PlayerManager(resourceName: playerName, resourceType: "mp3")
        storyData = jsonData.data
        attributedText = AttributedString(storyData?.text ?? "")
       
        populateTextPlayerPositions()
    }
    
    // MARK: PRIVATE
    
    private func generateRanges(with components: [String]) -> [Range<String.Index>]{
        guard let storyData else { return [] }

        var ranges = [Range<String.Index>]()
        var startIndex: String.Index = storyData.text.startIndex

        for word in components {
            let endIndex = storyData.text.index(startIndex, offsetBy: word.count)
            let range = startIndex..<endIndex
            
            ranges.append(range)
            if storyData.text.endIndex > endIndex {
                startIndex = storyData.text.index(endIndex, offsetBy: 1)
            }
        }
      return ranges
    }
    
    private func populateTextPlayerPositions() {
        guard let storyData else { return }
        let textComponents = storyData.text.components(separatedBy: " ")
        let ranges = generateRanges(with: textComponents)
        
        if ranges.count == storyData.times.count {
            for (index, time) in storyData.times.enumerated() {
                textPlayerPositions[time.timestamp] = ranges[index]
            }
        }
    }
    
    private func stringFromTimeInterval(interval: TimeInterval) -> String {
        let ti = CGFloat(interval)
        let doubleValue = Double(round(100 * ti) / 100)
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
        guard let audioPlayer = player.audioPlayer, let storyData else { return }
        let currentTime = stringFromTimeInterval(interval: audioPlayer.currentTime)
        if let range = textPlayerPositions[currentTime] {
            self.attributedText = updateAttributedText(range, text: storyData.text)
        }
    }
    
    public func startAudioPlayer() {
        player.play()
    }
    
    public func pauseAudioPlayer() {
        switch player.state {
        case .stoped:
            startAudioPlayer()
        case .paused:
            player.play()
        case .playing:
            player.pause()
        }
    }
    
    public func stopAudioPlayer() {
        attributedText = AttributedString(storyData?.text ?? "")
        player.stop()
    }
    
}
