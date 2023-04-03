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
    
    private let storyCodableData: StoryCodableData?
    private let jsonData: ReadJsonData<StoryCodableData>
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
        jsonData = ReadJsonData<StoryCodableData>(resourceName: resourceName)
        player =  PlayerManager(resourceName: playerName, resourceType: "mp3")
        storyCodableData = jsonData.data
        attributedText = AttributedString(storyCodableData?.text ?? "")
       
        populateTextPlayerPositions()
    }
    
    // MARK: PRIVATE
    
    private func generateRanges(with components: [String]) -> [Range<String.Index>]{
        guard let storyCodableData else { return [] }

        var ranges = [Range<String.Index>]()
        var startIndex: String.Index = storyCodableData.text.startIndex

        for word in components {
            let endIndex = storyCodableData.text.index(startIndex, offsetBy: word.count)
            let range = startIndex..<endIndex
            
            ranges.append(range)
            if storyCodableData.text.endIndex > endIndex {
                startIndex = storyCodableData.text.index(endIndex, offsetBy: 1)
            }
        }
      return ranges
    }
    
    private func populateTextPlayerPositions() {
        guard let storyCodableData else { return }
        let textComponents = storyCodableData.text.components(separatedBy: " ")
        let ranges = generateRanges(with: textComponents)
        
        if ranges.count == storyCodableData.times.count {
            for (index, time) in storyCodableData.times.enumerated() {
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
        guard let audioPlayer = player.audioPlayer, let storyCodableData else { return }
        let currentTime = stringFromTimeInterval(interval: audioPlayer.currentTime)
        if let range = textPlayerPositions[currentTime] {
            self.attributedText = updateAttributedText(range, text: storyCodableData.text)
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
        attributedText = AttributedString(storyCodableData?.text ?? "")
        player.stop()
    }
    
}
