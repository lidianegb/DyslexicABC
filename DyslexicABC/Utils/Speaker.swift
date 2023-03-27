//
//  Speaker.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 31/01/23.
//

import SwiftUI
import UIKit
import AVFoundation

final class Speaker: NSObject, ObservableObject {
    @Published var state: State = .inactive
    @Published var label = AttributedString()
    var highlightedTextColor: Color = .red
    var rate: Float = 0.4
    var range: Range<String.Index>?
    
    private let synth = AVSpeechSynthesizer()
    
    enum State: String {
        case inactive, speaking, paused
    }
    
    convenience init(text: String, highlightedTextColor: Color = .red, rate: Float = 0.4) {
        self.init()
        label = AttributedString(text)
        self.highlightedTextColor = highlightedTextColor
        self.rate = rate
        synth.delegate = self
    }
    
    func speak() {
        let utterance = AVSpeechUtterance(string: label.description)
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        utterance.volume = 0.8
        utterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
        utterance.rate = rate
        synth.speak(utterance)
        
        var attributedString = AttributedString(utterance.speechString)
        if let range = range, let newRange = Range(range, in: attributedString) {
            attributedString[newRange].foregroundColor = highlightedTextColor
        }
        label = attributedString
    }
    
    func pause() {
        synth.pauseSpeaking(at: AVSpeechBoundary.word)
    }
    
    func stop() {
        synth.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    func continueSpeaking() {
        synth.continueSpeaking()
    }
}

extension Speaker: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.state = .speaking
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        self.state = .paused
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        var attributedString = AttributedString(utterance.speechString)
        if let range = range, let newRange = Range(range, in: attributedString) {
            attributedString[newRange].foregroundColor = highlightedTextColor
        }
        label = attributedString
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        state = .inactive
        label = AttributedString(utterance.speechString)
    }
}
