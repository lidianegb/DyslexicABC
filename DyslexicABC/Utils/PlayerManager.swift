//
//  PlayerManager.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 06/02/23.
//

import AVFoundation
import Combine

enum PlayerState: String {
    case stoped, playing, paused
}

final class PlayerManager: NSObject, ObservableObject {
    @Published var audioPlayer: AVAudioPlayer?
    @Published var currentTime: TimeInterval?
    
    var resourceName: String
    var resourceType: String
    
    init(resourceName: String, resourceType: String) {
        self.resourceName = resourceName
        self.resourceType = resourceType
        super.init()
        setupAudio()
    }
    
    private func setupAudio() {
        if let sound = Bundle.main.url(forResource: resourceName, withExtension: resourceType) {
            self.audioPlayer = try? AVAudioPlayer(contentsOf: sound)
            self.audioPlayer?.delegate = self
            self.currentTime = audioPlayer?.currentTime
            self.audioPlayer?.prepareToPlay()
            formatDurationAudioPlayer()
        }
    }
    
    private func formatDurationAudioPlayer() {
        guard let audioPlayer else { return }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second, .nanosecond]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [ .pad ]
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            let formattedProgress = formatter.string(from: TimeInterval(audioPlayer.currentTime)) ?? "00:00"
            NotificationCenter.default.post(name: Notification.Name.currentTimePlayer, object: formattedProgress)
        }
    }
    
    public func play() {
        audioPlayer?.play()
    }
    
    public func pause() {
        audioPlayer?.pause()
    }
    
    public func stop() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = .zero
    }
}

extension PlayerManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        NotificationCenter.default.post(name: Notification.Name.audioPlayerFinished, object: flag)
    }
}
