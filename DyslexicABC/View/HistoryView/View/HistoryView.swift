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
    private var dataInfo: HomeItem
    
    @StateObject var viewModel: HistoryViewModel = HistoryViewModel()
    
    @State var timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    init(_ dataInfo: HomeItem) {
        self.dataInfo = dataInfo
    }
    
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
