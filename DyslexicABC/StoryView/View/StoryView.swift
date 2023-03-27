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
    @StateObject var viewModel = StoryViewModel(resourceName: "a-estrelinha-do-mar", playerName: "a-estrelinha-do-mar-historinha-infantil-historia-curta")
    @State var timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        ScrollView {
            VStack() {
                Text(viewModel.attributedText)
                Button {
                    timer = Timer
                        .publish(every: 0.01, on: .main, in: .common)
                        .autoconnect()
                    viewModel.startAudioPlayer()
                } label: {
                    Text("Start")
                        .font(.custom("open-dyslexic", size: 50))
                }
                Button {
                    viewModel.pauseAudioPlayer()
                } label: {
                    Text("Pause")
                }
                
                Button {
                    timer.upstream.connect().cancel()
                    viewModel.stopAudioPlayer()
                } label: {
                    Text("Stop")
                }
            }.padding()
        }
        .onReceive(timer) { _ in
            viewModel.updateText()
        }
    }
  
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        StoryView()
    }
}
