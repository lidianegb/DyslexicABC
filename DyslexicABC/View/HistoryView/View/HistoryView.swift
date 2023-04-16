//
//  HistoryView.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 26/12/22.
//

import SwiftUI
import AVFoundation
import Combine

struct HistoryView: View {
    @StateObject var viewModel: HistoryViewModel = HistoryViewModel()
    
    @State private var currentTime: String = "0:00"
    @State private var playerState: PlayerState = .stoped
    
    private var dataInfo: HomeItem
    private var buttonSize = CGSize(width: 50, height: 50)
    private var playPauseImage: String {
        playerState == .playing ? "pause.fill" : "play.fill"
    }
    private var stopImage = "stop.fill"
    
    @State var timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    init(_ dataInfo: HomeItem) {
        self.dataInfo = dataInfo
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text(dataInfo.showTitle)
                    .font(.custom(FontName.openDyslexic.rawValue, size: Metrics.medium))
                    .padding([.bottom])
                Text(viewModel.attributedText)
                    .font(.openDyslexic)
                    .padding([.bottom])
                
                Text(currentTime)
                    .font(.custom(FontName.openDyslexic.rawValue, size: Metrics.big))
                    .onReceive(NotificationCenter.default.publisher(for: Notification.Name.currentTimePlayer)) { output in
                        currentTime = output.object as? String ?? "0:00"
                    }
                    .onReceive(NotificationCenter.default.publisher(for: Notification.Name.audioPlayerFinished)) { _ in
                        timer.upstream.connect().cancel()
                        playerState = .stoped
                        viewModel.stopAudioPlayer()
                    }
                PlayerViewTest(stopButtonImage: stopImage, playPauseImage: playPauseImage, buttonSize: buttonSize, playAction: {
                    if playerState == .playing {
                        playerState = .paused
                        viewModel.pauseAudioPlayer()
                    } else {
                        timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
                        playerState = .playing
                        viewModel.startAudioPlayer()
                    }
                }, stopAction: {
                    timer.upstream.connect().cancel()
                    playerState = .stoped
                    viewModel.stopAudioPlayer()
                })
            }
            .padding()
        }
        .onReceive(timer) { _ in
            viewModel.updateText()
        }
        .onAppear {
            viewModel.setupData(dataInfo)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(HomeItem())
    }
}
