//
//  StoryViewModel.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 31/01/23.
//

import SwiftUI
import CoreData

public class StoryViewModel: ObservableObject {
    
    private enum LocalMetrics {
        static let hundred: CGFloat = 100
        static let offset = 1
    }
    
    private enum Constants {
        static let fileExtension = "mp3"
    }
    
    @Published var attributedText: AttributedString
    
    var storyData: StoryDataModel? {
        didSet {
            attributedText = AttributedString(storyData?.showText ?? "")
            populateTextPlayerPositions()
        }
    }
    
    private var player: PlayerManager
    private var textPlayerPositions = [String: Range<String.Index>]()
    
    private var formatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [ .pad ]
        return formatter
    }
    
    init(playerName: String) {
        player =  PlayerManager(resourceName: playerName, resourceType: Constants.fileExtension)
        attributedText = AttributedString(storyData?.showText ?? "")
    }
    
    // MARK: PRIVATE
    
    private func generateRanges(with components: [String]) -> [Range<String.Index>]{
        guard let storyData else { return [] }
        var ranges = [Range<String.Index>]()
        var startIndex: String.Index = storyData.showText.startIndex

        for word in components {
            let endIndex = storyData.showText.index(startIndex, offsetBy: word.count)
            let range = startIndex..<endIndex
            
            ranges.append(range)
            if storyData.showText.endIndex > endIndex {
                startIndex = storyData.showText.index(endIndex, offsetBy: LocalMetrics.offset)
            }
        }
      return ranges
    }
    
    private func populateTextPlayerPositions() {
        guard let storyData else { return }
        let textComponents = storyData.showText.components(separatedBy: " ")
        let ranges = generateRanges(with: textComponents)
        
        if ranges.count == storyData.showTimes.count {
            for (index, time) in storyData.showTimes.enumerated() {
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
        guard let storyData, let audioPlayer = player.audioPlayer else { return }
        let currentTime = stringFromTimeInterval(interval: audioPlayer.currentTime)
        if let range = textPlayerPositions[currentTime] {
            self.attributedText = updateAttributedText(range, text: storyData.showText)
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
        guard let storyData else { return }
        attributedText = AttributedString(storyData.showText)
        player.stop()
    }
}
