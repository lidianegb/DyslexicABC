//
//  HomeView.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 27/03/23.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    private var columns = [
        GridItem(.flexible(), spacing: Metrics.small),
        GridItem(.flexible(), spacing: Metrics.small),
        GridItem(.flexible(), spacing: Metrics.small)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.homeData?.showListHistory ?? [], id: \.id) { history in
                            CardHistory(entity: history, totalColumns: CGFloat(columns.count)
                            )
                            .onTapGesture {
                                Coordinator.shared.goToHistoryScreen(history)
                            }
                        }
                    }
                }
            }
            
            .padding(Metrics.medium)
            .navigationTitle(viewModel.homeData?.title ?? "")
            .font(.openDyslexic)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
