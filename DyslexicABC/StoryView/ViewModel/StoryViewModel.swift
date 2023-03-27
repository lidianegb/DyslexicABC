//
//  StoryViewModel.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 31/01/23.
//

import SwiftUI

public class StoryViewModel: ObservableObject {
    private let storyData: StoryData?
    private let jsonData = ReadJsonData<StoryData>(resourceName: "a-estrelinha-do-mar")
  
    private var textPlayerPositions = [String: Range<String.Index>]()
    
    @Published var attributedText: AttributedString
    
    init() {
        storyData = jsonData.data
        attributedText = AttributedString(storyData?.text ?? "")
        let textComponents = storyData?.text.components(separatedBy: " ")
        let textRanges = generateRanges(with: textComponents ?? [])
        populateTextPlayerPositions(textRanges)
    }
    
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
    
    private func populateTextPlayerPositions(_ ranges: [Range<String.Index>]) {
        guard let storyData else { return }
        
        if ranges.count == storyData.times.count {
            for (index, time) in storyData.times.enumerated() {
                textPlayerPositions[time.timestamp] = ranges[index]
            }
        }
    }
    
    
    public func updateAttributedText(_ value: String) {
        if let range = textPlayerPositions[value] {
            var attributedString = AttributedString(storyData?.text ?? "")
            if let newRange = Range(range, in: attributedString) {
                attributedString[newRange].foregroundColor = .red
            }
            self.attributedText = attributedString
        }
    }
}
