//
//  StoryView.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 26/12/22.
//

import SwiftUI
import AVFoundation
import Combine

struct StoryView: View {
    @StateObject var viewModel = StoryViewModel()
    @State var player = PlayerManager(resourceName: "a-estrelinha-do-mar-historinha-infantil-historia-curta", resourceType: "mp3")
    @State var currentTimeSTR = String()
    @State var currentTime: String = ""
    @StateObject var speechRecognition = SpeechRecognition()
    
    var formatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [ .pad ]
        return formatter
    }
    @State var timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    var body: some View {
        ScrollView {
            VStack() {
                Text(viewModel.attributedText)
               
                Button {
                    player.play()
                    timer = Timer
                        .publish(every: 0.01, on: .main, in: .common)
                        .autoconnect()
                    
                } label: {
                    Text("Start")
                        .font(.custom("open-dyslexic", size: 50))
                }
               // Text(currentTimeSTR)
               // Text(currentTime)
                Button {
                    switch player.state {
                    case .stoped:
                      
                        player.play()
                    case .paused:
                        player.play()
                    case .playing:
                        player.pause()
                    }
                } label: {
                    Text("Pause")
                }
                
                Button {
                    timer.upstream.connect().cancel()
                    player.stop()
                } label: {
                    Text("Stop")
                }
            }.padding()
        }
        .onReceive(timer) { _ in
            guard let audioPlayer = player.audioPlayer else { return }
            currentTimeSTR = (formatter.string(from: TimeInterval(audioPlayer.currentTime)) ?? "")
            currentTime = stringFromTimeInterval(interval: audioPlayer.currentTime)
            viewModel.updateAttributedText(currentTime)
        }
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let ti = CGFloat(interval)
        let doubleValue = Double(round(100 * ti) / 100)
        return String(doubleValue)
    }
    
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        StoryView()
    }
}
