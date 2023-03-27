//
//  PlayerManager.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 06/02/23.
//

import AVFoundation
import Combine

final class PlayerManager: ObservableObject {
    var state: State = .stoped
    @Published var audioPlayer: AVAudioPlayer?
    @Published var currentTime: TimeInterval?
    var formattedProgress: String = "00:00"
    
    var resourceName: String
    var resourceType: String
    
    enum State: String {
        case stoped, playing, paused
    }
    
    init(resourceName: String, resourceType: String) {
        self.resourceName = resourceName
        self.resourceType = resourceType
        setupAudio()
    }
    
    private func setupAudio() {
        if let sound = Bundle.main.url(forResource: resourceName, withExtension: resourceType) {
            self.audioPlayer = try? AVAudioPlayer(contentsOf: sound)
            self.currentTime = audioPlayer?.currentTime
            self.audioPlayer?.prepareToPlay()
            formatDurationAudioPlayer()
        }
    }
    
    private func formatDurationAudioPlayer() {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second, .nanosecond]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [ .pad ]
        
//        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
//            if !self.audioPlayer!.isPlaying {
//                self.state = .stoped
//            }
//            self.formattedProgress = formatter.string(from: TimeInterval(self.audioPlayer!.currentTime))!
//        }
    }
    
    public func play() {
        state = .playing
        audioPlayer?.play()
    }
    
    public func pause() {
        state = .paused
        audioPlayer?.pause()
    }
    
    public func stop() {
        state = .stoped
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
    }
}
