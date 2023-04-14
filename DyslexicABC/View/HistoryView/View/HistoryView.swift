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
            ZStack {
                VStack {
                    Text(dataInfo.showTitle)
                        .font(.custom(FontName.openDyslexic.rawValue, size: Metrics.medium))
                        .padding([.bottom])
                    Text(viewModel.attributedText)
                        .font(.openDyslexic)
                }
                .opacity(viewModel.isLoadingData ? 0 : 1)
        
                ProgressView()
                    .progressViewStyle(.circular)
                    .opacity(viewModel.isLoadingData ? 1 : .zero)
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
